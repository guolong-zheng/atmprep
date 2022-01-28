package tests;

import at.unisalzburg.dbresearch.apted.costmodel.StringUnitCostModel;
import at.unisalzburg.dbresearch.apted.distance.APTED;
import at.unisalzburg.dbresearch.apted.node.Node;
import at.unisalzburg.dbresearch.apted.node.StringNodeData;
import at.unisalzburg.dbresearch.apted.parser.BracketStringInputParser;
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
import parser.ast.ExprnBinaryBool;
import synth.*;
import synth.syntaxtemplates.printers.*;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.template.seed.Seed;
import synth.syntaxtemplates.template.seed.SeedGenerator;
import synth.varcollectors.Var;
import synth.varcollectors.VarCollector;
import util.RepairOption;
import util.RepairReporter;
import util.atrepair;
import utility.AlloyUtil;
import utility.LOGGER;

import java.util.*;

import static parser.ast.ExprnBinaryBool.Op.*;

public class PatcherTest {
    static int max = 1; // max # of instances

    static int maxdepth = 3;

    static CompModule world;

    static AModel model;

    static Exprn faultyExprn;

    static TemplateCommandPrinter tcp;
    static TemplateModelPrinter tmp;

    static RepairOption opt = new RepairOption();


    static int count = 0;

    public static void repair(String path) throws Err {

        LOGGER.setTimer();
        LOGGER.setLevel(LOGGER.Level.No);

        // compute alloy module
        try {
            world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
        } catch (Err err) {
            err.printStackTrace();
        }

        // initialization
        model = new AModel(world);

        //RepairOption opt = new RepairOption(model, world.getAllCommands(), path);
        opt.model = model;
        opt.cmds = world.getAllCommands();
        opt.path = path;
        opt.max_inst = max;
        opt.exprn_depth = maxdepth;
        opt.is_prune = false;

        // get fault localization
        Locator locator = new Locator();
        locator.localize(model, world, 5);

        if(locator.result.size() == 0) {
            System.out.println("@-@-@NoFL@-");
            System.exit(0);
        }

        for (Exprn exprn : locator.result) {
           // System.out.println("faulty expression: " + exprn);
            faultyExprn = exprn;
            find_repair();
        }
        System.out.println("@-@-@NotFind@-");
    }


    public static void find_repair(){
        // first try simple mutations
        LOGGER.logInfo(atrepair.class, "bug expression: " + faultyExprn);

        ExprMutator mutator = new ExprMutator(opt, faultyExprn, new RepairReporter(false));

//        System.out.println(faultyExprn);
//        System.exit(0);

        LOGGER.logDebug(atrepair.class, "checking mutations with bound");

        mutator.mutate();

        if (mutator.rep.isfix) {
            LOGGER.logInfo(atrepair.class, "fix found:\n" + model.toString());
            return;
        } else {
            LOGGER.logInfo(atrepair.class, "searching templates.\n");

            // collect live variables
            VarCollector vc = new VarCollector(model);
            Set<Var> livevars = vc.collectDeclVars(faultyExprn);
            LOGGER.logInfo(atrepair.class, "live variables: " + livevars);

            // generate all relational expressions
            RelationExprSynthesizer exprSynthesizer = new RelationExprSynthesizer(opt.exprn_depth, 3);
            exprSynthesizer.synth(vc.sigNfield);
//            System.out.println(vc.sigNfield);
//            System.exit(0);

            ASolution.type2exprns = exprSynthesizer.groupByType();

            LOGGER.logDebug(atrepair.class, "# of relational types: " + ASolution.type2exprns.keySet().size());
            ASolution.type2exprns.forEach((k, v) -> {
                LOGGER.logDebug(PatcherTest.class, k + "," + v.size() + ": ");
                LOGGER.logDebug(PatcherTest.class, v.toString());
            });

//            ASolution.type2exprns.forEach((k, v) -> {
//                System.out.println(k + "," + v.size() + ": ");
//                System.out.println(v.toString());
//            });
//            System.exit(0);

            // generates solutions and evaluation each expression
            List<SolutionPair> solutions = generateInstances(world, model, max);
            for (SolutionPair sol : solutions) {
                sol.cex.evalAllExprns();
                sol.sat.evalAllExprns();
            }

            TemplateModelPrinter tmp = new TemplateModelPrinter(model, faultyExprn);
            tmp.print();

            parser.ast.Node cur_parent = faultyExprn;
            parser.ast.Node nxt_parent = cur_parent.parent;
            while (nxt_parent instanceof Exprn) {
                nxt_parent = nxt_parent.parent;
                cur_parent = cur_parent.parent;
            }

            TemplateModelPrinter tmp_replace_all = new TemplateModelPrinter(model, (Exprn) cur_parent);
            tmp_replace_all.print();


            template_repair(solutions, livevars, tmp, tmp_replace_all);

        }
    }

