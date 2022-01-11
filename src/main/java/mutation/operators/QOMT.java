package mutation.operators;

import mutation.ExprMutator;
import parser.ast.*;

import java.util.List;

// operand move out
public class QOMT extends MutOp {
    public static void mutate(ExprMutator mutator, ExprnQtBool expr){
        QtInfoCollector qc = new QtInfoCollector();
        if(!qc.visited.contains(expr)) {
            qc.visit(expr, null);
            if(!qc.subs.isEmpty()){
                ExprnBinaryBool newExpr = new ExprnBinaryBool(expr.getParent());
                newExpr.left = expr;
                newExpr.right = qc.subs.iterator().next();
                newExpr.op = ExprnBinaryBool.Op.AND;

                Node parent = expr.getParent();
                if( parent instanceof Fact){
                    ((Fact) parent).expr = newExpr;
                }
                if( parent instanceof ExprnListBool){
                    List<Exprn> subs = ((ExprnListBool) parent).getArgs();
                    subs.remove(expr);
                    subs.add(newExpr);
                }
            }
        }
    }
}
