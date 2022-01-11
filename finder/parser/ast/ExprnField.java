package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;
import synth.varcollectors.Var;
import utility.StringUtil;

import java.util.Map;

public class ExprnField extends Exprn {

    String name;

    public ExprnField(Node parent, Sig.Field field) {
        super(parent, field);
        this.name = StringUtil.removeThis( field.label );
    }

    // construct new exprn for synthesis
    public ExprnField(Var var) {
        this.name = StringUtil.removeThis( var.getName() );
        this.type = var.getType();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append(this.name);
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
        if(this == t.replacement) {
            sb.append(value);
        }else{
            toString(sb);
        }
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        return this.name;
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
}
