package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import mutation.ExprMutator;
import parser.ast.*;
import synth.syntaxtemplates.generators.TemplateCreator;
import util.RepairOption;
import util.RepairReporter;

public class TestMutator {
    public static void main(String[] args){
        String path = "benchmark/1bug/balancedBST19_1.als";
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }
        AModel model = new AModel(world);
        for(Predicate pred : model.getPredicates()){
            if(pred.getName().contains("HasAtMostOneChild")){
                ExprnUnaryBool target = (ExprnUnaryBool)pred.getBody();
                System.out.println(target);
//                ExprnBinaryRel be = (ExprnBinaryRel)expr.getSub();
//                Exprn target = be.getRight();

                RepairOption opt = new RepairOption(model, world.getAllCommands(), path);
                RepairReporter rep = new RepairReporter(false);

                ExprMutator mut = new ExprMutator(opt, target, rep);
                System.out.println("generating mutations");
                mut.mutate();
                System.out.println(mut.mutants.size());
                int i = 0;
                for(String s : mut.mutants){
                    System.out.println(i++ + ": " + s);
                }
                System.out.println("generating relational exprs");

                System.out.println("generating templates");
                TemplateCreator tc = new TemplateCreator(target);

            }
        }
//        Mutator m = new Mutator();
//        m.visit(model);
    }
}
