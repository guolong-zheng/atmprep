package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprCall;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.List;

public class ExprnCallRel extends ExprnCall {

    public ExprnCallRel(Node parent, ExprCall expr) {
        super(parent, expr);
    }

    // create new exprn for template-based mutation
    public ExprnCallRel(Node parent, String name, List<Exprn> args){
        super(parent, name, args);
    }

    @Override
    public String toString() {
        return super.toString();
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    @Override
    public void toTemplateString(Template t, String value, StringBuilder sb) {
        toString(sb);
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        toString(sb);
    }
}
