package synth;

import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.ast.ExprVar;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import parser.ast.Exprn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SolutionPair {
    public ASolution cex;
    public ASolution sat;
    public Map<Type, List<Exprn>> type2diffexprns;
    Map<Type, List<String>> type2diffcexvals;
    Map<Type, List<String>> type2diffsatvals;

    public SolutionPair(ASolution cex, ASolution sat){
        this.cex = cex;
        this.sat = sat;
    }

    public void findDiffExprn(){
        type2diffexprns = new HashMap<>();
        type2diffcexvals = new HashMap<>();
        type2diffsatvals = new HashMap<>();

        for(Type type : ASolution.type2exprns.keySet()){
            List<Exprn> exprns = ASolution.type2exprns.get(type);

            List<Exprn> diffexprns = new ArrayList<>();
            List<String> diffcexvals = new ArrayList<>();
            List<String> diffsatvals = new ArrayList<>();

            for(Exprn exprn : exprns){
                String cexval = cex.evalExprn(exprn);
                String satval = sat.evalExprn(exprn);
                if(!cexval.equals(satval)){
                    diffexprns.add(exprn);
                    diffcexvals.add(cexval);
                    diffsatvals.add(satval);
                }
            }
            if(diffexprns.size() > 0){
                type2diffexprns.put(type, diffexprns);
                type2diffcexvals.put(type, diffcexvals);
                type2diffsatvals.put(type, diffsatvals);
            }
        }

    }

    public boolean is_diff(String str){
        try {
            for (ExprVar a : cex.getAlloySol().getAllAtoms()) {
                cex.world.addGlobal(a.label, a);
            }
            for (ExprVar a : cex.getAlloySol().getAllSkolems()) {
                cex.world.addGlobal(a.label, a);
            }
            Expr e1 = CompUtil.parseOneExpression_fromString(cex.world, str);

            for (ExprVar a : sat.getAlloySol().getAllAtoms()) {
                sat.world.addGlobal(a.label, a);
            }
            for (ExprVar a : sat.getAlloySol().getAllSkolems()) {
                sat.world.addGlobal(a.label, a);
            }
            Expr e2 = CompUtil.parseOneExpression_fromString(sat.world, str);
            return cex.alloySol.eval(e1) == sat.alloySol.eval(e2);
        } catch (Err err) {
            //err.printStackTrace();
        }
        return false;
    }
}