    public static void template_repair(List<SolutionPair> solutions, Set<Var> livevars, TemplateModelPrinter tmp, TemplateModelPrinter tmp_replace_all){

        // generate seed templates
        SeedGenerator mg = new SeedGenerator();

        // generate templates with only boolean operators, no logic operators
        List<Seed> seeds = mg.generate(world, model, solutions, opt.init_inst, opt);
        LOGGER.logDebug(PatcherTest.class, "candidate template seeds: ");

        Set<String> visited = new HashSet<>();

        // prune each seed template
        for (Seed seed : seeds) {
            LOGGER.logDebug(PatcherTest.class, seed.exprn.toString());

            List<Hole> searchingholes = new ArrayList<>();
            for (Hole hole : seed.holes) {
                if (!hole.is_atom && !hole.is_exprn) {
                    searchingholes.add(hole);
                    hole.setValues(seed.solutions.cex.type2vals.get(hole.getType()));
                }
            }
            SearchStat init_state = new SearchStat(searchingholes);

            while (init_state.hasNext()) {
                SeedPrinter sp = new SeedValuePrinter(seed, init_state);
                String str = sp.instantiate();
                if (seed.solutions.is_diff(str.replaceAll(",", "+"))) {
                    if (!visited.contains(str)) {
                        RepairReporter rep = check_fix(seed, init_state, livevars, tmp, tmp_replace_all);
                    }
                }
                init_state.nextStat();
            }
        }
    }

    public static RepairReporter check_fix(Seed seed, SearchStat ss, Set<Var> lives, TemplateModelPrinter tmp, TemplateModelPrinter tmp_replace_all) {

        SeedExprnPrinter sep = new SeedExprnPrinter(seed);
        sep.instantiate(ss, lives);

        for (StringBuilder sb : sep.results) {
            String exprnstr = sb.toString();
            for (String patch : patch(exprnstr, faultyExprn.toString())) {
                String modelstr = tmp.pre + patch + tmp.append;
                try {
                    Boolean repaired = true;
                    A4Reporter rep = new A4Reporter();
                    CompModule cm = CompUtil.parseEverything_fromString(rep, modelstr);
                    for (Command cmd : cm.getAllCommands()) {
                        if (cmd.label.contains("repair")) {
                            A4Solution a4sol = TranslateAlloyToKodkod.execute_command(rep, cm.getAllReachableSigs(), cmd, new A4Options());
                            if (cmd.check) {
                                if (a4sol.satisfiable()) {
                                    repaired = false;
                                    break;
                                }
                            } else {
                                if (!a4sol.satisfiable()) {
                                    repaired = false;
                                    break;
                                }
                            }
                        }
                    }
                    if (repaired) {
                        //System.out.println("repaired model:\n"+modelstr);
                        System.out.println(opt.path + "@" + patch + "@" + LOGGER.getTime()/1000.0 + "@R");
                        System.exit(0);
                        return new RepairReporter(modelstr, patch);
                    }
                } catch (Err err) {
                    // err.printStackTrace();
                    //return new RepairReporter(false);
                }
            }

            String replace_all_str = tmp_replace_all.pre + exprnstr + tmp_replace_all.append;
            try {
                Boolean repaired = true;
                A4Reporter rep = new A4Reporter();
                CompModule cm = CompUtil.parseEverything_fromString(rep, replace_all_str);
                for (Command cmd : cm.getAllCommands()) {
                    if (cmd.label.contains("repair")) {
                        A4Solution a4sol = TranslateAlloyToKodkod.execute_command(rep, cm.getAllReachableSigs(), cmd, new A4Options());
                        if (cmd.check) {
                            if (a4sol.satisfiable()) {
                                repaired = false;
                                break;
                            }
                        } else {
                            if (!a4sol.satisfiable()) {
                                repaired = false;
                                break;
                            }
                        }
                    }
                }
                if (repaired) {
                    //System.out.println("repaired model:\n"+replace_all_str);
                    System.out.println(opt.path + "@" + exprnstr + "@" + LOGGER.getTime()/1000.0 + "@R");
                    System.exit(0);
                    return new RepairReporter(replace_all_str, exprnstr);
                }
            } catch (Err err) {
                // err.printStackTrace();
                //return new RepairReporter(false);
            }
        }
        return new RepairReporter(false);
    }

