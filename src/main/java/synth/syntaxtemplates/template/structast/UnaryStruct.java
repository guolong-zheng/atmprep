package synth.syntaxtemplates.template.structast;

import parser.ast.Exprn;
import parser.ast.ExprnUnaryBool;

public class UnaryStruct extends Structure {
    ExprnUnaryBool.Op op;
    Exprn sub;

    public UnaryStruct(ExprnUnaryBool.Op op, Exprn sub){
        this.op = op;
        this.sub = sub;
    }

    public static final ExprnUnaryBool.Op[] ops = {ExprnUnaryBool.Op.LONE, ExprnUnaryBool.Op.SOME,
            ExprnUnaryBool.Op.ONE, ExprnUnaryBool.Op.NO};
}
