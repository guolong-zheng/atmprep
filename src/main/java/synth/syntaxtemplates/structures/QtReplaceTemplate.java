package synth.syntaxtemplates.structures;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Declaration;
import parser.ast.Exprn;
import parser.ast.ExprnQtBool;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;

import java.util.ArrayList;

// currently only create qt expression with one declaration
public class QtReplaceTemplate extends QtTemplate{
    public ExprnQtBool.Op qt; // quantifier
    public String varname; // variable name
    public Type type;      // type of variable


    public QtReplaceTemplate(Exprn orig, Exprn exprn){
        original = orig;
        toBeReplaced = exprn;
        type = exprn.getType();
        varname = "synth_var_" + count++;
    }

    public QtReplaceTemplate(Exprn orig, Exprn exprn, ExprnQtBool.Op quantifier, ArrayList<Declaration> decl){
        original = orig;
        type = exprn.getType();
        toBeReplaced = exprn;
        qt = quantifier;
        varname = "synth_var_" + count++;
        Hole newhole = new ValueHole(type);
        holes = new ArrayList<>();
        holes.add(newhole);
        replacement = newhole;
        decls = decl;
    }

    public QtReplaceTemplate(Exprn orig, Exprn exprn, ExprnQtBool.Op quantifier){
        original = orig;
        type = exprn.getType();
        toBeReplaced = exprn;
        qt = quantifier;
        varname = "synth_var_" + count++;
        replacement = new VarHole(varname, type);
        Hole newhole = new ValueHole(type);
        holes = new ArrayList<>();
        holes.add(newhole);
       // replacement = newhole;
    }

    public String toString(String value) {
        StringBuilder sb = new StringBuilder();
        original.toQtTemplateString(this, varname, sb);
        qt = ExprnQtBool.Op.ALL;
        return qt + " " + varname + ": " + value + " {" + sb.toString() + "}";
    }
}
