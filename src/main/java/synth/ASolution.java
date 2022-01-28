package synth;

import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import parser.ast.Exprn;

import java.util.*;

public class ASolution {
    public A4Solution alloySol;
    public boolean isCheck;
    public CompModule world;
    public static Map<Type, List<Exprn>>  type2exprns;
    public Map<Type, Set<String>>  type2vals;
    public Map<String, List<Exprn>> val2exprs;

    //Set<Exprn> checkedExpns;
    Map<Exprn, String> exprn2val;
    public Command cmd;

    public ASolution(A4Solution sol, CompModule world, boolean check, Command cm){
        alloySol = sol;
        this.world = world;
        type2vals = new HashMap<>();
        val2exprs = new HashMap<>();
        exprn2val = new HashMap<>();
        isCheck = check;
        cmd = cm;
    }

    public void evalAllExprns(){
        if(alloySol.satisfiable()){
            for(Type type : type2exprns.keySet()){
                List<Exprn> exprns = type2exprns.get(type);
                for(Exprn exprn : exprns){
                    try {
                        String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, exprn.toString())).toString();

                        List<Exprn> exprs = val2exprs.getOrDefault(res, new ArrayList<>());
                        exprs.add(exprn);
                        val2exprs.put(res, exprs);

                        Set<String> strs = type2vals.getOrDefault(type, new HashSet<>());
                        strs.add(res);
                        type2vals.put(type, strs);
                    } catch (Err err) {
                        err.printStackTrace();
                    }
                }
            }

            for(List<Exprn> values : val2exprs.values()){
                values.sort(new Comparator<Exprn>() {
                    @Override
                    public int compare(Exprn o1, Exprn o2) {
                        return o1.toString().length() - o2.toString().length();
                    }
                });
            }
        }
    }

    Map<String, List<Exprn>> str2exprns;

    public Set<String> evalExprns(Set<Exprn> exprns){
        val2exprs = new HashMap<>();
        Set<String> evalvals = new HashSet<>();
        for (Exprn n : exprns) {
            try {
                String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, n.toString())).toString();
                evalvals.add(res);

                List<Exprn> exprnset = val2exprs.getOrDefault(res, new ArrayList<>());
                exprnset.add(n);
                val2exprs.put(res, exprnset);
            } catch (Err err) {
                //System.out.println(n.toString());
                err.printStackTrace();
                System.exit(0);
            }
        }
        return evalvals;
    }

    public List<Exprn> getExprnSetByStr(String val){
        return str2exprns.get(val);
    }

    public void evalExprnsOfType(Type type){
        if (alloySol.satisfiable()) {
            List<Exprn> exprns = ASolution.type2exprns.get(type);
            for (Exprn n : exprns) {
                try {
                    String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, n.toString())).toString();
                    List<Exprn> exprs = val2exprs.getOrDefault(res, new ArrayList<>());
                    exprs.add(n);
                    val2exprs.put(res, exprs);

                    Set<String> strs = type2vals.getOrDefault(type, new HashSet<>());
                    strs.add(res);
                    type2vals.put(type, strs);
                } catch (Err err) {
                    //System.out.println(n.toString());
                    err.printStackTrace();
                    System.exit(0);
                }
            }

            for(List<Exprn> values : val2exprs.values()){
                values.sort(new Comparator<Exprn>() {
                    @Override
                    public int compare(Exprn o1, Exprn o2) {
                        return o1.toString().length() - o2.toString().length();
                    }
                });
            }
        }
    }

    public Set<String> evalExprns(List<Exprn> exprns){
        Set<String> vals = new HashSet<>();
        for (Exprn n : exprns) {
            if(exprn2val.keySet().contains(n)) {
                vals.add(exprn2val.get(n));
                continue;
            }
            try {
                String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, n.toString())).toString();
                vals.add(res);
                exprn2val.put(n, res);

                List<Exprn> exprs = val2exprs.getOrDefault(res, new ArrayList<>());
                exprs.add(n);
                val2exprs.put(res, exprs);

                Set<String> strs = type2vals.getOrDefault(n.getType(), new HashSet<>());
                strs.add(res);
                type2vals.put(n.getType(), strs);
            } catch (Err err) {
                err.printStackTrace();
            }
        }
        return vals;
    }

    public Map<String,List<Exprn>> evalExprnsTmp(List<Exprn> exprns){
        Set<String> vals = new HashSet<>();
        Map<String,List<Exprn>> val2exprns = new HashMap<>();
        for (Exprn n : exprns) {
            try {
                String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, n.toString())).toString();
                vals.add(res);

                List<Exprn> exprs = val2exprns.getOrDefault(res, new ArrayList<>());
                exprs.add(n);
                val2exprns.put(res, exprs);
            } catch (Err err) {
                err.printStackTrace();
            }
        }
        return val2exprns;
    }

    public String evalExprn(Exprn expr){
        try{
                String res = alloySol.eval(CompUtil.parseOneExpression_fromString(world, expr.toString())).toString();
                return res;
            } catch (Err err) {
                err.printStackTrace();
            return "";
            }
    }

    public void getExprnByType(Type type){
    }

    public List<Exprn> getExprnByStr(String val){
        return val2exprs.get(val);
    }

    public void getAllVals(){
    }

    public A4Solution getAlloySol(){
        return alloySol;
    }
}
