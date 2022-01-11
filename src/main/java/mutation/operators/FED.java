package mutation.operators;

import mutation.ExprMutator;
import parser.ast.Exprn;
import parser.ast.ExprnBinaryBool;
import parser.ast.Fact;
import util.SynthUtil;

// Fact expression deletion
public class FED extends MutOp {
    public static void mutate(ExprMutator mutator, Fact fact){
        Exprn original = fact.expr;
        fact.expr = new ExprnBinaryBool(fact);

        if(SynthUtil.check(mutator.opt)){
            mutator.rep.fixed(mutator.opt);
            return;
        }else {
            fact.expr = original;
        }
//        if( SynthUtil.check(opt.model.toString(), opt.cmds) ){
//            rep.repaired = true;
//            rep.model = opt.model.toString();
//        }
//        fact.expr = original;
    }
}