    public static boolean prune(Seed seed, List<SolutionPair> sols) {
        for (SolutionPair pair : sols) {
            if (pair.cex.evalExprn(seed.exprn) != pair.sat.evalExprn(seed.exprn))
                return true;
        }
        return false;
    }

    public static boolean isValidTemplate(ASolution sol, String str, boolean check, Template t, SearchStat ss) {
        for (ExprVar a : sol.getAlloySol().getAllAtoms()) {
            sol.world.addGlobal(a.label, a);
        }
        for (ExprVar a : sol.getAlloySol().getAllSkolems()) {
            sol.world.addGlobal(a.label, a);
        }

        Expr expr = null;
        try {
            expr = CompUtil.parseOneExpression_fromString(sol.world, str);
            Object res = sol.getAlloySol().eval(expr);

            Boolean b = (Boolean) res;
            return b;
        } catch (Err err) {
            return false;
        }
    }

    public static String instantiateTemplate(Template template, SearchStat state) {
        TemplatePrinter tp = new TemplateValuePrinter(template, state);
        String expr = tp.instantiate("test").replaceAll(",", "+");
        return tcp.pre + expr + tcp.append;
    }

    public static List<SolutionPair> generateInstances(CompModule world, AModel model, int max) {
        LOGGER.logDebug(atrepair.class, "generating cex and instances...");

        List<SolutionPair> solutions = new ArrayList<>();
        InstanceGenerator ig = new InstanceGenerator(world);

        Pair<Command, Command> pair = AlloyUtil.findCommandPairs(ig.world.getAllCommands()).get(0);
        try {
            List<InstancePair> ips = ig.genInstancePair(pair.a, pair.b, max);
            for (InstancePair ip : ips) {
                SolutionPair sp = new SolutionPair(new ASolution(ip.counter.sol, world, true, pair.a),
                        new ASolution(ip.expected.sol, world, false, pair.b));
                solutions.add(sp);
            }
        } catch (Err err) {
            err.printStackTrace();
        }

        return solutions;
        //  return solutions;
    }

