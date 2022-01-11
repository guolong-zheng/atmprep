package synth.syntaxtemplates.printers;

import parser.ast.*;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

public class TemplateDistancePrinter extends TemplatePrinter {


    public TemplateDistancePrinter(Template t) {
        super(t);
        sb = new StringBuilder();
    }

    public String generateString(Exprn exprn){
        sb = new StringBuilder();
        exprn.accept(this);
        return sb.toString().replaceAll("\\s+", "");
    }

    @Override
    public void visit(ValueHole expr){
        sb.append("{"+expr.getType()+"}");
    }

    @Override
    public void visit(VarHole expr){
        sb.append("{"+expr.getType()+"}");
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        sb.append("{"+expr.op);
        expr.left.accept(this);
        expr.right.accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        sb.append("{"+expr.op);
        expr.left.accept(this);
        expr.right.accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnCallBool expr) {
        sb.append("{");
        sb.append(expr.getFunc().getName());
        expr.getArgs().forEach(arg->arg.accept(this));
        sb.append("}");
    }

    @Override
    public void visit(ExprnCallRel expr) {
        sb.append("{");
        sb.append(expr.getFunc().getName());
        expr.getArgs().forEach(arg->arg.accept(this));
        sb.append("}");
    }

    @Override
    public void visit(ExprnConst expr) {
        sb.append("{");
        sb.append(expr);
        sb.append("}");
    }

    @Override
    public void visit(ExprnField expr) {
        sb.append("{");
        sb.append(expr);
        sb.append("}");
    }

    @Override
    public void visit(ExprnSig expr) {
        sb.append("{");
        sb.append(expr);
        sb.append("}");
    }

    @Override
    public void visit(ExprnVar expr) {
        sb.append("{");
        sb.append(expr);
        sb.append("}");
    }

    @Override
    public void visit(ExprnITEBool expr) {
        sb.append("{");
        sb.append("ITE");
        expr.condition.accept(this);
        expr.thenClause.accept(this);
        expr.elseClause.accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnITERel expr) {
        sb.append("{");
        sb.append("ITE");
        expr.condition.accept(this);
        expr.thenClause.accept(this);
        expr.elseClause.accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnLet expr) {
        sb.append("{");
        sb.append("let");
        sb.append("{");
        sb.append("=");
        expr.var.accept(this);
        expr.expr.accept(this);
        sb.append("}");
        expr.sub.accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnQtBool expr) {
        sb.append("{");
        sb.append(expr.op);
        for(int i = 0; i < expr.getVars().size(); i++){
            expr.getVars().get(i).accept(this);
        }
        expr.getSub().accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnQtRel expr) {
        sb.append("{");
        sb.append(expr.op);
        for(int i = 0; i < expr.getVars().size(); i++){
            expr.getVars().get(i).accept(this);
        }
        expr.getSub().accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        sb.append("{");
        sb.append(expr.op);
        expr.getSub().accept(this);
        sb.append("}");
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        sb.append("{");
        sb.append(expr.op);
        expr.getSub().accept(this);
        sb.append("}");
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
