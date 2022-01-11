package mutation.operators;

import mutation.ExprMutator;
import parser.ast.ExprnUnaryBool;
import parser.ast.ExprnUnaryRel;

// Unary operator replacement, including deletion(change to NOOP)
public class UOM {

    public static void mutate(ExprMutator mutator, ExprnUnaryRel expr){
        ExprnUnaryRel.Op original = expr.op;

        for( ExprnUnaryRel.Op op : ExprnUnaryRel.Op.values()){
            if(op != original){
                expr.op = op;
                if(mutator.hasNext()) {
                    mutator.depth++;
                    mutator.forward(expr);
                    expr.getSub().accept(mutator);
                    mutator.depth--;
                }
            }
        }
        expr.op = original;
    }

    public static void mutate(ExprMutator mutator, ExprnUnaryBool expr){
        ExprnUnaryBool.Op original = expr.op;
        if(original == ExprnUnaryBool.Op.NOT){
            expr.op = ExprnUnaryBool.Op.NOOP;
            if(mutator.hasNext()) {
                mutator.depth++;
                mutator.forward(expr);
                expr.getSub().accept(mutator);
                mutator.depth--;
            }
            expr.op = original;
            return;
        }
        for( ExprnUnaryBool.Op op : ExprnUnaryBool.Op.values()){
            if( op != original){
                expr.op = op;
                if(mutator.hasNext()) {
                    mutator.depth++;
                    mutator.forward(expr);
                    expr.getSub().accept(mutator);
                    mutator.depth--;
                }
            }
        }
        expr.op = original;
    }
}
