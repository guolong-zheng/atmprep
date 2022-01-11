package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Decl;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;

public class DeclVar extends Declaration {

    public DeclVar(Node parent, Decl decl) {
        super(parent, decl);
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
