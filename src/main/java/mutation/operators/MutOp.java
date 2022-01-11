package mutation.operators;

import mutation.ExprMutator;
import parser.ast.Exprn;

public class MutOp {
    static void next(ExprMutator mutator, Exprn exprn) {
        if (mutator.hasNext()) {
            mutator.depth++;
            mutator.forward(exprn);
            exprn.accept(mutator);
            mutator.depth--;
        }
    }
}
