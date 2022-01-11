package compare;

import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.ast.ExprVar;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Tuple;
import edu.mit.csail.sdg.alloy4compiler.translator.A4TupleSet;
import utility.AlloyUtil;
import utility.StringUtil;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class AlloySolution {
    public A4Solution sol;
    CompModule world;

    public Map<String, Set<String>> name2vals;
    Map<String, Set<String>> sigs;
    Map<String, Set<String>> fields;

    Map<String, Sig> name2sig;
    public Map<String, Sig> val2sig;
    Map<String, Sig.Field> name2field;

    /* skolem values */
    public Set<String> skolems;

    public AlloySolution(CompModule world, A4Solution sol){
        this.sol = sol;
        this.world = world;
        name2vals = new HashMap<>();
        sigs = new HashMap<>();
        fields = new HashMap<>();
        name2sig = new HashMap<>();
        name2field = new HashMap<>();
        val2sig = new HashMap<>();
        skolems = new HashSet<>();

        for(ExprVar var : sol.getAllSkolems()){
            try {
                for(A4Tuple tuple : (A4TupleSet) sol.eval(var)){
                    skolems.add(tuple.toString());
                }
            } catch (Err err) {
                err.printStackTrace();
            }
        }

        name2valConvert(sol);
    }

    /*
    * Convert A4Solution to String maps
    * */
    public void name2valConvert(A4Solution sol){
        for(Sig sig : sol.getAllReachableSigs()){
            if (!AlloyUtil.isBuiltin(sig)) {
                String sigName = StringUtil.removeThis(sig.label);
                // add to name to sig map
                name2sig.put(sigName, sig);
                /* sig and its val */
                Set<String> atoms = new HashSet<>();
                for (A4Tuple tuple : sol.eval(sig)) {
                    atoms.add(tuple.toString());
                    val2sig.put(tuple.toString(), sig);
                }
                name2vals.put(sigName, atoms);
                sigs.put(sigName, atoms);

                /* sig's field and its val */
                for(Sig.Field field : sig.getFields()){
                    String fieldName = field.label;
                    A4TupleSet tupleSet = sol.eval(field);
                    Set<String> fieldVals = new HashSet<>();
                    for(A4Tuple tuple : tupleSet){
                        fieldVals.add(tuple.toString());
                    }
                    // add to name to field map
                    name2field.put(fieldName, field);
                    name2vals.put(fieldName, fieldVals);
                    fields.put(fieldName, fieldVals);
                }
            }
        }
    }


    /*
    *  Find the most specified name for a tuple value
    *  For example:
    *  if
    *    FSM: FSM0
    *    State: State0, State1
    *    FSM.start: FSM0->State0
    *  then
    *    State0 could be referred by FSM.start in the Alloy model
    *
    * */
    public String[] findMostSpecifiedName(String tuple){
        String[] atoms = tuple.split("->");
        for(int i = 0; i < atoms.length; i++){
            String val = atoms[i];
            Set<String> names = new HashSet<>();
                    /*=
                    name2vals.keySet().stream().filter(key -> name2vals.get(key).size() == 1).filter(
                            key -> {
                                String currentVal = name2vals.get(key).iterator().next();
                                String[] tuples = currentVal.split("->");
                                return tuples[tuples.length - 1].equals(val);
                            }
                    ).collect(Collectors.toSet());
            */
            for( String name : name2vals.keySet() ){
                if( name2vals.get(name).size() == 1){
                    String currentVal = name2vals.get(name).iterator().next();
                    String[] currentAtoms = currentVal.split("->");
                    if( val.equals(currentAtoms[currentAtoms.length - 1])){
                        Sig.Field field = name2field.get(name);
                        names.add(StringUtil.removeThis( field.sig.label )+ "." + field.label);
                    }
                }
            }
            atoms[i] = names.isEmpty() ? ( val2sig.get(val) == null ? val.split("\\$")[0] : StringUtil.removeThis( val2sig.get(val).label ))
                    : names.iterator().next();
        }
        return atoms;
    }

    /*
    * Try to find possible keywords for each atom
    * */
    public Set<String> findPossibleKeywords(String tuple){
        Set<String> keywords = new HashSet<>();
        String[] atoms = tuple.split("->");
        for(int i = 0; i < atoms.length; i++){
            String val = atoms[i];
            for( String name : name2vals.keySet() ){
                if( name2vals.get(name).size() == 1){
                    String currentVal = name2vals.get(name).iterator().next();
                    String[] currentAtoms = currentVal.split("->");
                    if( val.equals(currentAtoms[currentAtoms.length - 1])){
                        Sig.Field field = name2field.get(name);
                        if(field != null)
                        keywords.add(StringUtil.removeThis( field.sig.label )+ "." + field.label);
                    }
                }
            }
        }
        return keywords;
    }

    /*
    * evaluate the value of an expr
    * */
    public Object eval(CompModule world, String expr){
        try {

            return sol.eval(CompUtil.parseOneExpression_fromString(world, expr));
        } catch (Err err) {
            err.printStackTrace();
            return null;
        }
    }

    /*
    * evaluate an instantiated expression
    * */
    public Set<String> evalInstantiated(String str){
        for(ExprVar a:sol.getAllAtoms())   { world.addGlobal(a.label, a); }
        for(ExprVar a:sol.getAllSkolems()) { world.addGlobal(a.label, a); }
        try {
            Expr e = CompUtil.parseOneExpression_fromString(world, str);
            //A4TupleSet res = (A4TupleSet) sol.eval(e);
            Object res = sol.eval(e);
            if( res instanceof A4TupleSet) {
                Set<String> vals = new HashSet<>();
                for (A4Tuple tuple : (A4TupleSet)res) {
                    vals.add(tuple.toString());
                }
                return vals;
            } else {
                Set<String> vals = new HashSet<>();
                vals.add((String)res);
                return vals;
            }
        } catch (Err err) {
           // err.printStackTrace();
        }
        return new HashSet<>();
    }

    // tmpltStr represent an instantiated boolean expr
    public Boolean evalInstantiatedBoolean(String str){
        for(ExprVar a:sol.getAllAtoms())   { world.addGlobal(a.label, a); }
        for(ExprVar a:sol.getAllSkolems()) { world.addGlobal(a.label, a); }
        try {
           // System.out.println(tmpltStr);
                Expr e = CompUtil.parseOneExpression_fromString(world, str);
                //A4TupleSet res = (A4TupleSet) sol.eval(e);
                Object res = sol.eval(e);
            //System.out.println(tmpltStr + " " + res);
            return (Boolean)res;
        } catch (Err err) {
           // if(tmpltStr.contains("#"))
           // System.out.println(tmpltStr);
           // err.printStackTrace();
           // System.exit(0);
        }
        return null;
    }

    public Sig getSigByVal(String val){ return val2sig.get(val); }

    public Set<String> getSigVal(String name){
        return sigs.get(name);
    }

    public Sig getSig(String name) {
        return name2sig.get(name);
    }

    public Set<String> getFieldVal(String name){
        return fields.get(name);
    }

    public Sig.Field getField(String name){
        return name2field.get(name);
    }

    @Override
    public String toString() {
        return sol.toString();
    }
}
