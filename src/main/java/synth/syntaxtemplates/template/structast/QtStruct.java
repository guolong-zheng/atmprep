package synth.syntaxtemplates.template.structast;

import parser.ast.Exprn;
import parser.ast.ExprnQtBool;

public class QtStruct extends Structure{
    ExprnQtBool.Op op;
    DeclStruct var;
    Exprn sub;

    public QtStruct(ExprnQtBool.Op op, DeclStruct var, Exprn sub){
        this.op = op;
        this.var = var;
        this.sub = sub;
    }

    public static final ExprnQtBool.Op[] ops = {ExprnQtBool.Op.ONE, ExprnQtBool.Op.LONE, ExprnQtBool.Op.SOME, ExprnQtBool.Op.ALL, ExprnQtBool.Op.NO };
}
