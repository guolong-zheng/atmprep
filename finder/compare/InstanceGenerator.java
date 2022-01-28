package compare;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import parser.ast.*;
import utility.NodeCounter;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class InstanceGenerator {
    public String model;
    public A4Reporter rep;
    public CompModule world;

    public A4Solution counterExample;
    public A4Solution expectedInst;

    public InstanceGenerator(String path) {
        this.model = path;
        try {
            this.world = CompUtil.parseEverything_fromFile(rep, null, model);
        } catch (Err err) {
            err.printStackTrace();
        }
        this.rep = new A4Reporter();
    }

    public InstanceGenerator(CompModule world){
        this.world = world;
        this.rep = new A4Reporter();
    }

    public InstancePair genInstancePair(Command asst, Command pred){
        A4Options opt = new A4Options();
        /* set solver to MiniSat with prover to extract unsat core when needed */
        opt.solver = A4Options.SatSolver.MiniSatProverJNI;
        try {
            A4Solution counterExample = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), asst, opt);
            if(!counterExample.satisfiable())
                return new InstancePair(BugType.NO_BUG);
            A4Solution expectedInst = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllSigs(), pred, opt, this.counterExample);
            /* if expected instance is unsat, remove unsat core and generate new expected instance */
            if(!expectedInst.satisfiable()){
                A4Solution unsatSol = TranslateAlloyToKodkod.execute_command(rep, world.getAllSigs(), pred, opt);
                /*TODO: remove expr in repair_pred, though it doesn't matter, as it will always eval to true*/
                AModel sliceModel = new AModel(world, unsatSol.unsatObj());
                CompModule slicedWorld = CompUtil.parseEverything_fromString(new A4Reporter(), sliceModel.toString());
                for( Command cmd : slicedWorld.getAllCommands() ){
                    if( cmd.label.equals(pred.label) ){
                        expectedInst = TranslateAlloyToKodkod.execute_command_with_target(rep, slicedWorld.getAllSigs(), cmd, opt,
                                counterExample);
                    }
                }
                Set<Exprn> locations = new HashSet<>();
                for(Expr expr : unsatSol.unsatExpr() )
                {
                    Exprn exprn = Exprn.parseExpr(null, expr);
                   if((boolean)expectedInst.eval( CompUtil.parseOneExpression_fromString(slicedWorld, exprn.toString())) == false ){
                       locations.add(exprn);
                   }
                }
                return new InstancePair(slicedWorld, counterExample, expectedInst, locations, BugType.NO_EXPECT);
            }

        }catch(Err err){
            err.printStackTrace();
        }
        return new InstancePair(world, counterExample, expectedInst);
    }

    public List<InstancePair> genInstancePair(Command asst, Command pred, int total) throws Err {
        A4Options opt = new A4Options();
        List<InstancePair> res = new LinkedList<>();

        A4Solution counterExample = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), asst, opt);

        for(int i = 0; i < total; i++) {
            if (!counterExample.satisfiable()) {
                A4Solution expected = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), pred, opt);
                if( expected.satisfiable() ) {
                    res.add(new InstancePair(BugType.NO_BUG));
                    break;
                } else {
                    opt.solver = A4Options.SatSolver.MiniSatProverJNI;
                    A4Solution unsatSol = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), pred, opt);
                    Set<Object> unsatexprs = unsatSol.lowUnsatObj();
                    AModel sliced = new AModel(world, unsatexprs);
                    NodeCounter nc = new NodeCounter();
                    //unsatexprs.forEach(System.out::println);
                    //System.out.println(sliced);
                    nc.visit(sliced);
                    CompModule slicedWorld = CompUtil.parseEverything_fromString(new A4Reporter(), sliced.toString());
                    for (Command cmd : slicedWorld.getAllCommands()) {
                        if (cmd.label.equals(pred.label)) {
                            expectedInst = TranslateAlloyToKodkod.execute_command(rep, slicedWorld.getAllReachableSigs(), cmd, opt);
                        }
                    }
                    Set<Exprn> locations = new HashSet<>();
                    for (Object expr : unsatSol.unsatObj()) {
                        if( expr instanceof Sig || expr instanceof Sig.Field) continue;
                        Exprn exprn = Exprn.parseExpr(null, (Expr)expr);
                        StringBuilder pre = new StringBuilder();
                        if( exprn instanceof ExprnQtBool){
                            boolean add_parent = true;
                            Set<Exprn> subs = new HashSet<>();
                            if(((ExprnQtBool) exprn).getSub() instanceof ExprnListBool){
                                ExprnListBool sub = (ExprnListBool)(((ExprnQtBool) exprn).getSub());
                                pre.append(((ExprnQtBool)exprn).op.toString());
                                for( Declaration v : ((ExprnQtBool) exprn).getVars()){
                                    pre.append(v.toString());
                                }
                                pre.append(" | ");
                                for(Exprn e : sub.args){
                                    String estr = pre + e.toString();
                                    if ((boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, estr)) == false) {
                                        subs.add(e);
                                    }else{
                                        add_parent = false;
                                    }
                                }
                            }
                            if (add_parent && (boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, exprn.toString())) == false)
                                    locations.add(exprn);
                                else
                                    locations.addAll(subs);
                        }else {
                            if(expr == null)
                                continue;
                            if ((boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, exprn.toString())) == false) {
                                locations.add(exprn);
                            }
                        }
                    }
                    res.add( new InstancePair(slicedWorld, counterExample, expectedInst, locations, BugType.NO_EXPECT) );
                    break;
                }
            }

            A4Solution expectedInst = TranslateAlloyToKodkod.execute_command_with_target(rep, world.getAllReachableSigs(), pred, opt, counterExample);

            /* if expected instance is unsat, remove unsat core and generate new expected instance */
                if (!expectedInst.satisfiable()) {
                    /* set solver to MiniSat with prover to extract unsat core when needed */
                    opt.solver = A4Options.SatSolver.MiniSatProverJNI;
                    A4Solution unsatSol = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), pred, opt);

                    AModel sliceModel = new AModel(world, unsatSol.unsatObj());
                   // System.out.println(sliceModel);
                  // System.out.println(unsatSol.unsatExpr());
                    NodeCounter nc = new NodeCounter();
                    nc.visit(sliceModel);
                   // System.out.println("node in sliced: " + nc.count);

                    CompModule slicedWorld = CompUtil.parseEverything_fromString(new A4Reporter(), sliceModel.toString());
                    //System.out.println(sliceModel);
                    for (Command cmd : slicedWorld.getAllCommands()) {
                        if (cmd.label.equals(pred.label)) {
                            expectedInst = TranslateAlloyToKodkod.execute_command_with_target(rep, slicedWorld.getAllReachableSigs(), cmd, opt,
                                    counterExample);
                        }
                    }

                    Set<Exprn> locations = new HashSet<>();

                    for (Expr expr : unsatSol.unsatExpr()) {
                        Exprn exprn = Exprn.parseExpr(null, expr);
                        StringBuilder pre = new StringBuilder();
                        if( exprn instanceof ExprnQtBool){
                            if(((ExprnQtBool) exprn).getSub() instanceof ExprnListBool){
                                ExprnListBool sub = (ExprnListBool)(((ExprnQtBool) exprn).getSub());
                                pre.append(((ExprnQtBool)exprn).op.toString());
                                String varDecls  = ((ExprnQtBool) exprn).getVars().stream().map(Object::toString).collect(Collectors.joining(",")).toString();
                                pre.append(varDecls);
                                pre.append(" | ");
                                for(Exprn e : sub.args){
                                    String estr = pre + e.toString();

                                    if ((boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, estr)) == false) {
                                        locations.add(e);
                                    }
                                }
                            }else{
                                if ((boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, exprn.toString())) == false) {
                                    locations.add(exprn);
                                }
                            }
                        }else {
                            if ((boolean) expectedInst.eval(CompUtil.parseOneExpression_fromString(slicedWorld, exprn.toString())) == false) {
                                locations.add(exprn);
                            }
                        }
                    }

                    res.add( new InstancePair(slicedWorld, counterExample, expectedInst, locations, BugType.NO_EXPECT) );
                }else {
                    res.add(new InstancePair(world, counterExample, expectedInst));
                }
            counterExample = counterExample.next();
        }
        return res;
    }
}
