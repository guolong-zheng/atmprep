package parser.ast;

import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.Template;

import java.util.Set;

/* fact name { expr } */
public class Fact extends Node {

    String name;

    public Exprn expr;

    public Fact(Node parent, Pair<String, Expr> fact) {
        super(parent, fact);
        if(fact.a.contains("$"))
            this.name = "";
        else
            this.name = fact.a;
        this.expr = Exprn.parseExpr(this, fact.b);
    }

    /* create fact with unsatcore checked*/
    public Fact(Node parent, Pair<String, Expr> fact, Set<Object> core) {
        super(parent, fact);
        if(fact.a.contains("$"))
            this.name = "";
        else
        this.name = fact.a;
        this.expr = Exprn.parseExpr(this, fact.b, core);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append("fact ").append(name).append(" {\n");
        expr.toString(sb);
        sb.append("}\n");
    }

    public void toTemplateString(Template t, String value, StringBuilder sb){
        sb.append("fact ").append(name).append(" {\n");
        expr.toTemplateString(t, value, sb);
        sb.append("}\n");
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Exprn getExpr() {
        return expr;
    }

    public void setExpr(Exprn expr) {
        this.expr = expr;
    }
}
