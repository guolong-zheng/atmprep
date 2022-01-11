package synth.syntaxtemplates.template.structast;

import parser.ast.Exprn;
import parser.ast.ExprnBinaryBool;

import java.util.List;

public class BinaryStruct extends Structure {
    ExprnBinaryBool.Op op;
    Exprn left;
    Exprn right;

    List<Exprn> holes;

    public BinaryStruct(ExprnBinaryBool.Op op, Exprn left, Exprn right){
        super();
        this.op = op;
        this.left = left;
        this.right = right;

        toInstHoles.add(left);
        toInstHoles.add(right);
    }

    public static final ExprnBinaryBool.Op[] ops = {ExprnBinaryBool.Op.EQUALS, ExprnBinaryBool.Op.NOT_EQUALS,
            ExprnBinaryBool.Op.AND, ExprnBinaryBool.Op.OR,  ExprnBinaryBool.Op.IFF, ExprnBinaryBool.Op.IN, ExprnBinaryBool.Op.NOT_IN,
            ExprnBinaryBool.Op.IMPLIES, ExprnBinaryBool.Op.LT, ExprnBinaryBool.Op.LTE,
            ExprnBinaryBool.Op.GT, ExprnBinaryBool.Op.GTE};


    public static final ExprnBinaryBool.Op[] booleanSymOps = {ExprnBinaryBool.Op.EQUALS, ExprnBinaryBool.Op.NOT_EQUALS,
            ExprnBinaryBool.Op.AND,
            ExprnBinaryBool.Op.OR,  ExprnBinaryBool.Op.IFF
    };

    public static final ExprnBinaryBool.Op[] booleanASymOps = {ExprnBinaryBool.Op.IN, ExprnBinaryBool.Op.NOT_IN,
            ExprnBinaryBool.Op.IMPLIES
    };

    public static final ExprnBinaryBool.Op[] intOps = {ExprnBinaryBool.Op.LT, ExprnBinaryBool.Op.LTE,
            ExprnBinaryBool.Op.GT, ExprnBinaryBool.Op.GTE
    };
}
