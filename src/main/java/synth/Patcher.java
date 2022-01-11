package synth;

import compare.InstanceGenerator;
import compare.InstancePair;
import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.ast.ExprVar;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import mutation.ExprMutator;
import parser.ast.AModel;
import parser.ast.Exprn;
import synth.syntaxtemplates.generators.TemplateCreator;
import synth.syntaxtemplates.printers.*;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.template.hole.Hole;
import synth.varcollectors.VarCollector;
import tests.Locator;
import util.RepairOption;
import util.RepairReporter;
import util.SynthUtil;
import utility.AlloyUtil;
import utility.LOGGER;

import java.util.*;

public class Patcher {

    static int max = 1; // max # of instances

    static CompModule world;

    static AModel model;

    static Exprn faultyExprn;

    static TemplateCommandPrinter tcp;
    static TemplateModelPrinter tmp;

    //  static Map<Type, List<Exprn>> type2exprns;

    public static void repair(String path) throws Err {
        LOGGER.setLevel(LOGGER.Level.Debug);
        // compute alloy module
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }

        // initialization
        model = new AModel(world);

        // get fault localization
        faultyExprn = SynthUtil.getExprn(model, path);

        Locator locator = new Locator();
        locator.localize(model, world, 5);

        faultyExprn = locator.result.get(0);

        LOGGER.logDebug(Patcher.class, "bug expression: " + faultyExprn);

        ExprMutator mutator = new ExprMutator(new RepairOption(model, world.getAllCommands(), path), faultyExprn, new RepairReporter(false));

        LOGGER.logDebug(Patcher.class, "checking mutations with bound");

        mutator.mutate();

