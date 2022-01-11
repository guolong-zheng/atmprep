package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprITE;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;

public class ExprnITERel extends ExprnITE {
    public ExprnITERel(Node parent, ExprITE exprITE) {
        super(parent, exprITE);
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }
}
