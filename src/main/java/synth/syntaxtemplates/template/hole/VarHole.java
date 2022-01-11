package synth.syntaxtemplates.template.hole;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

/*
* represent newly introduced decl vars
*   all synth_var_1 : State | some synt_var_1.left
* */
public class VarHole extends Hole {

    String name;

    public VarHole(){
    }

    public VarHole(String n, Type t){
        super(t);
        name = n;
    }

    public String toString(){
        return name;
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        return null;
    }

    @Override
    public void toString(StringBuilder sb) {

    }

    @Override
    public void toTemplateString(Template t, String value, StringBuilder sb) {
        sb.append(value);
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {

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
