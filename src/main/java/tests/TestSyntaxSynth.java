package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import parser.ast.AModel;
import parser.ast.Exprn;
import parser.ast.Fact;
import synth.TemplateSynthesizer;

public class TestSyntaxSynth {
    public static void main(String[] args) {
        String path = "benchmark/t2.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }

        AModel model = new AModel(world);
        for (Fact p : model.getFacts()) {
            if (p.getName().equals("Reachability")) {
                Exprn e = p.getExpr();
                System.out.println("exprn: " + e);
               // ExprnVarCollector vc = new ExprnVarCollector(e, model);
               // vc.collect();
               // System.out.println(vc.livevars + "\n" + vc.collectDeclVars());

                TemplateSynthesizer tm = new TemplateSynthesizer(e);
                tm.extractTemplateFromExpression();

            }
        }
    }
}
