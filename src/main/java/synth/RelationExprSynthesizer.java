package synth;

import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import synth.varcollectors.Var;

import java.util.*;

public class RelationExprSynthesizer {

    // supported binary rel ops
    static ExprnBinaryRel.Op[] BinOps = {ExprnBinaryRel.Op.JOIN, ExprnBinaryRel.Op.INTERSECT,
            ExprnBinaryRel.Op.PLUS, ExprnBinaryRel.Op.MINUS}; //, ExprnBinaryRel.Op.ARROW};

    // supported unary rel ops
    static ExprnUnaryRel.Op[] UnaryOps = {ExprnUnaryRel.Op.TRANSPOSE, ExprnUnaryRel.Op.RCLOSURE,
            ExprnUnaryRel.Op.CLOSURE}; //, ExprnUnaryRel.Op.CARDINALITY};

    // #op to list of expressions
    public Map<Integer, List<Exprn>> candidates;

    // group generated expression by type
    Map<Type, List<Exprn>> type2exprs;

    // maximum # of operators
    int max_op;
    int max_arity;

    /**
     * @param max:   max number of operators
     * @param arity: max arity of an expression
     */
    public RelationExprSynthesizer(int max, int arity) {
        this.candidates = new HashMap<>();
        this.type2exprs = new HashMap<>();
        this.max_op = max;
        this.max_arity = arity;
    }

    /**
     * Synthesize all possible relational expressions
     *
     * @param vars: all available variables can be used at this location
     */
    public void synth(Set<Var> vars) {
        int num_op = 1;
        // Map<Integer, List<Exprn>> candidates =
        initialize(vars);
        while (num_op <= max_op) {
            setp_synth(candidates, vars, num_op);
            num_op++;
        }
    }

    // create all expression with 0 operators(var or field expressions)
    public Map<Integer, List<Exprn>> initialize(Set<Var> vars) {
        List<Exprn> exprns = new ArrayList<>();
        for (Var var : vars) {
            Exprn e;
            if (var.type.arity() == 1) {
                e = new ExprnVar(var);
            } else {
                e = new ExprnField(var);
            }
            exprns.add(e);
        }
        candidates.put(0, exprns);
        return candidates;
    }

    public void setp_synth(Map<Integer, List<Exprn>> candidates, Set<Var> vars, int step) {
        List<Exprn> last_res = candidates.get(step-1);
        List<Exprn> result = new ArrayList<>();
        for (Exprn expr : last_res) {
            result.addAll( synthUnary(expr) );
            result.addAll( synthBinary(expr, vars) );
        }
        candidates.put(step, result);
    }

    // synthesize relational unary expression
    public List<Exprn> synthUnary(Exprn expr) {
        List<Exprn> result = new ArrayList<>();
        if (expr.getType().arity() == 2) {
            // remove redundant operators
            List<ExprnUnaryRel.Op> availableOps = removeRedundantOps(expr);
            for (ExprnUnaryRel.Op op : availableOps) {
                Type resType;
                if (op == ExprnUnaryRel.Op.TRANSPOSE)
                    resType = expr.getType().transpose();
                else if( op == ExprnUnaryRel.Op.CLOSURE)
                    resType = expr.getType().closure();
                else
                   // resType = expr.getType().closure();
                    resType = Type.make2(Sig.UNIV);

                ExprnUnaryRel res = new ExprnUnaryRel(null, op, expr, resType);
                result.add(res);
            }
        }
        if (expr instanceof ExprnUnaryRel) {
            if (((ExprnUnaryRel) expr).op != ExprnUnaryRel.Op.CARDINALITY)
                result.add(new ExprnUnaryRel(null, ExprnUnaryRel.Op.CARDINALITY, expr, Type.smallIntType()));
        } else {
            result.add(new ExprnUnaryRel(null, ExprnUnaryRel.Op.CARDINALITY, expr, Type.smallIntType()));
        }
        return result;
    }

