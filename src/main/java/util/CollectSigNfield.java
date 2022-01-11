package util;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.AModel;
import parser.ast.SigDef;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CollectSigNfield {
    public static Map<String, Type> collect(AModel model){
        Map<String, Type> sigNfield = new HashMap<>();
        List<SigDef> sigDecl = model.getSigDecls();
        for (SigDef def : sigDecl) {
            sigNfield.put(def.getName(), def.getType());
            def.getFields().forEach(f -> f.getNames().
                    forEach(n -> {
                                sigNfield.put(n.toString(), n.getType());
                            }
                    ));
        }
        return sigNfield;
    }
}
