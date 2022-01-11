package synth.syntaxtemplates.structures;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Declaration;
import parser.ast.Exprn;
import synth.syntaxtemplates.template.hole.ValueHole;

import java.util.ArrayList;

// all n : State | n.left change to
//     State.left
//     Field.left
public class QtRemoveTemplate extends QtTemplate{
    Type type;
    int max; // max number of decl vars to be removed
    int count;

    public QtRemoveTemplate(Exprn orig, Exprn exprn, ArrayList<Declaration> decl){
        original = orig;
        replacement = exprn;
        type = replacement.getType();
        count = 0;
        max = 1;
        decls = decl;
    }

    public QtRemoveTemplate(Exprn orig, Exprn exprn){
        original = orig;
        toBeReplaced = exprn;
        type = exprn.getType();
        replacement = new ValueHole(type);
        holes.add((ValueHole)replacement);
        count = 0;
        max = 1;
    }

    public String toString(String value){
        if(count < max) {
            count++;
            return value;
        }else{
            return original.toString();
        }
    }

}
