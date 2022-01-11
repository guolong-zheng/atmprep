package synth.syntaxtemplates.printers;

import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.template.seed.Seed;

public class SeedPrinter extends VoidVisitorWrapper {
    Seed seed;
    StringBuilder sb;

    public SeedPrinter(Seed seed){
        this.seed = seed;
    }

    public String instantiate() {

        sb = new StringBuilder();

        seed.exprn.accept(this);

        return sb.toString();
    }

    public String instantiate(Seed new_seed) {

        sb = new StringBuilder();

        new_seed.exprn.accept(this);

        return sb.toString();
    }

    @Override
    public void visit(ValueHole expr){
        if(expr.is_atom) {
            sb.append(expr.atom);
        }
        else if(expr.is_exprn) {
            sb.append(expr.exprns.get(0));
        }
        else {
            sb.append(expr.type);
        }
    }

    @Override
    public void visit(VarHole expr){
        sb.append(expr);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
            expr.left.accept(this);
            sb.append(expr.op);
            expr.right.accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
            expr.left.accept(this);
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
            sb.append(expr);
    }

    @Override
    public void visit(ExprnField expr) {
            sb.append(expr);
    }

    @Override
    public void visit(ExprnSig expr) {
            sb.append(expr);
    }

    @Override
    public void visit(ExprnVar expr) {
            sb.append(expr);
    }

    @Override
    public void visit(ExprnITEBool expr) {
        sb.append("(");
        expr.condition.accept(this);
        sb.append(" => ");
        expr.thenClause.accept(this);
        sb.append(" else ");
        expr.elseClause.accept(this);
        sb.append(")");
    }

    @Override
    public void visit(ExprnITERel expr) {
        sb.append("(");
        expr.condition.accept(this);
        sb.append(" => ");
        expr.thenClause.accept(this);
        sb.append(" else ");
        expr.elseClause.accept(this);
        sb.append(")");
    }

    @Override
    public void visit(ExprnLet expr) {
        sb.append("let ");
        expr.var.accept(this);
        sb.append(" = ");
        expr.expr.accept(this);
        sb.append(" | ");
        expr.sub.accept(this);
    }

    @Override
    public void visit(ExprnListBool expr) {
        if(expr.args.size() > 0) {
            sb.append("(");
            for (int i = 0; i < expr.args.size(); i++) {
                if (i > 0) {
                    sb.append(expr.op.toString());
                }
                expr.args.get(i).accept(this);
            }
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnListRel expr) {
        if(expr.args.size() > 0) {
            sb.append(expr.op).append("[");
            for (int i = 0; i < expr.args.size(); i++) {
                expr.args.get(i).accept(this);
                if ( i < expr.args.size() - 1) {
                    sb.append(", ");
                }
            }
            sb.append("]");
        }
    }

    @Override
    public void visit(ExprnQtBool expr) {
        sb.append(expr.op);
        for(int i = 0; i < expr.getVars().size(); i++){
            if( i > 0 && i <= expr.getVars().size() - 1){
                sb.append(", ");
            }
            expr.getVars().get(i).accept(this);
        }
        sb.append(" | ");
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        if( expr.getOp() == ExprnQtRel.Op.COMPREHENSION)
            sb.append("{");
        else
            sb.append(expr.getOp());
        for(int i = 0; i < expr.getVars().size(); i++){
            if( i > 0 && i <= expr.getVars().size() - 1){
                sb.append(", ");
            }
            expr.getVars().get(i).accept(this);
        }
        sb.append(" | ");
        expr.getSub().accept(this);
        if( expr.getOp() == ExprnQtRel.Op.COMPREHENSION){
            sb.append("}");
        }
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        sb.append(expr.op);
        sb.append("(");
        expr.getSub().accept(this);
        sb.append(")");
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
            sb.append(expr.op);
            sb.append("(");
            expr.getSub().accept(this);
            sb.append(")");
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
