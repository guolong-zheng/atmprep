package tests;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import parser.ast.AModel;
import parser.ast.Exprn;
import parser.ast.ExprnQtBool;
import parser.ast.Predicate;
import synth.RelationExprSynthesizer;
import synth.varcollectors.VarCollector;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestSynthExpr {
    public static void main(String[] args) {

//        BracketStringInputParser parser = new BracketStringInputParser();
//        Node<StringNodeData> t1 = parser.fromString("{ab}");
//        Node<StringNodeData> t2 = parser.fromString("{abcd}");
//        APTED<StringUnitCostModel, StringNodeData> apted = new APTED<>(new StringUnitCostModel());
//
//        int result = (int)apted.computeEditDistance(t1, t2);
//        System.out.println(result);
//        System.exit(0);

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
        VarCollector vc = new VarCollector(model);
        System.out.println("processing...");
        for (Predicate p : model.getPredicates()) {
            if (p.getName().equals("Sorted")) {
                ExprnQtBool e = (ExprnQtBool) p.getBody();
                System.out.println( vc.collectDeclVars(e) );
                long time = System.nanoTime();
                RelationExprSynthesizer syn = new RelationExprSynthesizer(3 , 3);
                System.out.println("usable vars " + vc.sigNfield);
                syn.synth(vc.sigNfield);
                System.out.println("generating atomic expressions in " + (System.nanoTime() - time) / (1000000) + " ms");

                for (int i : syn.candidates.keySet()) {
                    System.out.println(i + " operators has " + syn.candidates.get(i).size() + " expressions");
                    System.out.println(syn.candidates.get(i));
                }

                Map<Type, List<Exprn>> types = syn.groupByType();
                for (Type t : types.keySet()) {
                    System.out.println(t + " " + types.get(t).size());
                }

                if (sol.satisfiable()) {
                    long time2 = System.currentTimeMillis();
                    Map<String, List<Exprn>> eval2expr = new HashMap<>();
                    for (Type t : types.keySet()) {
                        if (t.toString().equals("{this/Node->this/Node}")) {
                            List<Exprn> exprns = types.get(t);
                            for (Exprn n : exprns) {
                                try {
                                    String res = sol.eval(CompUtil.parseOneExpression_fromString(world, n.toString())).toString();
                                    List<Exprn> l = eval2expr.getOrDefault(res, new ArrayList<>());
                                    l.add(n);
                                    eval2expr.put(res, l);
                                } catch (Err err) {
                                    err.printStackTrace();
                                }
                            }
                        }
                    }
                    System.out.println("group by eval in " + (System.currentTimeMillis() - time2) + " ms");
                    System.out.println("=========================================");
                    System.out.println("# of different values for Node->Node: " + eval2expr.keySet().size());
                    System.out.println();
                    int i = 0;
                    for (String s : eval2expr.keySet()) {
                        System.out.println(eval2expr.get(s).size() + " expressions eval to " + s);
                        i = i + eval2expr.get(s).size();
                      // System.out.println(eval2expr.get(s));
                    }
                    System.out.println(i);
                }

            }
        }
    }
}
