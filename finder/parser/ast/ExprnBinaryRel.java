package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprBinary;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

public class ExprnBinaryRel extends ExprnBinary {
    public Op op;

    public ExprnBinaryRel(Node parent, ExprBinary exprBinary) {
        super(parent, exprBinary);
        parseOp(exprBinary.op);
    }

    public ExprnBinaryRel(Exprn left, Exprn right, Op op, Type type){
        super();
        this.left = left;
        this.right = right;
        this.op = op;
        this.type = type;
    }

    public ExprnBinaryRel(Exprn left, Exprn right, boolean hasVar){
        super();
        this.left = left;
        this.right = right;
        this.op = Op.JOIN;
        this.type = left.getType().join(right.getType());
        this.hasDeclVar = hasVar;
    }

    public void parseOp(ExprBinary.Op op) {
        switch (op) {
            case ARROW:
                this.op = Op.ARROW;
                break;
            case ANY_ARROW_SOME:
                this.op = Op.ANY_ARROW_SOME;
                break;
            case ANY_ARROW_ONE:
                this.op = Op.ANY_ARROW_ONE;
                break;
            case ANY_ARROW_LONE:
                this.op = Op.ANY_ARROW_LONE;
                break;
            case SOME_ARROW_ANY:
                this.op = Op.SOME_ARROW_ANY;
                break;
            case SOME_ARROW_SOME:
                this.op = Op.SOME_ARROW_SOME;
                break;
            case SOME_ARROW_ONE:
                this.op = Op.SOME_ARROW_ONE;
                break;
            case SOME_ARROW_LONE:
                this.op = Op.SOME_ARROW_LONE;
                break;
            case ONE_ARROW_ANY:
                this.op = Op.ONE_ARROW_ANY;
                break;
            case ONE_ARROW_SOME:
                this.op = Op.ONE_ARROW_SOME;
                break;
            case ONE_ARROW_ONE:
                this.op = Op.ONE_ARROW_ONE;
                break;
            case ONE_ARROW_LONE:
                this.op = Op.ONE_ARROW_LONE;
                break;
            case LONE_ARROW_ANY:
                this.op = Op.LONE_ARROW_ANY;
                break;
            case LONE_ARROW_SOME:
                this.op = Op.LONE_ARROW_SOME;
                break;
            case LONE_ARROW_ONE:
                this.op = Op.LONE_ARROW_ONE;
                break;
            case LONE_ARROW_LONE:
                this.op = Op.LONE_ARROW_LONE;
                break;
            case ISSEQ_ARROW_LONE:
                this.op = Op.ISSEQ_ARROW_LONE;
                break;
            case JOIN:
                this.op = Op.JOIN;
                break;
            case DOMAIN:
                this.op = Op.DOMAIN;
                break;
            case RANGE:
                this.op = Op.RANGE;
                break;
            case INTERSECT:
                this.op = Op.INTERSECT;
                break;
            case PLUSPLUS:
                this.op = Op.PLUSPLUS;
                break;
            case PLUS:
                this.op = Op.PLUS;
                break;
            case IPLUS:
                this.op = Op.IPLUS;
                break;
            case MINUS:
                this.op = Op.MINUS;
                break;
            case IMINUS:
                this.op = Op.IMINUS;
                break;
            case MUL:
                this.op = Op.MUL;
                break;
            case DIV:
                this.op = Op.DIV;
                break;
            case REM:
                this.op = Op.REM;
                break;
            case SHL:
                this.op = Op.SHL;
                break;
            case SHA:
                this.op = Op.SHA;
                break;
            case SHR:
                this.op = Op.SHR;
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append("(");
        left.toString(sb);
        sb.append(getOpStr());
        right.toString(sb);
        sb.append(")");
    }

    @Override
    public void toGenericString(StringBuilder sb){
        left.toGenericString(sb);
        sb.append(op);
        right.toGenericString(sb);
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            sb.append("(");
            left.toTemplateString(t, value, sb);
            sb.append(op.toString());
            right.toTemplateString(t, value, sb);
            sb.append(")");
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        if(this == t.replacement){
            sb.append(value);
        }else{
            sb.append("(");
            left.toQtTemplateString(t, value, sb);
            sb.append(op.toString());
            right.toQtTemplateString(t, value, sb);
            sb.append(")");
        }
    }
//
//    public Set<String> getInstantiatedString(Map<String, Set<String>> sig2vals){
//        Set<String> res = new HashSet<>();
//        Set<String> lres = left.getInstantiatedString(sig2vals);
//        Set<String> rres = right.getInstantiatedString(sig2vals);
//        for(String l : lres)
//            for(String r : rres){
//                res.add("("+l+op.toString()+r+")");
//            }
//        return res;
//    }

    @Override
    public String getInstantiatedString(Map<String, String> sig2vals){
        String l = left.getInstantiatedString(sig2vals);
        String r  = right.getInstantiatedString(sig2vals);
        String opstr = "";
        switch (op) {
            case ARROW:
            case ANY_ARROW_SOME:
            case ANY_ARROW_ONE:
            case ANY_ARROW_LONE:
            case SOME_ARROW_ANY:
            case SOME_ARROW_SOME:
            case SOME_ARROW_ONE:
            case SOME_ARROW_LONE:
            case ONE_ARROW_ANY:
            case ONE_ARROW_SOME:
            case ONE_ARROW_ONE:
            case ONE_ARROW_LONE:
            case LONE_ARROW_ANY:
            case LONE_ARROW_SOME:
            case LONE_ARROW_ONE:
            case LONE_ARROW_LONE:
            case ISSEQ_ARROW_LONE:
                opstr = "->";
                break;
            default:
                opstr = op.label;
        }
        return "("+l+opstr+r+")";
    }

    public Op getOp() {
        return op;
    }

    public String getOpStr(){
        String opstr = "";
        switch (op) {
            case ARROW:
            case ANY_ARROW_SOME:
            case ANY_ARROW_ONE:
            case ANY_ARROW_LONE:
            case SOME_ARROW_ANY:
            case SOME_ARROW_SOME:
            case SOME_ARROW_ONE:
            case SOME_ARROW_LONE:
            case ONE_ARROW_ANY:
            case ONE_ARROW_SOME:
            case ONE_ARROW_ONE:
            case ONE_ARROW_LONE:
            case LONE_ARROW_ANY:
            case LONE_ARROW_SOME:
            case LONE_ARROW_ONE:
            case LONE_ARROW_LONE:
            case ISSEQ_ARROW_LONE:
                opstr = "->";
                break;
            default:
                opstr = op.label;
        }
        return " " + opstr + " ";
    }

    public void setOp(Op op) {
        this.op = op;
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
         * -&gt;
         */
        ARROW("->"),
        /**
         * -&gt;some
         */
        ANY_ARROW_SOME("->some"),
        /**
         * -&gt;one
         */
        ANY_ARROW_ONE("->one"),
        /**
         * -&gt;lone
         */
        ANY_ARROW_LONE("->lone"),
        /**
         * some-&gt;
         */
        SOME_ARROW_ANY("some->"),
        /**
         * some-&gt;some
         */
        SOME_ARROW_SOME("some->some"),
        /**
         * some-&gt;one
         */
        SOME_ARROW_ONE("some->one"),
        /**
         * some-&gt;lone
         */
        SOME_ARROW_LONE("some->lone"),
        /**
         * one-&gt;
         */
        ONE_ARROW_ANY("one->"),
        /**
         * one-&gt;some
         */
        ONE_ARROW_SOME("one->some"),
        /**
         * one-&gt;one
         */
        ONE_ARROW_ONE("one->one"),
        /**
         * one-&gt;lone
         */
        ONE_ARROW_LONE("one->lone"),
        /**
         * lone-&gt;
         */
        LONE_ARROW_ANY("lone->"),
        /**
         * lone-&gt;some
         */
        LONE_ARROW_SOME("lone->some"),
        /**
         * lone-&gt;one
         */
        LONE_ARROW_ONE("lone->one"),
        /**
         * lone-&gt;lone
         */
        LONE_ARROW_LONE("lone->lone"),
        /**
         * isSeq-&gt;lone
         */
        ISSEQ_ARROW_LONE("seq"),
        /**
         * .
         */
        JOIN("."),
        /**
         * &lt;:
         */
        DOMAIN("<:"),
        /**
         * :&gt;
         */
        RANGE(":>"),
        /**
         * &amp;
         */
        INTERSECT("&"),
        /**
         * ++
         */
        PLUSPLUS("++"),
        /**
         * set union
         */
        PLUS("+"),
        /**
         * int +
         */
        IPLUS("@+"),
        /**
         * set diff
         */
        MINUS("-"),
        /**
         * int -
         */
        IMINUS("@-"),
        /**
         * multiply
         */
        MUL("*"),
        /**
         * divide
         */
        DIV("/"),
        /**
         * remainder
         */
        REM("%"),
        /**
         * &lt;&lt;
         */
        SHL("<<"),
        /**
         * &gt;&gt;
         */
        SHA(">>"),
        /**
         * &gt;&gt;&gt;
         */
        SHR(">>>");

        String label;

        private Op(String label) {
            this.label = label;
        }

        @Override
        public String toString() {
            return " " + this.label + " ";
        }
    }
}
