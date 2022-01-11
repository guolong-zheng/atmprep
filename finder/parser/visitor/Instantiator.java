package parser.visitor;

import compare.AlloySolution;
import edu.mit.csail.sdg.alloy4.ConstList;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import parser.ast.*;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

// if there is skolem, then use skolem and compare with difference
// if there is no skolem, use difference atoms
public class Instantiator implements GenericVisitor<Set<String>, Boolean> {

    AlloySolution sol;
    Set<String> skolems;
    Map<String, Set<String>> skolemSig2Val;

    // map decled variable name to set of possible values
    Map<String, Set<String>> varname2vals;

    public Set<String> instatiatedExprs;

    public Instantiator(AlloySolution sol, Set<String> skolems){
        this.sol = sol;
        this.skolems = skolems;
        skolemSig2Val = new HashMap<>();
        instatiatedExprs = new HashSet<>();
        for( String skolem : skolems ){
            // keep direct sig and parent sigs
            Set<String> sigNames = new HashSet<>();
            String sigName = StringUtil.findSigName(skolem);

            sigNames.add(sigName);
            // check if there is any parent
            Sig sig = sol.getSig(sigName);
            if( sig == null)
                continue;
            if (sig instanceof Sig.PrimSig) {
                Sig parent = ((Sig.PrimSig)sig).parent;
                if (parent!=null && !parent.builtin)
                    sigNames.add( StringUtil.removeThis(parent.toString()) );
            } else {
                ConstList<Sig> parents = ((Sig.SubsetSig)sig).parents;
                for(Sig p: parents)
                    sigNames.add(p.toString());
            }

            for( String name : sigNames) {
                Set<String> vals = skolemSig2Val.get(name);
                if (vals == null)
                    vals = new HashSet<>();
                vals.add(skolem);
                skolemSig2Val.put(name, vals);
            }
        }
        //System.out.println(skolemSig2Val.toString());
    }

