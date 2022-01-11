package parser.test;


import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import parser.ast.AModel;
import parser.visitor.InfoCollector;

public class ParserTest {
    public static void main(String[] args) {
        String path = "examples/fsm_starttransition.als";
        A4Options opt = new A4Options();
        opt.solver = A4Options.SatSolver.SAT4J;
        A4Solution sol = null;


        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }
        AModel am = new AModel(world);
       // System.out.println(am.toString());
        InfoCollector tc = new InfoCollector();
        tc.visit(am, null);
        tc.node2keywrod.keySet().stream().forEach(
                node -> {
                    System.out.print(node.getAlloyNode().toString() + "\t:\t ");
                    tc.node2keywrod.get(node).stream().forEach(
                            str->System.out.print(str + "\t"));
                    System.out.println();
                }
        );

    }
}
