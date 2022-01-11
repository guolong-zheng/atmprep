package mutation.operators;

import mutation.ExprMutator;
import parser.ast.ExprnQtBool;
import parser.ast.Predicate;

// Quantifier declaration deletion
public class QDD extends MutOp{
    public static void mutate(ExprMutator mutator, ExprnQtBool expr){
        if(expr.getParent() instanceof Predicate){
            Predicate p = (Predicate)expr.getParent();
            p.setBody(expr.getSub());
            next(mutator, expr);
            p.setBody(expr);
        }
    }
}
