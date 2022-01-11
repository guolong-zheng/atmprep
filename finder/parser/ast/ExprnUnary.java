package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprUnary;

public abstract class ExprnUnary extends Exprn {
    public Exprn sub;

    public ExprnUnary(Node parent, ExprUnary expr) {
        super(parent, expr);
        this.sub = Exprn.parseExpr(this, expr.sub);
    }

    public ExprnUnary(Node parent) {
        super(parent);
    }

    public ExprnUnary(){
        super();
    }

    public Exprn getSub() {
        return sub;
    }

    public void setSub(Exprn sub) {
        this.sub = sub;
        sub.parent = this;
    }
}
