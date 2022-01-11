package compare;

import edu.mit.csail.sdg.alloy4.ConstList;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import utility.LOGGER;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Difference {
    AlloySolution counter;
    public Map<String, Set<String>> notInCounter;
    public Map<String, Set<String>> notInCounterSigs;
    Map<String, Set<String>> notInCounterFields;

    AlloySolution expected;
    public Map<String, Set<String>> notInExpected;
    public Map<String, Set<String>> notInExpectedSigs;
    Map<String, Set<String>> notInExpectedFields;

    Set<String> keywords;

    // all affected atom values in string
    // for example:
    // notInCounter = { listed = [Book$0->Name$0->Address$0, Book$0->Name$1->Address0]}
    // affectedVals = {Book$0, Name$0, Name$1, Address$0}
    public Set<String> affectedVals;
    public Map<String, Set<String>> differenceInvolvedsig2vals;
    public Map<String, String> val2sig; // map different value to sig/field name

    public static Map<String, Integer> priority = new HashMap<>();

    public Difference(AlloySolution counter, AlloySolution expected){
        this.counter = counter;
        this.expected = expected;
        this.notInCounter = new HashMap<>();
        this.notInCounterSigs = new HashMap<>();
        this.notInCounterFields = new HashMap<>();
        this.notInExpected = new HashMap<>();
        this.notInExpectedSigs = new HashMap<>();
        this.notInExpectedFields = new HashMap<>();
        this.keywords = new HashSet<>();
        this.affectedVals = new HashSet<>();
        this.differenceInvolvedsig2vals = new HashMap<>();
        this.val2sig = new HashMap<>();
        this.priority = new HashMap<>();
    }

    /*
    * calculate priority based on the difference
    * */
    public void calPrio(){
        this.calPrio(counter, notInCounter);
        this.calPrio(expected, notInExpected);
        System.out.println("priority is : " + priority.toString());
    }

    /*
    * extract related relation name based on the difference
    * */
    public Set<String> getRelatedRelations(){
        Set<String> relationNames = new HashSet<>();
        for( String key : notInCounter.keySet()){
            relationNames.add(key);
        }
        for( String key : notInExpected.keySet()){
            relationNames.add(key);
        }
        return relationNames;
    }

    /*
    * try to get expression that will always return one atom
    * */
    public Set<String> getPossibleKeywords(){
        Set<String> possbileKeywords = new HashSet<>();
        possbileKeywords.addAll(findName(counter, notInCounter));
        possbileKeywords.addAll(findName(expected, notInExpected));
        return possbileKeywords;
    }

    /*
    * find possible hidden name for each atom
    * For example:
    *     a = {x0}
    *     b = {x0->x1}
    *     x1 can be refered as a.b
    * */
    public Set<String> findName(AlloySolution sol, Map<String, Set<String>> targets){
        Set<String> possibleKeywords = new HashSet<>();
        for( String key : targets.keySet()){
            for( String tuple : targets.get(key)){
                possibleKeywords.addAll( sol.findPossibleKeywords(tuple) );
            }
        }
        return possibleKeywords;
    }

    /*
    * Calculate priority for each node based on difference
    * */
    public void calPrio(AlloySolution sol, Map<String, Set<String>> targets){
        if(targets.isEmpty())
            return;
        Map<String, String[]> rel2specifiedval = new HashMap<>();
        targets.keySet().stream().forEach(key -> targets.get(key).forEach(
                val -> {
                    rel2specifiedval.put(key, sol.findMostSpecifiedName(val));
                }
        ));

        for (String s : rel2specifiedval.keySet()) {
            String name = s.contains(".") ? s.substring(s.indexOf(".")+1) : s;
            Integer i = priority.get(name);
            if( i == null){
                priority.put(name, 5);
            }else
                priority.put(name, i + 10);
            for( String atom : rel2specifiedval.get(s) ){
                int subprio = increasePrio(atom);
                // if atom is a sig name, check if the sig extends any abstract sigs
                if( !atom.contains(".")) {
                    Sig sig = sol.name2sig.get(atom);
                    if (sig instanceof Sig.PrimSig) {
                        Sig.PrimSig parents = ((Sig.PrimSig) sig).parent;
                        if (parents != null && !parents.builtin) {
                            increasePrio(parents.label, subprio);
                        }
                    } else {
                        ConstList<Sig> parents = ((Sig.SubsetSig) sig).parents;
                        for (Sig p : parents) {
                            increasePrio(p.label, subprio);
                        }
                    }
                }
            }
        }
    }

    public int increasePrio(String atom){
        Integer i = priority.get(atom);
        if( i == null){
            priority.put(atom,  5 );
            return 1;
        }else {
            priority.put(atom,  i + 5 );
            return i + 1;
        }
    }

    public int increasePrio(String atom, int inc){
        Integer i = priority.get(atom);
        i = i == null ? inc : i + inc;
        priority.put(atom, i);
        return i;
    }

    @Override
    public String toString() {
        return "not in counter: " + notInCounter.toString() + "\n" + "not in expected: " + notInExpected.toString();
    }

    /*
    public void locate(InfoCollector ic){
        PriorityQueue<Pair<Node, Integer> > node2prio = new PriorityQueue<>(new Comparator<Pair<Node, Integer>>() {
            @Override
            public int compare(Pair<Node, Integer> o1, Pair<Node, Integer> o2) {
                return o2.b - o1.b;
            }
        });

        for(Node node : ic.node2keywrod.keySet()){
            List<String> keywords = ic.node2keywrod.get(node);
            int prio = 0;
            for( String keyword : keywords ){
             //   System.out.println(keyword);
                for( String target : priority.keySet()){
                    if( keyword.contains(target) )
                        prio += priority.get(target);
                    else
                        prio -= 1;
                }
                //  prio += priority.get(keyword)==null ? 0 : priority.get(keyword);
            }
            node2prio.add(new Pair<>(node, prio));
        }

        int i = 0;
        while( !node2prio.isEmpty()){
            Pair<Node, Integer> p = node2prio.poll();
            System.out.println(++i + " " + p.a.getAlloyNode().toString() + " " + p.b);
        }
        System.out.println("total number is: " + i );
    }
*/

    public double compare(String str, Set<String> evaluatedVals){
        // remove all instantiatedVals
        Set<String> instantiatedVals = extractVals(str);
        evaluatedVals.removeAll(instantiatedVals);
        double score = 0;
        for( String val : evaluatedVals ){
            Set<String> differentVals = differenceInvolvedsig2vals.get(val.split("\\$")[0]);
            LOGGER.logDebug(Difference.class, "different atoms:" + (differentVals == null ? "none": differentVals.toString()));
            // if differentVals is null, evaluatedVals contains some values not in the difference
            // get a negative score
            if(differentVals == null) {
                score += -10;
            }
            // if val in differentVals
            else if( differentVals.contains(val) )
                score += 1.0 / differentVals.size();
            // if val not in differentVals
            else
                score += - 1.0 / differentVals.size();
        }
        //score = (score/ evaluatedVals.size());
        return score;
    }

    // extract atoms that has been instantiated to a expression
    public static Set<String> extractVals(String str){
        Set<String> involvedAtoms = new HashSet<>();
        String ptn = "[a-zA-Z]*\\$[0-9]+";
        Pattern pattern = Pattern.compile(ptn);
        Matcher matcher = pattern.matcher(str);
        while(matcher.find())
            involvedAtoms.add(matcher.group());
        return involvedAtoms;
    }

    public void putCounterSigs(String name, String val){
        Set<String> vals =  notInCounterSigs.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInCounterSigs.put(name, vals);
    }

    public void putCounterFields(String name, String val){
        Set<String> vals =  notInCounterFields.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInCounterFields.put(name, vals);
    }

    public void putCounter(String name, String val){
        Set<String> vals =  notInCounter.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInCounter.put(name, vals);
    }

    public void putExpectedSigs(String name, String val){
        Set<String> vals =  notInExpectedSigs.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInExpectedSigs.put(name, vals);
        //System.out.println(notInExpectedSigs);
    }

    public void putExpectedFields(String name, String val){
        Set<String> vals =  notInExpectedFields.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInExpectedFields.put(name, vals);
    }

    public void putExpected(String name, String val){
        Set<String> vals =  notInExpected.get(name);
        if(vals == null) {
            vals = new HashSet<>();
        }
        vals.add(val);
        notInExpected.put(name, vals);
    }
}