    @Override
    public Set<String> visit(DeclField decl, Boolean arg) {
        Set<String> res = (Set)decl.getExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(DeclParam decl, Boolean arg) {
        Set<String> res = (Set)decl.getExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(DeclVar decl, Boolean arg) {
        Set<String> res = (Set) decl.getExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(Fact fact, Boolean arg) {
        Set<String> res = (Set)fact.getExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(Predicate pred, Boolean arg) {
        Set<String> res = new HashSet<>();
        pred.getParams().forEach(declParam -> declParam.accept(this, arg));
        pred.getBody().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(Function func, Boolean arg) {
        Set<String> res = new HashSet<>();
        func.getParams().forEach(param -> param.accept(this, arg));
        func.getBody().accept(this, arg);
        func.getReturnExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(Template t, Boolean arg) {
        return null;
    }

    @Override
    public Set<String> visit(Hole h, Boolean arg) {
        return null;
    }

    @Override
    public Set<String> visit(ExprnBinaryBool expr, Boolean arg) {
        Set<String> words = new HashSet<>();
        expr.getLeft().accept(this, arg);
        expr.getRight().accept(this, arg);
        return words;
    }

    @Override
    public Set<String> visit(ExprnBinaryRel expr, Boolean arg) {
        Set<String> exprStrs = new HashSet<>();
        Boolean topLevel = arg;
        if(arg)
            arg = false;
        Set<String> leftExpr = (Set<String>) expr.getLeft().accept(this, arg);
        Set<String> rightExpr = (Set<String>) expr.getRight().accept(this, arg);
        String op;
        switch(expr.getOp()){
            case ARROW:
            case ANY_ARROW_SOME:
            case ANY_ARROW_ONE:
            case ANY_ARROW_LONE:
            case SOME_ARROW_ANY:
            case SOME_ARROW_SOME:
            case SOME_ARROW_ONE:
            case SOME_ARROW_LONE:
            case ONE_ARROW_ANY:
            case ONE_ARROW_SOME:
            case ONE_ARROW_ONE:
            case ONE_ARROW_LONE:
            case LONE_ARROW_ANY:
            case LONE_ARROW_SOME:
            case LONE_ARROW_ONE:
            case LONE_ARROW_LONE:
            case ISSEQ_ARROW_LONE:
                op = "->";
                break;
            default:
                op = expr.getOp().toString();
                break;
        }
        for( String l : leftExpr ){
            for( String r : rightExpr ){
                String res = "("+l+op+r+")";
                exprStrs.add(res);
                if(topLevel)
                    instatiatedExprs.add(res);
            }
        }

        return exprStrs;
    }

    @Override
    public Set<String> visit(ExprnCallBool expr, Boolean arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        Predicate pred = (Predicate) expr.getNodeMap().findFunc(fname);
        return pred.accept(this, arg);
    }

    @Override
    public Set<String> visit(ExprnCallRel expr, Boolean arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        if (fname.startsWith("integer")) {
            return new HashSet<>();
        }
        Function fun = (Function) expr.getNodeMap().findFunc(fname);
        return fun.accept(this, arg);
    }

    @Override
    public Set<String> visit(ExprnConst expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        res.add(expr.getOp().toString());
        return res;
    }

    @Override
    public Set<String> visit(ExprnField expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        res.add(expr.getName());
        return res;
    }

    @Override
    public Set<String> visit(ExprnITEBool expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        Set<String> condStr = (Set) expr.getCondition().accept(this, arg);
        Set<String> thenStr = (Set) expr.getThenClause().accept(this, arg);
        Set<String> elseStr = (Set) expr.getElseClause().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(ExprnITERel expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        res.addAll((Set) expr.getCondition().accept(this, arg));
        res.addAll((Set) expr.getThenClause().accept(this, arg));
        res.addAll((Set) expr.getElseClause().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(ExprnLet expr, Boolean arg) {
       // expr.getVar().accept(this, arg);
        expr.getExpr().accept(this, arg);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Set<String> visit(ExprnListBool expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        expr.getArgs().forEach(ag -> {
             ag.accept(this, arg);
        });
        return res;
    }

    @Override
    public Set<String> visit(ExprnListRel expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        expr.getArgs().forEach(ag -> {
            ag.accept(this, arg);
        });
        return res;
    }

    @Override
    public Set<String> visit(ExprnQtBool expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        expr.getVars().forEach(var -> {
            var.accept(this, arg);
        });
        expr.getSub().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(ExprnQtRel expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        expr.getVars().forEach(var -> {
            res.addAll((Set) var.accept(this, arg));
        });
        expr.getSub().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(ExprnSig expr, Boolean arg) {
        Set<String> res = skolemSig2Val.get(expr.toString());
        if(res == null) {
            Set<String> newRes = new HashSet<>();
            newRes.add(expr.toString());
            return newRes;
        }else
            return res;
       // return skolemSig2Val.get(expr.toString());
    }

    @Override
    public Set<String> visit(ExprnVar expr, Boolean arg) {
        Exprn exprn = expr.getBindExpr();
        Set<String> res = new HashSet<>();
        // for decled vars, if it is decled to a binary expression, try to find if it is a skolem variable;
        // if so, use the skolem val for the return; else, use its binded express
        // for example:
        // all b : Book | all n : b.entry
        // skolem = {Book$0, Name$1}   Book$0.entry = {Name$0, Name$1}
        // n is binded to Book$0.entry which contains a common val to skolem, so n => {Name$1}
        for( String s : exprn.accept(this, arg)) {
            if( s.contains(".")) {
                String sigName = StringUtil.trimTypeStr( exprn.getType().toString() );
                Set<String> skolemVals = skolemSig2Val.get(sigName);
                if( skolemVals != null)
                  skolemVals = new HashSet<>( skolemSig2Val.get(sigName) );
                Set<String> evalVals = sol.evalInstantiated(s);
                if( skolemVals != null){
                    skolemVals.retainAll(evalVals);
                    return skolemVals;
                }
            }
        }
        return expr.getBindExpr().accept(this, arg);
    }

    @Override
    public Set<String> visit(ExprnUnaryBool expr, Boolean arg) {
        Set<String> res = new HashSet<>();
        Exprn sub = expr.getSub();
        sub.accept(this, arg);
        return res;
    }

    // instantiate unary exprn
    @Override
    public Set<String> visit(ExprnUnaryRel expr, Boolean arg) {
        Exprn sub = expr.getSub();
        Set<String> subStrs = (Set) sub.accept(this, false);
        Set<String> exprStrs = new HashSet<>();
        String prefix;
        switch(expr.op){
            case SOME:
            case LONE:
            case ONE:
            case SET:
            case EXACTLYOF:
                arg = false;
                prefix = "";
                break;
            default:
                prefix = expr.op.toString();

        }

        for( String subStr : subStrs ){
            exprStrs.add( prefix + "(" + subStr + ")" );
            if( arg ) {
                instatiatedExprs.add(prefix + "(" + subStr + ")");
            }
            //System.out.println(exprStrs.toString());
        }
        return exprStrs;
    }

    /*
    * No need to check for the following ast node
    * */
    @Override
    public Set<String> visit(SigDef sigDef, Boolean arg) {
        return null;
    }

    @Override
    public Set<String> visit(AModel model, Boolean arg) {
        return null;
    }

    @Override
    public Set<String> visit(Assert asserts, Boolean arg) {
        return null;
    }

    @Override
    public Set<String> visit(Opens open, Boolean arg) {
        return null;
    }
}
