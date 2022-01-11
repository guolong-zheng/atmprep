package synth.syntaxtemplates.printers;

import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

/*
* all template of one fault share the same
* pre and append
* get pre and append part of template to avoid repeat
* */
public class TemplateCommandPrinter extends VoidVisitorWrapper {
    String name;
    boolean isCheck;
    public StringBuilder pre;
    public StringBuilder append;
    Exprn target;  // faulty expression
    AModel model;
    public StringBuilder sb;

    public TemplateCommandPrinter(AModel md, Command cmd){
        name = cmd.label;
        isCheck = cmd.check;
        model = md;
        pre = new StringBuilder();
        append = new StringBuilder();
        sb = pre;
    }

    public TemplateCommandPrinter(AModel md, Exprn fault){
        model = md;
        pre = new StringBuilder();
        append = new StringBuilder();
        sb = pre;
        target = fault;
    }

    public void getPreAndAppend(Exprn exprn){
        this.target = exprn;
        this.visit(model);
    }

    @Override
    public void visit(AModel model) {
        if (isCheck) {
          //  pre.append("!(");
           // pre.append("(");
            model.getAsserts().stream().forEach(anAssert -> {
                if (anAssert.getName().equals(name)) {
                    anAssert.accept(this);
                }
            });
        }
        else {
           // pre.append("(");
            model.getPredicates().stream().forEach(pred -> {
                if (pred.getName().equals(name)) {
                    pred.accept(this);
                }
            });
        }
        // pre.append("&&");
        // append.append(")");
    }

    @Override
    public void visit(Assert asserts) {
        asserts.getFormula().accept(this);
    }

    @Override
    public void visit(Opens open) {}

    @Override
    public void visit(SigDef decl) {}

    @Override
    public void visit(DeclField decl) {
        for(int i = 0; i < decl.getNames().size(); i++){
            if(i > 0){
                sb.append(", ");
            }
            decl.getNames().get(i).toString(sb);
        }
        sb.append(": ");
        decl.getExpr().toString(sb);
    }

    @Override
    public void visit(DeclParam decl) {
        for(int i = 0; i < decl.getNames().size(); i++){
            if(i > 0){
                sb.append(", ");
            }
            decl.getNames().get(i).toString(sb);
        }
        sb.append(": ");
        decl.getExpr().toString(sb);
    }

    @Override
    public void visit(DeclVar decl) {
        for(int i = 0; i < decl.getNames().size(); i++){
            if(i > 0){
                sb.append(", ");
            }
            decl.getNames().get(i).toString(sb);
        }
        sb.append(": ");
        decl.getExpr().toString(sb);
    }

    @Override
    public void visit(Fact fact) {}

    @Override
    public void visit(Predicate pred) {
        pred.getBody().accept(this);
    }

    @Override
    public void visit(Function func) {
        func.getBody().accept(this);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        if(expr == target)
            sb = append;
        else{
            sb.append("(");
            sb.append("(");
            expr.getLeft().accept(this);
            sb.append(")");
            sb.append(expr.op.toString());
            expr.getRight().accept(this);
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        if(expr == target)
            sb = append;
        else{
            sb.append("(");
            expr.getLeft().accept(this);
            sb.append(expr.op.toString());
            expr.getRight().accept(this);
            sb.append(")");
        }
    }

    /*
    * collect
    * */
    @Override
    public void visit(ExprnCallBool expr) {
        String name = StringUtil.removeThis(expr.getName());
        expr.getNodeMap().findFunc(name).accept(this);
    }

    /*
    * collect
    * */
    @Override
    public void visit(ExprnCallRel expr) {
        String name = StringUtil.removeThis(expr.getName());
        if( name.contains("integer") || name.contains("order") || name.contains("/next"))
            return;
        expr.getNodeMap().findFunc(name).accept(this);
    }

    @Override
    public void visit(ExprnITEBool expr) {
        if(expr == target)
            sb = append;
        else {
            sb.append("(");
            expr.condition.accept(this);
            sb.append(" => ");
            expr.thenClause.accept(this);
            sb.append(" else ");
            expr.elseClause.accept(this);
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnITERel expr) {
        if(expr == target)
            sb = append;
        else {
            sb.append("(");
            expr.condition.accept(this);
            sb.append(" => ");
            expr.thenClause.accept(this);
            sb.append(" else ");
            expr.elseClause.accept(this);
            sb.append(")");
        }
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
        if(expr == target){
            sb = append;
        }else {
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
    }

    @Override
    public void visit(ExprnListRel expr) {
        if(expr == target){
            sb = append;
        }else {
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
        };
    }

    @Override
    public void visit(ExprnQtBool expr) {
        if(expr.toString().equals(target.toString())){
            sb = append;
        }else{
            sb.append(expr.op);
            for(int i = 0; i < expr.vars.size(); i++){
                if( i > 0 && i <= expr.vars.size() - 1){
                    sb.append(", ");
                }
                expr.vars.get(i).accept(this);
            }
            sb.append(" | ");
            expr.sub.accept(this);
        }
    }

    @Override
    public void visit(ExprnQtRel expr) {
        if(expr == target) {
            sb = append;
        }else{
            if( expr.op == ExprnQtRel.Op.COMPREHENSION)
                sb.append("{");
            else
                sb.append(expr.op);
            for(int i = 0; i < expr.vars.size(); i++){
                if( i > 0 && i <= expr.vars.size() - 1){
                    sb.append(", ");
                }
                expr.vars.get(i).accept(this);
            }
            sb.append(" | ");
            expr.sub.accept(this);
            if( expr.op == ExprnQtRel.Op.COMPREHENSION){
                sb.append("}");
            }
        }
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        if(expr == target) {
            sb = append;
        }else{
            sb.append(expr.op);
            sb.append("(");
            expr.sub.accept(this);
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        if(expr == target) {
            sb = append;
        }else{
            sb.append(expr.op);
            sb.append("(");
            expr.sub.accept(this);
            sb.append(")");
        }
    }

    @Override
    public void visit(ExprnConst expr) {
        expr.toString(sb);
    }

    @Override
    public void visit(ExprnField expr) {
        expr.toString(sb);
    }

    @Override
    public void visit(ExprnSig expr) {
        expr.toString(sb);
    }

    @Override
    public void visit(ExprnVar expr) {
        expr.toString(sb);
    }

    @Override
    public void visit(Template template) {}

    @Override
    public void visit(VarHole hole) {}

    @Override
    public void visit(ValueHole hole) {}
}
