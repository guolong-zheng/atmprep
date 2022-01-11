package mutation.operators;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import mutation.ExprMutator;
import parser.ast.ExprnBinary;
import parser.ast.ExprnField;
import parser.ast.ExprnUnaryRel;
import parser.ast.Node;

import java.util.Arrays;

//Unary operator(*, ^, ~) insertion
public class UOI extends MutOp{
    public static void mutate(ExprMutator mutator,
                              ExprnUnaryRel expr){
        Type type = expr.getType();
        // (*, ^, ~) only apply to binary relation
        if(type.arity() == 2){
            Node parent = expr.parent;
                ExprnUnaryRel.Op original = ((ExprnUnaryRel) expr).op;
                for(ExprnUnaryRel.Op op : Arrays.asList(ExprnUnaryRel.Op.TRANSPOSE, ExprnUnaryRel.Op.RCLOSURE,
                    ExprnUnaryRel.Op.CLOSURE)){
                    if(op == original)
                        continue;
                    ExprnUnaryRel newExpr = new ExprnUnaryRel(expr, op, ((ExprnUnaryRel) expr).getSub(), type);
                    ((ExprnUnaryRel) expr).setSub(newExpr);

                    next(mutator, expr);

                    // reset
                    ((ExprnUnaryRel) expr).parent = parent;
                    ((ExprnUnaryRel) expr).setSub(newExpr.getSub());
                }
        }

    }

    public static void mutate(ExprMutator mutator,
                              ExprnField expr){
        Type type = expr.getType();
        // (*, ^, ~) only apply to binary relation
        if(type.arity() == 2){
            Node parent = expr.parent;

            for(ExprnUnaryRel.Op op : Arrays.asList(ExprnUnaryRel.Op.TRANSPOSE, ExprnUnaryRel.Op.RCLOSURE,
                    ExprnUnaryRel.Op.CLOSURE)){
                ExprnUnaryRel newExpr = new ExprnUnaryRel(expr, op, expr, type);

                if(parent instanceof ExprnBinary){
                     if(((ExprnBinary) parent).getLeft() == expr){
                         ((ExprnBinary) parent).left = newExpr;
                         next(mutator, (ExprnBinary)parent);
                         //reset
                         ((ExprnBinary) parent).left = expr;
                     }else
                    if(((ExprnBinary) parent).getRight() == expr){
                        ((ExprnBinary) parent).right = newExpr;
                        next(mutator, (ExprnBinary)parent);
                        //reset
                        ((ExprnBinary) parent).right = expr;
                    }
                }
//                // reset
//                ((ExprnUnaryRel) expr).parent = parent;
//                ((ExprnUnaryRel) expr).setSub(newExpr.getSub());
            }
        }

    }

}
