package compare;

import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import parser.ast.Exprn;
import utility.LOGGER;
import utility.StringUtil;

import java.util.HashSet;
import java.util.Set;

public class InstancePair {
    public CompModule world;
    public AlloySolution counter;
    public AlloySolution expected;

    // unsat core
    public Set<Exprn> locations;
    public BugType bugType;

    public Difference difference;

    public InstancePair(BugType bug)
    {
        this.bugType = bug;
    }

    public InstancePair(CompModule world, A4Solution counter, A4Solution expected){
        this.world = world;
        this.counter = new AlloySolution(world, counter);
        this.expected = new AlloySolution(world, expected);
        this.difference = new Difference(this.counter, this.expected);
    }

    public InstancePair(CompModule world, A4Solution counter, A4Solution expected, Set<Exprn> locations, BugType bug){
        this.world = world;
        this.counter = new AlloySolution(world, counter);
        this.expected = new AlloySolution(world, expected);
        this.difference = new Difference(this.counter, this.expected);
        this.locations = locations;
        this.bugType = bug;
    }

    public InstancePair(A4Solution counter, A4Solution expected){
        this.counter = new AlloySolution(world, counter);
        this.expected = new AlloySolution(world, expected);
    }

    // evaluate a tmpltStr for both counter and expected, choose the union of the result
    public Set<String> eval(String str){
        Set<String> vals = StringUtil.findAtoms(str);
        Boolean notInCounter = false;
        Boolean notInExpected = false;
        for( String val : vals ) {
            if (counter.val2sig.get(val) == null)
                notInCounter = true;
            if( expected.val2sig.get(val) == null)
                notInExpected = true;
        }

        Set<String> counterVals = notInCounter? new HashSet<>() : counter.evalInstantiated(str);

        Set<String> expectedVals = notInExpected? new HashSet<>() : expected.evalInstantiated(str);

        Set<String> result = expectedVals.size() > counterVals.size() ? expectedVals : counterVals;
        return result;
    }


    // find the difference between counter and expected
    public Difference findDiff(){
       // Difference difference = new Difference();
        for(String name : counter.sigs.keySet()){
            Set<String> counterVals = counter.getSigVal(name);
            Set<String> expectedVals = expected.getSigVal(name);
            for(String val : counterVals){
                if(!expectedVals.contains(val)){
                    difference.putExpectedSigs(name, val);
                    difference.putExpected(name, val);
                    LOGGER.logDebug(this.getClass(), "expected sig " + name + " doesn't contain: " + val );
                    //System.out.println("expected sig " + name + " doesn't contain: " + val);
                    difference.affectedVals.add(val);
                    difference.val2sig.put(val, name);
                }
            }
            for(String val : expectedVals){
                if(!counterVals.contains(val)){
                    difference.putCounterSigs(name, val);
                    difference.putCounter(name, val);
                    LOGGER.logDebug(this.getClass(), "counter sig " + name + " doesn't contain: " + val);
                    //System.out.println("counter sig " + name + " doesn't contain: " + val);
                    difference.affectedVals.add(val);
                    difference.val2sig.put(val, name);
                }
            }
        }

        for(String name : counter.fields.keySet()){
            Set<String> counterVals = counter.getFieldVal(name);
            Set<String> expectedVals = expected.getFieldVal(name);
            for(String val : counterVals){
                if(!expectedVals.contains(val)){
                    difference.putExpectedFields(name, val);
                    difference.putExpected(name, val);
                    LOGGER.logDebug(this.getClass(), "expected field " + name + " doesn't contain: " + val);
                    //System.out.println("expected field " + name + " doesn't contain: " + val);
                    for(String atomVal : val.split("->")){
                        difference.affectedVals.add(atomVal);
                        // TODO: use a stupid way of tracking int values
                        if(StringUtil.isInteger(atomVal))
                            difference.val2sig.put(atomVal, name);
                    }
                }
            }
            for(String val : expectedVals){
                if(!counterVals.contains(val)){
                    difference.putCounterFields(name, val);
                    difference.putCounter(name, val);
                    LOGGER.logDebug(this.getClass(), "counter fileld " + name + " doesn't contain: " + val);
                    //System.out.println("counter fileld " + name + " doesn't contain: " + val);
                    for(String atomVal : val.split("->")){
                        difference.affectedVals.add(atomVal);
                        // TODO: use a stupid way of tracking int values
                        if(StringUtil.isInteger(atomVal))
                            difference.val2sig.put(atomVal, name);
                    }
                }
            }
        }

        for( String val : difference.affectedVals ){
            String sigName = val.split("\\$")[0];
            Set<String> involvedVals = difference.differenceInvolvedsig2vals.get(sigName);
            if( involvedVals == null)
                involvedVals = new HashSet<>();
            involvedVals.add(val);
            difference.differenceInvolvedsig2vals.put(sigName, involvedVals);
        }

        return difference;
    }

}
