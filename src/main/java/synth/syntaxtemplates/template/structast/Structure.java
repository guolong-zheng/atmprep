package synth.syntaxtemplates.template.structast;

import parser.ast.Declaration;
import parser.ast.Exprn;
import parser.ast.ExprnVar;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.template.hole.Hole;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Structure extends Exprn{
    List<Hole> holes;

    public List<Exprn> toInstHoles;

    List<ExprnVar> qtvars;

    List<Declaration> decls;

    public Structure(){
        toInstHoles = new ArrayList<>();
        holes = new ArrayList<>();
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return null;
    }

    @Override
    public void accept(VoidVisitor visitor) {

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

    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {

    }
}
