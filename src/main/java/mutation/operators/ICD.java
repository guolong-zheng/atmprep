package mutation.operators;

import mutation.ExprMutator;
import parser.ast.Exprn;
import parser.ast.ExprnBinaryBool;
import util.SynthUtil;

// Implication condition deletion
public class ICD extends MutOp{
    public static void mutate(ExprMutator mutator, ExprnBinaryBool expr){
        if( expr.op == ExprnBinaryBool.Op.IMPLIES ) {
            Exprn oldleft = expr.getLeft();
            expr.left = new ExprnBinaryBool(oldleft.getParent());

            if (SynthUtil.check(mutator.opt)) {
                mutator.rep.fixed(mutator.opt);
                return;
            } else {
                expr.left = oldleft;
            }
        }
    }
}