    // searching valid templates
    public static boolean search(Template template, List<ASolution> sols) {
        TemplatePrinter tp = new TemplatePrinter(template);
        LOGGER.logDebug(PatcherTest.class, "checking: " + tp.instantiate("??"));

        ASolution sol = sols.get(0);

        for (Hole h : template.holes) {
            Type hole_type = h.getType();
            h.setValues(sol.type2vals.get(hole_type));
        }

        tcp = new TemplateCommandPrinter(model, sol.cmd);
        tcp.getPreAndAppend(faultyExprn);

        SearchStat init_state = new SearchStat(template.holes);

        Map<Hole, Set<Exprn>> hole2exprns = new HashMap<>();

        while (init_state.hasNext()) {
            String str = instantiateTemplate(template, init_state);
            if (isValidTemplate(sol, str, sol.isCheck, template, init_state)) {
                for (HoleStat holestat : init_state.holes) {
                    Set<Exprn> exprns = hole2exprns.getOrDefault(holestat.hole, new HashSet<Exprn>() {
                    });
                    exprns.addAll(sol.getExprnByStr(holestat.getCurrentVal()));
                    hole2exprns.put(holestat.hole, exprns);
                }
            }
            init_state.nextStat();
        }

        if (hole2exprns.size() != 0) {
            for (int i = 1; i < sols.size(); i++) {
                ASolution nsol = sols.get(i);
                for (Hole h : template.holes) {
                    Set<Exprn> exprns = hole2exprns.get(h);
                    if (exprns == null) {
                        return false;
                    }
                    h.setValues(nsol.evalExprns(exprns));
                }
                hole2exprns.clear();

                SearchStat state = new SearchStat(template.holes);

                while (state.hasNext()) {
                    String str = instantiateTemplate(template, state);
                    if (isValidTemplate(nsol, str, nsol.isCheck, template, state)) {
                        for (HoleStat holestat : state.holes) {
                            Set<Exprn> exprns = hole2exprns.getOrDefault(holestat.hole, new HashSet<>());
                            if (nsol.getExprnByStr(holestat.getCurrentVal()) == null)
                                return false;
                            exprns.addAll(nsol.getExprnByStr(holestat.getCurrentVal()));
                            hole2exprns.put(holestat.hole, exprns);
                        }
                    }
                    state.nextStat();
                }
                if (hole2exprns.size() == 0) {
                    return false;
                }
                template.hole2exprns = hole2exprns;
            }

            for (Hole hole : template.holes) {
                List<Exprn> sortedList = new ArrayList<>(template.hole2exprns.get(hole));
                Collections.sort(sortedList, new Comparator<Exprn>() {
                    @Override
                    public int compare(Exprn o1, Exprn o2) {
                        return o1.toString().length() - o2.toString().length();
                    }
                });
                template.hole2sortedexprns.put(hole, sortedList);
            }

            RepairReporter reporter = check_fix(template);
            reporter.time = LOGGER.getTime();
            if (reporter.isfix) {
                System.out.println("total time: " + reporter.time);
                System.out.println("repaired expression: " + reporter.exprn);
                System.out.println("repaired model: " + reporter.model);
                System.exit(0);
            }
        }

        return hole2exprns != null && hole2exprns.size() > 0;
    }

    public static RepairReporter check_fix(Template template) {
        TemplateExprnPrinter tep = new TemplateExprnPrinter(template);
        String exprnstr = tep.instantiate("");
        TemplateModelPrinter tmp = new TemplateModelPrinter(model, faultyExprn);
        tmp.print();
        String modelstr = tmp.pre + exprnstr + tmp.append;
        try {
            Boolean repaired = true;
            A4Reporter rep = new A4Reporter();
            CompModule cm = CompUtil.parseEverything_fromString(rep, modelstr);
            for (Command cmd : cm.getAllCommands()) {
                A4Solution a4sol = TranslateAlloyToKodkod.execute_command(rep, cm.getAllReachableSigs(), cmd, new A4Options());
                if (cmd.check) {
                    if (a4sol.satisfiable())
                        return new RepairReporter(false);
                } else {
                    if (!a4sol.satisfiable())
                        return new RepairReporter(false);
                }
            }
            if (repaired) {
                return new RepairReporter(modelstr, exprnstr);
            }
        } catch (Err err) {
            err.printStackTrace();
            return new RepairReporter(false);
        }
        return new RepairReporter(false);
    }

    public static List<String> patch(String expr, String fault) {
        List<String> patchexprn = new ArrayList<>();
        patchexprn.add(expr);

        ExprnBinaryBool.Op[] symops = {IFF, AND, OR};
        ExprnBinaryBool.Op[] asymops = {IMPLIES};

        for (ExprnBinaryBool.Op op : symops) {
            patchexprn.add(expr + op + fault);
        }
        for (ExprnBinaryBool.Op op : asymops) {
            patchexprn.add(expr + op + fault);
            patchexprn.add(fault + op + expr);
        }
        return patchexprn;
    }

}

