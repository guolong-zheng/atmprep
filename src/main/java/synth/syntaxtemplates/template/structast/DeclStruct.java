package synth.syntaxtemplates.template.structast;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import synth.syntaxtemplates.template.hole.ValueHole;

public class DeclStruct extends Structure {
    String name;
    ValueHole bind;
    Type type;
    static int count = 0;

    public DeclStruct(){
        name = "new_var_" + count++;
        bind = null;
    }

    public DeclStruct(Type type){
        this.type = type;
        bind = new ValueHole(type);
        name = "new_var_" + count++;
    }
}