    // remove redundant unary operators to avoid expressions like ~(~right), which equals right
    public List<ExprnUnaryRel.Op> removeRedundantOps(Exprn expr) {
        List<ExprnUnaryRel.Op> availableOps = new ArrayList<>(Arrays.asList(UnaryOps));
        while (expr instanceof ExprnUnaryRel) {
            ExprnUnaryRel.Op currentOp = ((ExprnUnaryRel) expr).op;
            Iterator<ExprnUnaryRel.Op> it = availableOps.iterator();
            while (it.hasNext()) {
                if (currentOp == it.next()) {
                    it.remove();
                    break;
                }
            }
            expr = ((ExprnUnaryRel) expr).getSub();
        }
        return availableOps;
    }

    // synthesize atomic relational binary expression
    public List<Exprn> synthBinary(Exprn expr, Set<Var> vars) {
        List<Exprn> result = new ArrayList<>();
        for (Var var : vars) {
            for (ExprnBinaryRel.Op op : BinOps) {
                result.addAll(combine(expr, var, op));
            }
        }
        return result;
    }

    // building binary expressions
    public List<Exprn> combine(Exprn expr, Var var, ExprnBinaryRel.Op op) {
        boolean identical = expr.toString().replaceAll("\\s+", "").equals(var.name);

        List<Exprn> result = new ArrayList<>();
        Exprn toadd = new ExprnVar(var);
        Type exprtype = expr.getType();
        Type toaddtype = toadd.getType();
        Type restype;
        // avoid {} appear in binary expression as it won't introduce new values
        if (exprtype.hasNoTuple() || toaddtype.hasNoTuple())
            return result;
        if (identical)
            return result;
        switch (op) {
            case JOIN:
                // remove expressions like a.#b
                if (expr instanceof ExprnUnaryRel)
                    if (((ExprnUnaryRel) expr).op == ExprnUnaryRel.Op.CARDINALITY)
                        break;

                restype = exprtype.join(toaddtype);
                if (!restype.hasNoTuple())
                    result.add(new ExprnBinaryRel(expr, toadd, op, restype));
                // avoid redundant expressions like left.right and right.left
                if (!(expr instanceof ExprnVar || expr instanceof ExprnField)) {
                    restype = toaddtype.join(exprtype);
                    if (!restype.hasNoTuple())
                        result.add(new ExprnBinaryRel(toadd, expr, op, restype));
                }
                break;
            case INTERSECT:
                if (toaddtype.intersects(exprtype) && !identical) {
                    restype = toaddtype.intersect(exprtype);
                    result.add(new ExprnBinaryRel(toadd, expr, op, restype));
                }
                break;
            case PLUS:
            case MINUS:
                if (toaddtype.equals(exprtype) && !identical) {
                    result.add(new ExprnBinaryRel(toadd, expr, op, toaddtype));
                }
                break;
            case ARROW:
                 // if (exprtype.arity() <= max_arity)
                 //   result.add(new ExprnBinaryRel(toadd, expr, op, toaddtype.product(exprtype)));
                //result.add( new ExprnBinaryRel(expr, toadd, op , exprtype.product(toaddtype)));
                break;
            default:
                throw new RuntimeException("not support binary operator");
        }
        return result;
    }

    public Map<Type, List<Exprn>> groupByType(){
        Map<Type, List<Exprn>> byType = new HashMap<>();
        for( int i = 0; i <= max_op; i++){
            List<Exprn> exprns = candidates.get(i);
            for(Exprn e : exprns){
                Type t = e.getType();
                List<Exprn> list = byType.getOrDefault(t, new ArrayList<>());
                list.add(e);
                byType.put(t, list);
            }
        }
        return byType;
    }

    // check if left type can join with right type
    // return true when last sig of left equals first sig of right
    // left type: a->...->c
    // right type: c->...->b
    private boolean can_join(Type left, Type right) {
        // avoid expressions like Node.Node
        if (left.arity() == 1 && left.equals(right))
            return false;
        Iterator<Type.ProductType> it = left.iterator();
        Type.ProductType type = it.next();
        while (it.hasNext())
            type = it.next();
        Sig.PrimSig end = type.get(type.arity() - 1);

        it = right.iterator();
        type = it.next();
        Sig.PrimSig first = type.get(0);
        return first.isSameOrDescendentOf(end);
    }
}
