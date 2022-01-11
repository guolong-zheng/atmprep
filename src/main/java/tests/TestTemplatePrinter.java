package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import parser.ast.AModel;
import parser.ast.Exprn;
import synth.syntaxtemplates.printers.TemplateCommandPrinter;
import synth.syntaxtemplates.printers.TemplateModelPrinter;

public class TestTemplatePrinter {
    public static void main(String[] args){
        String path = "benchmark/test.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }
        AModel model = new AModel(world);
        Exprn e = model.getFunctions().get(0).getBody();
        System.out.println("fault: " + e);
        Command cmd = world.getAllCommands().get(3);
        System.out.println(cmd.label);

        TemplateCommandPrinter tp = new TemplateCommandPrinter(model, cmd);
        tp.getPreAndAppend(e);

       // System.out.println(tp.pre.toString());
       // System.out.println(tp.append.toString());

        TemplateModelPrinter tm = new TemplateModelPrinter(model, null);
        tm.print();
        System.out.println(tm.pre.toString());
        System.out.println(tm.append.toString());
    }
}
