package mutation.operators;

import mutation.ExprMutator;
import parser.ast.*;
import util.SynthUtil;

import java.util.Arrays;
import java.util.List;

// Binary operator modification
public class BOM extends MutOp {
    public static void mutate(ExprMutator mutator, ExprnBinaryBool expr){
        ExprnBinaryBool.Op original = expr.op;
        for( ExprnBinaryBool.Op op : ExprnBinaryBool.Op.values()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;
    }

    public static void mutate(ExprMutator mutator, ExprnBinaryRel expr){
        ExprnBinaryRel.Op original = expr.op;
        for( ExprnBinaryRel.Op op : SynthUtil.getBinaryRelOpValues()){
            if(op != original){
                expr.op = op;
                next(mutator, expr);
            }
        }
        expr.op = original;

        if (isArithmetic(expr.op)) {
            Exprn left = expr.getLeft();
            Exprn right = expr.getRight();
            if (left.getType().is_int() && right.getType().is_int()) {
                List<Exprn> args = Arrays.asList(new Exprn[]{left, right});
                ExprnCallRel newExpr = new ExprnCallRel(expr.getParent(), expr.op.toString(), args);
                Node parent = expr.getParent();
                if (parent instanceof ExprnBinary) {
                    if (((ExprnBinary) parent).getLeft() == expr) {
                        ((ExprnBinary) parent).left = newExpr;
                        next(mutator, ((ExprnBinary) parent).getRight());
                    }
                    if (((ExprnBinary) parent).getRight() == expr) {
                        ((ExprnBinary) parent).right = newExpr;
                        next(mutator, ((ExprnBinary) parent).getLeft());
                    }
                }
            }
        }
    }

    public static boolean isArithmetic(ExprnBinaryRel.Op op){
        return (op == ExprnBinaryRel.Op.PLUS ||
                op == ExprnBinaryRel.Op.MINUS ||
                op == ExprnBinaryRel.Op.MUL);
    }
}
