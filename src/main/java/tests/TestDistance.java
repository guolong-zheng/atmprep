package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import parser.ast.AModel;
import parser.ast.ExprnQtBool;
import parser.ast.Predicate;
import synth.syntaxtemplates.generators.TemplateCreator;
import synth.syntaxtemplates.printers.TemplatePrinter;
import synth.syntaxtemplates.structures.Template;

import java.util.List;

public class TestDistance {
    public static void main(String[] args){
        String path = "benchmark/testsynth.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }

        Command cmd = world.getAllCommands().get(0);
        A4Solution sol = null;
        try {
            sol = TranslateAlloyToKodkod.execute_command(new A4Reporter(), world.getAllReachableSigs(), cmd, new A4Options());
            System.out.println(sol);
        } catch (Err err) {
            err.printStackTrace();
        }

        AModel model = new AModel(world);

        for (Predicate p : model.getPredicates()) {
            if (p.getName().equals("Sorted")) {
                ExprnQtBool e = (ExprnQtBool) p.getBody();
                TemplateCreator tc = new TemplateCreator(e);
                tc.initialize();

                List<Template> tmps = tc.getAllTemplates();
                for(Template t : tmps){
                    TemplatePrinter tp = new TemplatePrinter(t);
                    System.out.println("template: " + tp.instantiate("test") + "\t");
                    //System.out.println(t + " : " );
                    System.out.println(t.calDistance());
                }
            }
        }
    }
}
