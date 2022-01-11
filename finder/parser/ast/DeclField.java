package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Decl;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;

public class DeclField extends Declaration {

    public DeclField(Node parent, Decl field) {
        super(parent, field);
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
