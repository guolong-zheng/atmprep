package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprBinary;

public abstract class ExprnBinary extends Exprn {
    public Exprn left;
    public Exprn right;

    public ExprnBinary(Node parent, ExprBinary exprBinary) {
        super(parent, exprBinary);
        this.left = Exprn.parseExpr(this, exprBinary.left);
        this.right = Exprn.parseExpr(this, exprBinary.right);
    }

    // Construct true expression for mutation
    public ExprnBinary(Node parent) {
        super(parent);
        this.left = new ExprnConst(this);
        this.right = new ExprnConst(this);
    }

    public ExprnBinary(){
        super();
    }

    public Exprn getLeft() {
        return left;
    }

    public void setLeft(Exprn left) {
        this.left = left;
        left.parent = this;
    }

    public Exprn getRight() {
        return right;
    }

    public void setRight(Exprn right) {
        this.right = right;
        right.parent = this;
    }
}
