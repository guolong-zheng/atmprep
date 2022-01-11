package mutation.operators;

import mutation.ExprMutator;
import parser.ast.ExprnListBool;
import parser.ast.ExprnListRel;

// list operator modification
public class LOM extends MutOp{
    public static void mutate(ExprMutator mutator,  ExprnListBool expr){
        ExprnListBool.Op original = expr.op;
        for( ExprnListBool.Op op : ExprnListBool.Op.values()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;
    }

    public static void mutate(ExprMutator mutator, ExprnListRel expr){
        ExprnListRel.Op original = expr.op;
        for( ExprnListRel.Op op : ExprnListRel.Op.values()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;
    }

}
