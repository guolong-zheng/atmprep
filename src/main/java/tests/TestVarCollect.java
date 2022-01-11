package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import parser.ast.*;
import synth.varcollectors.Var;
import synth.varcollectors.VarCollector;

import java.util.Set;

public class TestVarCollect {
    public static void main(String[] args){
        String path = "benchmark/1bug/balancedBST19_1.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }
        AModel model = new AModel(world);
        VarCollector vc = new VarCollector(model);
        ExprnQtBool e = (ExprnQtBool)model.getPredicates().get(0).getBody();
        ExprnBinaryBool e1 = (ExprnBinaryBool) ((ExprnListBool)(e.getSub())).getArgs().get(0);
        ExprnQtBool e2 = (ExprnQtBool) e1.getRight();
        ExprnBinaryRel e3 = (ExprnBinaryRel)((ExprnBinaryBool) e2.getSub()).getRight();
        Type right = e3.getRight().getType();
        System.out.println(right.arity());
        Set<Var> livevars = vc.collect(e);
        //System.out.println(livevars);
    }
}
