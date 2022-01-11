package parser.ast;


import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;

/* Assume no error in all assert and use assert as ground truth
*
*  Information needed to gather is "keyword" in formula to do slice
* */
public class Assert extends Node {
    String name;

    Exprn formula;

    public Assert(Node parent, Pair<String, Expr> pair) {
        super(parent, pair);
        this.name = pair.a;
        this.formula = Exprn.parseExpr(this, pair.b);
        this.nodeMap.put(name, this);
    }

    public void toString(StringBuilder sb){
        sb.append("assert ").append(name).append("{\n");
        formula.toString(sb);
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

    public Exprn getFormula() {
        return formula;
    }

    public void setFormula(Exprn formula) {
        this.formula = formula;
    }
}
