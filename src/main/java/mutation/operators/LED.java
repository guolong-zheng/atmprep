package mutation.operators;

import mutation.ExprMutator;
import parser.ast.Exprn;
import parser.ast.ExprnListBool;
import parser.ast.ExprnListRel;

import java.util.ArrayList;
import java.util.List;

// list expression deletion
public class LED extends MutOp{
    public static void mutate(ExprMutator mutator, ExprnListBool expr){
        // delete one sub each time
        List<Exprn> subs = new ArrayList<>(expr.getArgs());
        List<Exprn> orig = new ArrayList<>(expr.getArgs());

        for(Exprn sub : orig){
            subs.remove(sub);
            expr.args = subs;
            next(mutator, expr);
            subs.add(sub);
        }

        expr.args = orig;
    }

    public static void mutate(ExprMutator mutator, ExprnListRel expr){
        List<Exprn> subs = new ArrayList<>(expr.getArgs());
        List<Exprn> orig = new ArrayList<>(expr.getArgs());

        for(Exprn sub : orig){
            subs.remove(sub);
            expr.args = subs;
            next(mutator, expr);
            subs.add(sub);
        }

        expr.args = orig;
    }
}
