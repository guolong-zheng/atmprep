package synth.syntaxtemplates.template.hole;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Exprn;
import parser.ast.ExprnVar;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.List;
import java.util.Map;

public class ValueHole extends Hole {

    public ValueHole(Type t){
        super(t);
    }

    public ValueHole(Type t, ExprnVar var){
        super(t);
        is_atom = true;   // fixed value representing atom
        this.atom = var;
    }

    public ValueHole(Type t, List<Exprn> exprns){
        super(t);
        is_exprn = true;
        this.exprns = exprns;
    }

    public String toString(){
        return value;
    }

    public String toString(String value){
        return value;
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        return null;
    }

    @Override
    public void toString(StringBuilder sb) {
        sb.append(value);
    }

    @Override
    public void toTemplateString(Template t, String value, StringBuilder sb) {}

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {}

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }
}
