package synth.syntaxtemplates.template.seed;

import compare.AlloySolution;
import compare.InstanceGenerator;
import compare.InstancePair;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4.SafeList;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.ExprVar;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import parser.ast.*;
import synth.ASolution;
import synth.Patcher;
import synth.SolutionPair;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.template.hole.ValueHole;
import tests.PatcherTest;
import util.RepairOption;
import utility.AlloyUtil;
import utility.LOGGER;
import utility.StringUtil;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SeedGenerator {

    // generate a list of seed templates
    public List<Seed> generate(CompModule world, AModel model, List<SolutionPair> solutions, int max, RepairOption opt){

        List<Seed> seeds = new ArrayList<>();

        for(SolutionPair ip : solutions) {
            ip.findDiffExprn();

            ASolution cex = ip.cex;
            ASolution sat = ip.sat;

            Set<ExprVar> atoms = new HashSet<>();
            // get shared atoms
            for (ExprVar v1 : cex.alloySol.getAllAtoms()) {
                for (ExprVar v2 : sat.alloySol.getAllAtoms()) {
                    if (v1.toString().equals(v2.toString())) {
                        atoms.add(v1);
                    }
                }
            }

            // atom and variables for relational expressions
            List<Seed> relexprns = genAtomRelExprn(ip, atoms);

            // generate boolean expressions
            List<Seed> booleanseeds = new ArrayList<>();
            booleanseeds.addAll( getUnarys(relexprns, ip) );
            booleanseeds.addAll( getBinarys(relexprns, ip) );

            List<Seed> potentialseeds = new ArrayList<>();

            if(opt.is_prune) {
                for (Seed m : booleanseeds) {
                    // rel expr in cex and sat that have different values
                    if (m.holes.size() == 1) {
                        Hole hole = m.holes.get(0);
                        if (!hole.is_atom) { // the hole cannot be atom hole like N0
                            List<Exprn> exprns = ip.type2diffexprns.get(hole.getType());
                            if (exprns != null && exprns.size() > 0) {
                                Hole potentialhole = new ValueHole(hole.getType(), exprns);
                                List<Hole> notchanged = new ArrayList<>();
                                List<Hole> tochange = new ArrayList<>();
                                List<Hole> changeto = new ArrayList<>();
                                tochange.add(hole);
                                changeto.add(potentialhole);

                                Exprn newe = copy(m.exprn, notchanged, tochange, changeto);
                                Seed new_seed = new Seed(newe, potentialhole, ip);

                                potentialseeds.add(new_seed);
                            }
                        }
                    } else {
                        List<Hole> notchanged = new ArrayList<>();
                        List<Hole> tochange = new ArrayList<>();
                        List<Hole> changeto = new ArrayList<>();

                        for (Hole hole : m.holes) {
                            if (!hole.is_atom) {
                                List<Exprn> exprns = ip.type2diffexprns.get(hole.getType());
                                if (exprns != null && exprns.size() > 0) {
                                    changeto.add(new ValueHole(hole.getType(), exprns));
                                    tochange.add(hole);
                                } else {
                                    notchanged.add(hole);
                                }
                            }
                        }

                        if (tochange.size() > 0) {
                            for (int i = 0; i < tochange.size(); i++) {
                                List<Hole> holes = new ArrayList<>();
                                List<Hole> cur_changeto = new ArrayList<>();
                                List<Hole> cur_tochange = new ArrayList<>();

                                holes.add(changeto.get(i));  // change ith to new hole
                                cur_changeto.add(changeto.get(i));
                                cur_tochange.add(tochange.get(i));
                                holes.addAll(notchanged);

                                for (int j = 0; j < tochange.size(); j++) {
                                    if (j != i) {
                                        holes.add(tochange.get(j));  // add all others back
                                    }
                                }
                                Exprn newe = copy(m.exprn, notchanged, cur_tochange, cur_changeto);
                                Seed new_seed = new Seed(newe, holes, ip);
                                potentialseeds.add(new_seed);
                            }

                            // if(tochange.size() > 1) {
                            List<Hole> holes = new ArrayList<>();
                            holes.addAll(notchanged);
                            holes.addAll(changeto);
                            Exprn newe = copy(m.exprn, notchanged, tochange, changeto);
                            Seed new_seed = new Seed(newe, holes, ip);
                            potentialseeds.add(new_seed);
                            // }
                        }
                    }
                }
                seeds.addAll(potentialseeds);
            }else
                seeds.addAll(booleanseeds);
        }

        return seeds;
    }

    public Exprn copy(Exprn exprn, List<Hole> nochanged, List<Hole> tochange, List<Hole> changeto){
        if( exprn instanceof ExprnBinaryRel){
            Exprn left = ((ExprnBinaryRel)exprn).left;
            Exprn right = ((ExprnBinaryRel)exprn).right;
            Hole newleft = (Hole)left;
            Hole newright = (Hole)right;
            if( tochange.contains(left) ){
                newleft = changeto.get( tochange.indexOf(left) );
            }
            if( tochange.contains(right) ){
                newright = changeto.get( tochange.indexOf(right) );
            }
            ExprnBinaryRel newe = new ExprnBinaryRel(newleft, newright, ((ExprnBinaryRel)exprn).op, exprn.type);
            return newe;
        }else if( exprn instanceof Hole){
                if( tochange.contains(exprn) ){
                    Hole newsub = changeto.get( tochange.indexOf(exprn) );
                    return newsub;
                }else
                    return exprn;

        }else if(exprn instanceof ExprnUnaryBool){
            ExprnUnaryBool tmp = (ExprnUnaryBool) exprn;
            if( tmp.sub instanceof ExprnBinaryRel){
                Exprn left = ((ExprnBinaryRel)tmp.sub).left;
                Exprn right = ((ExprnBinaryRel)tmp.sub).right;
                Hole newleft = (Hole)left;
                Hole newright = (Hole)right;
                if( tochange.contains(left) ){
                    newleft = changeto.get( tochange.indexOf(left) );
                }
                if( tochange.contains(right) ){
                    newright = changeto.get( tochange.indexOf(right) );
                }
                ExprnBinaryRel newsub = new ExprnBinaryRel(newleft, newright, ((ExprnBinaryRel)tmp.sub).op, tmp.type);
                Exprn newe = new ExprnUnaryBool(newsub, tmp.op);
                return newe;
            }else {
                if( tmp.sub instanceof Hole){
                    if( tochange.contains(tmp.sub) ){
                        Hole newsub = changeto.get( tochange.indexOf(tmp.sub) );
                        Exprn newe = new ExprnUnaryBool(newsub, tmp.op);
                        return newe;
                    }
                }
            }
        }else if(exprn instanceof ExprnBinaryBool){
            ExprnBinaryBool tmp = (ExprnBinaryBool) exprn;
            Exprn newleft = copy(tmp.left, nochanged, tochange, changeto);
            Exprn newright = copy(tmp.right, nochanged, tochange, changeto);
            Exprn newe = new ExprnBinaryBool(newleft, newright, tmp.op);
            return newe;
        }
        return null;
    }

    // generate relational expressions with atoms like atom.relexpr or relexpr.atom
    public List<Seed> genAtomRelExprn(SolutionPair sols, Set<ExprVar> atoms){
        List<Seed> seeds = new ArrayList<>();
        List<Seed> atomseeds = new ArrayList<>();

        // all possible types of holes
        Set<Type> types = ASolution.type2exprns.keySet();

        for(ExprVar atom : atoms){
            ExprnVar var = new ExprnVar(StringUtil.removeThis(atom.toString()), atom.type());
            Hole valueHole = new ValueHole(atom.type(), var);
            Seed atomHole = new Seed(valueHole, valueHole, atom.type(), true, sols);
            // atom expressions like Node0
            atomseeds.add(atomHole);
            seeds.add(atomHole);
        }

        for(Type type : types){
            Hole valueHole = new ValueHole(type);
            Seed no_del_exprn = new Seed(valueHole, valueHole, type, sols);
            // {x->x} relational expressions
            seeds.add(no_del_exprn);

            // generate atom.{x->x} relational expressions
            for(Seed atomseed : atomseeds){
                Type restype = atomseed.type.join(type);
                if(!restype.hasNoTuple()){
                    ExprnBinaryRel ebr = new ExprnBinaryRel( atomseed.holes.get(0), valueHole, ExprnBinaryRel.Op.JOIN, restype);
                    Seed atomrelseed = new Seed(ebr, atomseed.holes.get(0), valueHole, restype, sols);
                    seeds.add(atomrelseed);
                }
            }
        }

        return seeds;
    }

    public List<Seed> getUnarys(List<Seed> vals, SolutionPair sols){
        List<Seed> metas = new ArrayList<>();
        for(Seed val : vals){
            metas.addAll( genUnary(val, sols) );
        }

        return metas;
    }

    public List<Seed> genUnary(Seed sub, SolutionPair sols){
        if(sub.isAtom){
            return new ArrayList<>();
        }
        List<Seed> res = new ArrayList<>();
        Exprn lone = new ExprnUnaryBool(sub.exprn, ExprnUnaryBool.Op.LONE);
        Seed loneval = new Seed( lone, sub.holes, sols);

        Exprn one = new ExprnUnaryBool(sub.exprn, ExprnUnaryBool.Op.ONE);
        Seed oneval = new Seed( one, sub.holes, sols );

        Exprn some = new ExprnUnaryBool(sub.exprn, ExprnUnaryBool.Op.SOME);
        Seed someval = new Seed( some, sub.holes, sols);

        Exprn no = new ExprnUnaryBool(sub.exprn, ExprnUnaryBool.Op.NO);
        Seed noval = new Seed( no, sub.holes, sols);

        res.add(loneval);
        res.add(oneval);
        res.add(someval);
        res.add(noval);
        return res;
    }

    public List<Seed> getBinarys(List<Seed> vals, SolutionPair sols){
        List<Seed> metas = new ArrayList<>();
        for(int i = 0; i < vals.size(); i++){
            for(int j = i + 1; j < vals.size(); j++){
                Exprn left = vals.get(i).exprn;
                Exprn right = vals.get(j).exprn;

                if(left.getType().is_int() && right.getType().is_int())
                    metas.addAll( genBinaryInt( vals.get(i), vals.get(j), sols) );
                else if( left.getType().equals(right.getType()) || left.getType().isSubtypeOf(right.getType()) || right.getType().isSubtypeOf(left.getType())) {
                    metas.addAll(genBinaryRel(vals.get(i), vals.get(j), sols));
                }
            }
        }
        return metas;
    }


    public List<Seed> genBinaryRel(Seed left, Seed right, SolutionPair sols){
        List<Seed> res = new ArrayList<>();
        ExprnBinaryBool eq = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.EQUALS);
        ExprnBinaryBool in = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.IN);
        ExprnBinaryBool notin = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.NOT_IN);
        ExprnBinaryBool noteq = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.NOT_EQUALS);

        List<Hole> holes = new ArrayList<>();
        holes.addAll(left.holes);
        holes.addAll(right.holes);

        Seed eqseed = new Seed(eq, holes, sols);
        Seed inseed = new Seed(in, holes, sols);
        Seed notinseed = new Seed(notin, holes, sols);
        Seed noteqseed = new Seed(noteq, holes, sols);

        res.add(eqseed);
        res.add(inseed);
        res.add(notinseed);
        res.add(noteqseed);

        return res;
    }

    public List<Seed> genBinaryInt(Seed left, Seed right, SolutionPair sols){
        List<Seed> res = new ArrayList<>();

        ExprnBinaryBool eq = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.EQUALS);
        ExprnBinaryBool gt = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.GT);
        ExprnBinaryBool gte = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.GTE);
        ExprnBinaryBool lt = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.LT);
        ExprnBinaryBool lte = new ExprnBinaryBool(left.exprn, right.exprn, ExprnBinaryBool.Op.LTE);

        List<Hole> holes = new ArrayList<>();
        holes.addAll(left.holes);
        holes.addAll(right.holes);

        Seed eqseed = new Seed(eq, holes, sols);
        Seed gtseed = new Seed(gt, holes, sols);
        Seed gteseed = new Seed(gte, holes, sols);
        Seed ltseed = new Seed(lt, holes, sols);
        Seed lteseed = new Seed(lte, holes, sols);

        res.add(eqseed);
        res.add(gtseed);
        res.add(gteseed);
        res.add(ltseed);
        res.add(lteseed);
        return res;
    }



    public static List<InstancePair> generateInstances(CompModule world, AModel model, int max) {
        LOGGER.logDebug(Patcher.class, "generating cex and instances...");

        InstanceGenerator ig = new InstanceGenerator(world);

        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs(ig.world.getAllCommands());
        for (Pair<Command, Command> p : pairs) {
            try {
                List<InstancePair> ips = ig.genInstancePair(p.a, p.b, max);
                return ips;
            } catch (Err err) {
                err.printStackTrace();
            }
        }
        return null;
    }

    public boolean isSame(Exprn expr, AlloySolution cex, AlloySolution sat){
        String str = expr.toString();
        Boolean cexres = cex.evalInstantiatedBoolean(str);
        Boolean satres = sat.evalInstantiatedBoolean(str);
        if(cexres == null || satres == null)
            return true;
        return cexres.equals(satres);
    }

    public List<Seed> removeRedundant(List<Seed> seeds){
        Set<String> seedstrs = new HashSet<>();
        List<Seed> distseeds = new ArrayList<>();
        for(Seed seed : seeds){
            StringBuilder sb = new StringBuilder();
            seed.exprn.toGenericString(sb);
           // System.out.println(sb.toString());
            if(!seedstrs.contains( sb.toString() )){
                seedstrs.add( sb.toString() );
                distseeds.add( seed );
            }
        }
        return distseeds;
    }

    @Deprecated
    // get all atoms and variables can be used to generate seed templates
    public List<Seed> getMetaValue(AlloySolution inst){
        List<Seed> values = new ArrayList<>();

        SafeList<Sig> sigs = inst.sol.getAllReachableSigs();

        // all possible types of holes
        Set<Type> types = ASolution.type2exprns.keySet();
/*
        for(Sig sig : sigs){
            if(!sig.builtin) {
                String sigstr = StringUtil.removeThis(sig.toString());
                Hole valueHole = new ValueHole(sig.type(), new ExprnVar(sigstr, sig.type()));
                valueHole.setValue(sigstr);

                Seed vh = new Seed(valueHole, valueHole);
                values.add( vh );

                A4TupleSet sigatoms = inst.sol.eval(sig);
                for(A4Tuple a4Tuple : sigatoms){
                    for(int i = 0; i < a4Tuple.arity(); i++){
                        Hole atomhole = new ValueHole(sig.type());
                        atomhole.setValue(a4Tuple.atom(i));

                        Seed atomval = new Seed(atomhole, atomhole);
                        values.add( atomval );
                    }
                }


                SafeList<Sig.Field> fs = sig.getFields();
                for (Sig.Field f : fs) {
                    String field = StringUtil.removeThis(f.label);

                    Hole fieldhole = new ValueHole( f.type(), new ExprnVar(field, f.type()) );
                    fieldhole.setValue( field );

                    Seed fieldval = new Seed(fieldhole, fieldhole);
                    values.add( fieldval );

                    Hole sighole = new ValueHole( sig.type(), new ExprnVar(sigstr, sig.type()) );
                    sighole.setValue( sigstr );
                    Hole fdhole = new ValueHole( f.type(), new ExprnVar(field, f.type()) );
                    fdhole.setValue( field );
                    ExprnBinaryRel ebr = new ExprnBinaryRel( sighole, fdhole, ExprnBinaryRel.Op.JOIN, sig.type().join(f.type()) );

                    Seed ebrval = new Seed(ebr, sighole, fdhole);
                    values.add( ebrval );

                    for(A4Tuple a4Tuple : sigatoms){
                        for(int i = 0; i < a4Tuple.arity(); i++){
                            Hole sighole1 = new ValueHole( sig.type() );
                            sighole1.setValue( a4Tuple.atom(i) );
                            Hole fdhole1 = new ValueHole( f.type(), new ExprnVar(field, f.type()) );
                            fdhole1.setValue( field );
                            ExprnBinaryRel ebr1 = new ExprnBinaryRel( sighole1, fdhole1, ExprnBinaryRel.Op.JOIN, sig.type().join(f.type()) );

                            Seed ebr1val = new Seed(ebr1, sighole1, fdhole1);
                            values.add( ebr1val );
                        }
                    }
                }
            }

        }*/
        return values;
    }
}
