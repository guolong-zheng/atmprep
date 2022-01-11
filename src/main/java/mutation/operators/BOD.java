package mutation.operators;

import mutation.ExprMutator;
import parser.ast.*;

// Binary operand deletion
public class BOD extends MutOp {
    public static void mutate(ExprMutator mutator, ExprnBinary expr) {
        Exprn left = expr.left;
        Exprn right = expr.right;
        Node parent = expr.getParent();

        if (parent instanceof Fact) {
            ((Fact) parent).expr = left;
            left.parent = parent;
            next(mutator, left);

            ((Fact) parent).expr = right;
            right.parent = parent;
            next(mutator, right);

            ((Fact) parent).expr = expr;
            expr.parent = parent;
            left.parent = expr;
            right.parent = expr;
        }
        else if (parent instanceof ExprnQt) {
            ((ExprnQt) parent).setSub(left);
            left.parent = parent;
            next(mutator, left);

            ((ExprnQt) parent).setSub(right);
            right.parent = parent;
            next(mutator, right);

            //reset
            ((ExprnQt) parent).setSub(expr);
            left.parent = expr;
            right.parent = expr;
        }
        else if (parent instanceof ExprnUnary) {
            ((ExprnUnary) parent).setSub(left);
            left.parent = parent;
            next(mutator, left);

            ((ExprnUnary) parent).setSub(right);
            right.parent = parent;
            next(mutator, right);
            //reset
            ((ExprnUnary) parent).setSub(expr);
            left.parent = expr;
            right.parent = expr;
        }
        else if (parent instanceof ExprnBinary) {
            if (((ExprnBinary) parent).left == expr) {
                ((ExprnBinary) parent).left = left;
                left.parent = parent;
                next(mutator, left);

                //reset
                ((ExprnBinary) parent).setLeft(expr);
                left.parent = expr;
            } else {
                ((ExprnBinary) parent).right = right;
                right.parent = parent;
                next(mutator, right);

                // reset
                ((ExprnBinary) parent).setRight(expr);
                right.parent = expr;
            }
        }else{
            return;
        }

    }
}
