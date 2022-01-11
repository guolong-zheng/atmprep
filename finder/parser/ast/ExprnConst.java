package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprConstant;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

import static parser.ast.ExprnConst.Op.NUMBER;

public class ExprnConst extends Exprn {
    Op op;

    String string;

    int num;

    public ExprnConst(Node parent, ExprConstant expr) {
        super(parent, expr);
        switch (expr.op) {
            case TRUE:
                this.op = Op.TRUE;
                break;
            case FALSE:
                this.op = Op.FALSE;
                break;
            case IDEN:
                this.op = Op.IDEN;
                break;
            case MIN:
                this.op = Op.MIN;
                break;
            case MAX:
                this.op = Op.MAX;
                break;
            case NEXT:
                this.op = Op.NEXT;
                break;
            case EMPTYNESS:
                this.op = Op.EMPTYNESS;
                break;
            case STRING:
                this.op = Op.STRING;
                this.string = expr.string;
                break;
            case NUMBER:
                this.op = NUMBER;
                this.num = expr.num;
                break;
        }
    }

    // construct integer for purpose of mutation
    public ExprnConst(Node parent){
        super(parent);
        op = NUMBER;
        num = 1;
    }

    public ExprnConst(){
        op = Op.STRING;
    }

    public ExprnConst(int num){
        this.op = NUMBER;
        this.num = num;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        switch(op){
            case STRING:
                sb.append(this.string);
                break;
            case NUMBER:
                sb.append(this.num);
                break;
            default:
                sb.append(this.op.toString());
                break;
        }
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            toString(sb);
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        if(this == t.replacement) {
            sb.append(value);
        }else{
            toString(sb);
        }
    }

//    @Override
//    public Set<String> getInstantiatedString(Map<String, Set<String>> name2val) {
//        Set<String> res = new HashSet<>();
//        res.add(string);
//        return res;
//    }


    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        switch(op){
            case STRING:
                return this.string;
            case NUMBER:
                return String.valueOf( this.num );
            default:
                return this.op.toString();
        }
    }

    public Op getOp() {
        return op;
    }

    public void setOp(Op op) {
        this.op = op;
    }

    public String getString() {
        return string;
    }

    public void setString(String string) {
        this.string = string;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    public enum Op {
        /**
         * true
         */
        TRUE("true"),
        /**
         * false
         */
        FALSE("false"),
        /**
         * the builtin "iden" relation
         */
        IDEN("iden"),
        /**
         * the minimum integer constant
         */
        MIN("min"),
        /**
         * the maximum integer constant
         */
        MAX("max"),
        /**
         * the "next" relation between integers
         */
        NEXT("next"),
        /**
         * the emptyness relation whose type is UNIV
         */
        EMPTYNESS("none"),
        /**
         * a String constant
         */
        STRING("STRING"),
        /**
         * an integer constant
         */
        NUMBER("NUMBER");

        /**
         * The constructor.
         */
        private Op(String label) {
            this.label = label;
        }

        /**
         * The human readable label for this operator.
         */
        private final String label;

        @Override
        public final String toString() {
            return label;
        }
    }
}
