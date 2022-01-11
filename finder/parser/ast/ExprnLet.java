package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprLet;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

/* (let var = expr | sub) */
public class ExprnLet extends Exprn {

   public ExprnVar var;

   public Exprn expr;

    public Exprn sub;

    public ExprnLet(Node parent, ExprLet expr) {
        super(parent, expr);
        this.var = (ExprnVar) Exprn.parseExpr(this, expr.var);
        this.expr = Exprn.parseExpr(this, expr.expr);
        this.sub = Exprn.parseExpr(this, expr.sub);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append("let ");
        var.toString(sb);
        sb.append(" = ");
        expr.toString(sb);
        sb.append(" | ");
        sub.toString(sb);
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            toString(sb);
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        toString(sb);
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        String v = var.getInstantiatedString(name2val);
        String e = expr.getInstantiatedString(name2val);
        String s = sub.getInstantiatedString(name2val);
        return "let " + v + " = " + e + " | " + s;
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    public ExprnVar getVar() {
        return var;
    }

    public void setVar(ExprnVar var) {
        this.var = var;
    }

    public Exprn getExpr() {
        return expr;
    }

    public void setExpr(Exprn expr) {
        this.expr = expr;
    }

    public Exprn getSub() {
        return sub;
    }

    public void setSub(Exprn sub) {
        this.sub = sub;
    }
}
