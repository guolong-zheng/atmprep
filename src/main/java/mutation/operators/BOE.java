package mutation.operators;

import mutation.ExprMutator;
import parser.ast.Exprn;
import parser.ast.ExprnBinary;

public class BOE extends MutOp {
    public static void mutate(ExprMutator mutator, ExprnBinary expr) {
        Exprn left = expr.left;
        Exprn right = expr.right;
        expr.left = right;
        expr.right = left;
        next(mutator, expr);
        expr.left = left;
        expr.right = right;
    }
}
