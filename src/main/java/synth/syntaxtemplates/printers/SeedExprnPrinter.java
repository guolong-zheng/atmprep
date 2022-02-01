package synth.syntaxtemplates.printers;

import parser.ast.*;
import synth.HoleStat;
import synth.SearchStat;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.template.seed.Seed;
import synth.varcollectors.Var;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class SeedExprnPrinter extends SeedPrinter {
    SearchStat ss ;
    Set<Var> vars;

    boolean check = false;

    public List<StringBuilder> results;

    public SeedExprnPrinter(Seed seed) {
        super(seed);
    }

    public String instantiate(SearchStat ss, Set<Var> vars) {
        this.ss = ss;
        this.vars = vars;
        results = new ArrayList<>();
        sb = new StringBuilder();
        results.add(sb);
        seed.exprn.accept(this);
        return sb.toString();
    }

    @Override
    public void visit(ValueHole expr){
        if (expr.is_atom) {
            List<StringBuilder> newsb = new ArrayList<>();
            for(StringBuilder sb : results) {
                String str = expr.atom.toString();
                StringBuilder nsb1 = new StringBuilder(sb.toString());
                nsb1.append(str.substring(0, str.indexOf("$")));
                newsb.add(nsb1);

                for (Var v : vars) {
                    if (expr.atom.getType().equals(v.getType()) || expr.atom.getType().isSubtypeOf(v.getType()) || v.getType().isSubtypeOf(expr.atom.getType())) {
                        StringBuilder nsb2 = new StringBuilder(sb.toString());
                        nsb2.append(v.getName());
                        newsb.add(nsb2);
                    }
                }
            }
            results = newsb;
        }
        else if (expr.is_exprn) {
            List<StringBuilder> newsb = new ArrayList<>();
            for(StringBuilder sb : results) {
                for (Exprn exprn : expr.exprns) {
                    StringBuilder nsb1 = new StringBuilder(sb);
                    nsb1.append(exprn);
                    newsb.add(nsb1);
                }
            }
            results=newsb;
        }
        else {
            //System.out.println("current: " + results);
            for(HoleStat hs : ss.holes){
                if(hs.hole == expr){
                    String val = hs.getCurrentVal();
                    List<Exprn> exprns = seed.solutions.cex.val2exprs.get(val);
                    //System.out.println("to append: " + exprns);
                    List<StringBuilder> newsb = new ArrayList<>();
                    for(StringBuilder sb : results) {
                        for (Exprn exprn : exprns) {
                            if (exprn.getType().equals(expr.getType()) || expr.getType().isSubtypeOf(exprn.getType()) || exprn.getType().isSubtypeOf(expr.getType())) {
                                StringBuilder nsb1 = new StringBuilder(sb);
                                exprn.toString(nsb1);
                                newsb.add(nsb1);
                            }
                        }
                    }
                    results=newsb;
                    //System.out.println("after: " + results);
                    break;
                }
            }
        }
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        for(StringBuilder sb : results){
            sb.append(expr.op);
            sb.append("(");
        }

        expr.getSub().accept(this);

        for(StringBuilder sb : results){
            sb.append(")");
        }
    }

    @Override
    public void visit(VarHole expr){
        for(StringBuilder sb : results)
            sb.append(expr);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        expr.left.accept(this);
        for(StringBuilder sb : results)
            sb.append(expr.op);
        expr.right.accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        expr.left.accept(this);
        for(StringBuilder sb : results)
            sb.append(expr.op);
        expr.right.accept(this);
    }

    @Override
    public void visit(ExprnCallBool expr) {
        expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
        expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {
        for(StringBuilder sb : results)
        sb.append(expr);
    }

    @Override
    public void visit(ExprnField expr) {
        for(StringBuilder sb : results)
        sb.append(expr);
    }

    @Override
    public void visit(ExprnSig expr) {
        for(StringBuilder sb : results)
        sb.append(expr);
    }

    @Override
    public void visit(ExprnVar expr) {
        for(StringBuilder sb : results)
        sb.append(expr);
    }

    @Override
    public void visit(ExprnITEBool expr) {
        for(StringBuilder sb : results) {
            sb.append("(");
            expr.condition.accept(this);
        }

        for(StringBuilder sb : results) {
            sb.append(" => ");
            expr.thenClause.accept(this);
        }

        for(StringBuilder sb : results) {
            sb.append(" else ");
            expr.elseClause.accept(this);
        }

        for(StringBuilder sb : results)
            sb.append(")");
    }

    @Override
    public void visit(ExprnITERel expr) {
        for(StringBuilder sb : results) {
            sb.append("(");
            expr.condition.accept(this);
        }

        for(StringBuilder sb : results) {
            sb.append(" => ");
            expr.thenClause.accept(this);
        }

        for(StringBuilder sb : results) {
            sb.append(" else ");
            expr.elseClause.accept(this);
        }

        for(StringBuilder sb : results)
        sb.append(")");
    }

    @Override
    public void visit(ExprnLet expr) {
        for(StringBuilder sb : results) {
            sb.append("let ");
            expr.var.accept(this);
            sb.append(" = ");
            expr.expr.accept(this);
            sb.append(" | ");
            expr.sub.accept(this);
        }
    }

    @Override
    public void visit(ExprnListBool expr) {
        if(expr.args.size() > 0) {
            for(StringBuilder sb : results) {
                sb.append("(");
                for (int i = 0; i < expr.args.size(); i++) {
                    if (i > 0) {
                        sb.append(expr.op.toString());
                    }
                    expr.args.get(i).accept(this);
                }

            }
            for(StringBuilder sb : results)
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnListRel expr) {
        if(expr.args.size() > 0) {
            for(StringBuilder sb : results) {
                sb.append(expr.op).append("[");
                for (int i = 0; i < expr.args.size(); i++) {
                    expr.args.get(i).accept(this);
                    if (i < expr.args.size() - 1) {
                        sb.append(", ");
                    }
                }
                sb.append("]");
            }
        }
    }

    @Override
    public void visit(ExprnQtBool expr) {
        for(StringBuilder sb : results) {
            sb.append(expr.op);
            for (int i = 0; i < expr.getVars().size(); i++) {
                if (i > 0 && i <= expr.getVars().size() - 1) {
                    sb.append(", ");
                }
                expr.getVars().get(i).accept(this);
            }
            sb.append(" | ");
            expr.getSub().accept(this);
        }
    }

    @Override
    public void visit(ExprnQtRel expr) {
        for(StringBuilder sb : results) {
            if (expr.getOp() == ExprnQtRel.Op.COMPREHENSION)
                sb.append("{");
            else
                sb.append(expr.getOp());
            for (int i = 0; i < expr.getVars().size(); i++) {
                if (i > 0 && i <= expr.getVars().size() - 1) {
                    sb.append(", ");
                }
                expr.getVars().get(i).accept(this);
            }
            sb.append(" | ");
            expr.getSub().accept(this);
        }
        for(StringBuilder sb : results){
            if (expr.getOp() == ExprnQtRel.Op.COMPREHENSION) {
                sb.append("}");
            }
        }
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        for(StringBuilder sb : results) {
            sb.append(expr.op);
            sb.append("(");
            expr.getSub().accept(this);
        }
        for(StringBuilder sb : results){
            sb.append(")");
        }
    }

    @Override
    public void visit(AModel model) {
        model.getOpens().forEach(opens -> opens.accept(this));
        model.getSigDecls().forEach(sigDef -> sigDef.accept(this));
        model.getPredicates().forEach(predicate -> predicate.accept(this));
        model.getFunctions().forEach(function -> function.accept(this));
        model.getFacts().forEach(fact -> fact.accept(this));
        model.getAsserts().forEach(anAssert -> anAssert.accept(this));
        model.getCmds().forEach(cmd -> cmd.accept(this));
    }

    @Override
    public void visit(Assert asserts) {
        asserts.toString(sb);
    }

    @Override
    public void visit(Opens open) {
        open.toString(sb);
    }

    @Override
    public void visit(SigDef sigDecl) {
        sigDecl.toString(sb);
    }

    @Override
    public void visit(DeclField sigField) {
        sigField.toString(sb);
    }

    @Override
    public void visit(DeclParam decl) {
        decl.toString(sb);
    }

    @Override
    public void visit(DeclVar decl) {
        decl.toString(sb);
    }
}
