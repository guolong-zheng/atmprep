package synth.syntaxtemplates.structures;

import parser.ast.Declaration;
import parser.ast.Exprn;
import parser.ast.ExprnUnaryBool;
import synth.syntaxtemplates.template.hole.Hole;

import java.util.List;

// some format like:
//    some n.{n1->n2, n2->n3}
//    some {n1->n2, n2->n3}.n
//    some n
//    some {n1->n2, n2->n3}
public class UnaryTemplate extends Template{
    ExprnUnaryBool.Op op;

    public UnaryTemplate(Exprn orig, Exprn sub, ExprnUnaryBool.Op op, List<Declaration> declarations, List<Hole> hs, boolean hasVar){
        super(hasVar);
        holes.addAll(hs);
        this.original = orig;
        replacement = sub;
        this.op = op;
        decls = declarations;
    }


    public static final ExprnUnaryBool.Op[] ops = {ExprnUnaryBool.Op.SOME, ExprnUnaryBool.Op.ONE, ExprnUnaryBool.Op.NO};
            //ExprnUnaryBool.Op.LONE, ExprnUnaryBool.Op.NOT};

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        replacement.toTemplateString(this, "test", sb);
        return sb.toString();
    }
}
