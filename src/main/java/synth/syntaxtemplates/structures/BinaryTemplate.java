package synth.syntaxtemplates.structures;

import edu.mit.csail.sdg.alloy4.Pair;
import parser.ast.Declaration;
import parser.ast.Exprn;
import parser.ast.ExprnBinaryBool;
import parser.ast.ExprnQtBool;
import synth.varcollectors.HoleCollector;

import java.util.List;

// some format like:
//    n.{n1->n2, n2->n3} > n.elm
// Exprn: n1.{}  > n2.{}
public class BinaryTemplate extends Template{
    public ExprnBinaryBool.Op op;

    public BinaryTemplate(Exprn orig, Exprn exprn, ExprnBinaryBool.Op op, List<Declaration> declaration){
        original = orig;
        replacement = exprn;
        this.op = op;
        decls = declaration;
        hasDeclVar = exprn.hasDeclVar;

        HoleCollector hc = new HoleCollector();
        holes.addAll( hc.collect(exprn) );
    }

    public BinaryTemplate(Exprn orig, Exprn exprn, ExprnBinaryBool.Op op, List<Declaration> declaration, List<Pair<ExprnQtBool.Op, List<Declaration>>> pre){
        original = orig;
        replacement = exprn;
        this.op = op;
        decls = declaration;
        pre_decls = pre;
        hasDeclVar = exprn.hasDeclVar;

        HoleCollector hc = new HoleCollector();
        holes.addAll( hc.collect(exprn) );
    }

    public static final ExprnBinaryBool.Op[] booleanSymOps = {ExprnBinaryBool.Op.EQUALS, ExprnBinaryBool.Op.NOT_EQUALS,
                 ExprnBinaryBool.Op.AND,
                ExprnBinaryBool.Op.OR,  ExprnBinaryBool.Op.IFF
        };

    public static final ExprnBinaryBool.Op[] booleanASymOps = {ExprnBinaryBool.Op.IN, ExprnBinaryBool.Op.NOT_IN,
            ExprnBinaryBool.Op.IMPLIES
    };

    public static final ExprnBinaryBool.Op[] intOps = {ExprnBinaryBool.Op.LT, ExprnBinaryBool.Op.LTE,
                ExprnBinaryBool.Op.GT, ExprnBinaryBool.Op.GTE }; //, ExprnBinaryBool.Op.NOT_LT,
                // ExprnBinaryBool.Op.NOT_LTE, ExprnBinaryBool.Op.NOT_GT, ExprnBinaryBool.Op.NOT_GTE};

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        replacement.toTemplateString(this, "test", sb);
        return sb.toString();
    }

}