        if(mutator.rep.isfix){
            LOGGER.logInfo(Patcher.class, "fix found:\n" + model.toString());
        }else {
            LOGGER.logInfo(Patcher.class, "no fix found by mutation, searching templates\n");
//        System.out.println("no repair found");
//        System.out.println(model.toString());
            //      System.out.println(faultyExprn.getClass());

            VarCollector vc = new VarCollector(model);
            vc.collectDeclVars(faultyExprn);
            LOGGER.logInfo(Patcher.class, "live variables: " + vc.livevars);

            tmp = new TemplateModelPrinter(model, faultyExprn);
            tmp.print();
//        System.out.println(tmp.pre.append(tmp.append));

            // generate all atomic expressions
            RelationExprSynthesizer exprSynthesizer = new RelationExprSynthesizer(3, 3);
            exprSynthesizer.synth(vc.sigNfield);
            ASolution.type2exprns = exprSynthesizer.groupByType();

            LOGGER.logInfo(Patcher.class, "# of relational types: " + ASolution.type2exprns.keySet().size());
            int count = 0;
            for(List e : ASolution.type2exprns.values()){
                count += e.size();
            }
            System.out.println(count);
            System.exit(0);
            ASolution.type2exprns.forEach((k, v) -> {
                System.out.print(k + "," + v.size() + ": ");
                System.out.println(v);
            });

            System.exit(0);
            // generates solutions
            List<ASolution> solutions = generateInstances(world, model, max);

            // create templates
            TemplateCreator templates = new TemplateCreator(faultyExprn);
            templates.initialize();

            LOGGER.setTimer();
            // search for satisfying templates
            List<Template> potentialFixes = templates.getAllTemplates();

            Collections.sort(potentialFixes, new Comparator<Template>() {
                @Override
                public int compare(Template o1, Template o2) {
                    return o1.distance - o2.distance;
                }
            });

            System.out.println("generates total " + potentialFixes.size() + " templates");


            // checking templates
            List<Template> valid_templates = checkTemplates(potentialFixes, solutions);

            // check templates with expressions
            // checkTemplatesWithExprns(valid_templates);

            System.out.println("working template " + valid_templates.size());
            for (Template t : valid_templates) {
                TemplatePrinter tp = new TemplatePrinter(t);
                System.out.print(tp.instantiate("test") + "\t");
//            for (Hole h : t.holes) {
//                System.out.print(h.getType());
//            }
                System.out.println();
            }
            System.out.println("total count: " + tcount);
            System.out.println("finish search in " + LOGGER.getTime() / 1000 + "sec");
        }
    }

    public static List<Template> checkTemplates(List<Template> templates, List<ASolution> sols) {
        List<Template> unsatTemplates = new ArrayList<>();
        int i = 0;
        for (Template template : templates) {
           // System.out.println("checking " + template.toString());
            long time = System.currentTimeMillis();
            if (!bfs(template, sols)) {
                unsatTemplates.add(template);
            }
            System.out.println("finishing " + (i++) + "th template in " + (System.currentTimeMillis() - time) + "ms");
        }
        templates.removeAll(unsatTemplates);
        return templates;
    }

      static int tcount = 0;

    public static boolean bfs(Template template, List<ASolution> sols) {
        System.out.println("searching");

        TemplatePrinter tp = new TemplatePrinter(template);
        System.out.println("template: " + tp.instantiate("??") + " with " + template.holes.size() + " holes");
        // initialize searching states
        int count = 0;
        ASolution sol = sols.get(0);
        while(sol == null){
            count++;
            sol = sols.get(count);
        }

        List<SearchStat> workingStat = new LinkedList<>();

        // setting all possible values for each hole
        for (Hole h : template.holes) {
            Type hole_type = h.getType();
            if (!sol.type2vals.keySet().contains(hole_type)) {
                sol.evalExprnsOfType(hole_type);
            }
            h.setValues(sol.type2vals.get(hole_type));
        }

        // start search
        SearchStat init_state = new SearchStat(template.holes);



        //   System.out.println("template " + tcount++);
        //int ico = 0;
//        for(HoleStat hs : init_state.holes) {
//            System.out.println(hs.size + " " + hs.values);
//        }

        tcp = new TemplateCommandPrinter(model, sol.cmd);
        tcp.getPreAndAppend(faultyExprn);

        while (init_state.hasNext()) {
//            System.out.println(ico++);
//            for(HoleStat hs : init_state.holes) {
//                System.out.println( (hs.index) + " " + hs.getCurrentVal());
//            }
            //           System.out.println("++================++");

            String str = instantiateTemplate(template, init_state, sol);

            System.out.println("in fun bfs checking: " + str);

            if (isValidTemplate(sol, str, sol.isCheck, template, init_state)) {

                System.out.println("find valid values");

                SearchStat toVisit = init_state.copy();
                toVisit.tmpltStr = str;
                toVisit.sol = sol;
                workingStat.add(toVisit);
            }
            init_state.nextStat();
        }

        List<SearchStat> new_stats = new LinkedList<>();
        // refine and search for other instances
        for (int i = 1; i < sols.size(); i++) {
            ASolution prev_sol = sols.get(i - 1);
            ASolution current_sol = sols.get(i);
            if (i > 1) {
                workingStat = new_stats;
                new_stats = new LinkedList<>();
            }
            for (SearchStat state : workingStat) {
                if (!state.updateHoles(prev_sol, current_sol)) {
                    new_stats.add(state);
                    continue;
                }
                while (state.hasNext()) {
                    String tmpltStr = instantiateTemplate(template, state, current_sol);
                    if (isValidTemplate(current_sol, tmpltStr, current_sol.isCheck, template, state)) {
                       // System.out.println("sub valid");
                        SearchStat newS = state.copy();
                        newS.tmpltStr = tmpltStr;
                        newS.sol = current_sol;
                        new_stats.add(newS);
                    }
                    state.nextStat();
                }
            }
        }
        tcount += new_stats.size();

        for(SearchStat ss : new_stats) {
            TemplateExprnPrinter tep = new TemplateExprnPrinter(template, ss, ss.sol);
            String tepwithexpr = tep.instantiate("");
            String model = tmp.pre + tepwithexpr + tmp.append;

            try {
                A4Reporter rep = new A4Reporter();
                CompModule module = CompUtil.parseEverything_fromString(rep, model);
                for (Command cmd : module.getAllCommands()) {
                    if (cmd.check) {
                        A4Solution solution = TranslateAlloyToKodkod.execute_command(rep, module.getAllReachableSigs(), cmd, new A4Options());
                        if (solution.satisfiable()) {

                          //  sols.add(new ASolution(solution, module, true, cmd));
                            //System.out.println(sols.size());
                            // String res = solution.eval(CompUtil.parseOneExpression_fromString(module, )).toString();
                            // System.out.println(res);
                        } else {
                            System.out.println("*****find****");
                            System.out.println("patched expression: " + tepwithexpr);
                            System.out.println("repaired model:\n " + model);
                            System.exit(0);
                        }
                    }
                }
            }catch (Err err){
                //err.printStackTrace();
                //System.exit(0);
            }
        }

        return new_stats.size() > 0;
    }

    public static boolean isValidTemplate(ASolution sol, String str, boolean check, Template t, SearchStat ss) {
        for (ExprVar a : sol.alloySol.getAllAtoms()) {
            sol.world.addGlobal(a.label, a);
        }
        for (ExprVar a : sol.alloySol.getAllSkolems()) {
            sol.world.addGlobal(a.label, a);
        }

        Expr expr = null;
        try {
            expr = CompUtil.parseOneExpression_fromString(sol.world, str);
            Object res = sol.alloySol.eval(expr);

            Boolean b = (Boolean) res;
            return ((check && !b) ||
                    (!check && b));
        } catch (Err err) {

//            for(HoleStat hs : ss.holes){
//                System.out.println(hs.hole.getType());
//                System.out.println( hs.values );
//                System.out.println(hs.getCurrentVal());
//            }
//            System.out.println(str);
//           err.printStackTrace();
//           System.exit(0);
            return false;
        }
    }

    public static String instantiateTemplate(Template template, SearchStat state, ASolution sol) {
        TemplatePrinter tp = new TemplateValuePrinter(template, state);
        String expr = tp.instantiate("test").replaceAll(",", "+");
        return tcp.pre + expr + tcp.append;
    }

    public static List<ASolution> generateInstances(CompModule world, AModel model, int max) {
        LOGGER.logDebug(Patcher.class, "generating cex and instances...");

        List<ASolution> solutions = new ArrayList<>();
        InstanceGenerator ig = new InstanceGenerator(world);

        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs(ig.world.getAllCommands());
        for (Pair<Command, Command> p : pairs) {
            try {
                List<InstancePair> ips = ig.genInstancePair(p.a, p.b, max);
                for(InstancePair ip : ips){
                    solutions.add( new ASolution(ip.counter.sol, world, true, p.a) );
                    solutions.add( new ASolution(ip.counter.sol, world, false, p.b) );
                }
            } catch (Err err) {
                err.printStackTrace();
            }
        }
        return solutions;


//
//        int cexcount = 0;
//        int satcount = 0;
//        for (Command cmd : world.getAllCommands()) {
//            if(cmd.label.contains("repair")) {
//                int num = 0;
//                A4Solution sol = null;
//                do {
//                    try {
//                        sol = TranslateAlloyToKodkod.execute_command(new A4Reporter(), world.getAllReachableSigs(), cmd, new A4Options());
//                        if (sol.satisfiable()) {
//                            solutions.add(new ASolution(sol, world, cmd.check, cmd));
//                            num++;
//                        }
//                    } catch (Err err) {
//                        err.printStackTrace();
//                    }
//                } while (num < max);
//            }
//        }
//
//        return solutions;
    }

//    public static List<Pair<ASolution, ASolution>> generateInstancePairs(CompModule world, int max, Pair<Command, Command> cmds){
//        List<Pair<ASolution, ASolution>> sols = new ArrayList<>(max);
//        for(int i = 0; i < max; i++){
//            try {
//                A4Solution counter = TranslateAlloyToKodkod.execute_command(new A4Reporter(), world.getAllReachableSigs(), cmds.a, new A4Options());
//                A4Solution expected = TranslateAlloyToKodkod.execute_command(new A4Reporter(), world.getAllReachableSigs(), cmds.b, new A4Options());
//                ASolution c = new ASolution(counter, world, true);
//                ASolution e = new ASolution(expected, world, false);
//                sols.add( new Pair<>(c, e) );
//            } catch (Err err) {
//                err.printStackTrace();
//            }
//        }
//        return sols;
//    }
}
