package mutation.operators;

import mutation.ExprMutator;
import parser.ast.ExprnQtBool;
import parser.ast.ExprnQtRel;

//Quantifier operator replacement
public class QOR extends MutOp{
    public static void mutate(ExprMutator mutator, ExprnQtBool expr){
        ExprnQtBool.Op original = expr.op;
        for( ExprnQtBool.Op op : ExprnQtBool.Op.values()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;
    }

    public static void mutate(ExprMutator mutator, ExprnQtRel expr){
        ExprnQtRel.Op original = expr.op;
        for( ExprnQtRel.Op op : ExprnQtRel.Op.values()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;
    }


}
