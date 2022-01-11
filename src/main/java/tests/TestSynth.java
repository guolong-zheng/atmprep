package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import parser.ast.AModel;
import parser.ast.ExprnBinaryRel;
import parser.ast.ExprnUnary;

import java.util.Iterator;

public class TestSynth {
    public static void main(String[] args){
        String path = "benchmark/test.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }
        AModel model = new AModel(world);
        ExprnUnary e = (ExprnUnary) model.getPredicates().get(0).getBody();
        Type type = e.getSub().getType();
        System.out.println(e.getSub() + " " + type );
        System.out.println( ((ExprnBinaryRel)e.getSub()).getLeft().getType() );
        Iterator<Type.ProductType> it = type.iterator();
        int i = 0;
        while(it.hasNext()){
            System.out.println(i++);
            Type.ProductType t = it.next();
            System.out.println(t.get(0));
            System.out.println(t.get(1));
        }
      //  System.out.println(e.getSub().getType());

    }
}
