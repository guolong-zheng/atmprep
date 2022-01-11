package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprBinary;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

public class ExprnBinaryBool extends ExprnBinary {
    public Op op;

    public ExprnBinaryBool(Node parent, ExprBinary exprBinary) {
        super(parent, exprBinary);
        parseOp(exprBinary.op);
    }

    // Construct true expression for mutation
    public ExprnBinaryBool(Node parent){
        super(parent);
        op = Op.EQUALS;
    }

    public ExprnBinaryBool(Exprn left, Exprn right, Op op){
        super();
        this.op = op;
        this.left = left;
        this.right = right;
        this.type = Type.FORMULA;
        this.hasDeclVar = left.hasDeclVar || right.hasDeclVar;
    }

    public void parseOp(ExprBinary.Op op) {
        switch (op) {
            case EQUALS:
                this.op = Op.EQUALS;
                break;
            case NOT_EQUALS:
                this.op = Op.NOT_EQUALS;
                break;
            case IMPLIES:
                this.op = Op.IMPLIES;
                break;
            case LT:
                this.op = Op.LT;
                break;
            case LTE:
                this.op = Op.LTE;
                break;
            case GT:
                this.op = Op.GT;
                break;
            case GTE:
                this.op = Op.GTE;
                break;
            case NOT_LT:
                this.op = Op.NOT_LT;
                break;
            case NOT_LTE:
                this.op = Op.NOT_LTE;
                break;
            case NOT_GT:
                this.op = Op.NOT_GT;
                break;
            case NOT_GTE:
                this.op = Op.NOT_GTE;
                break;
            case IN:
                this.op = Op.IN;
                break;
            case NOT_IN:
                this.op = Op.NOT_IN;
                break;
            case AND:
                this.op = Op.AND;
                break;
            case OR:
                this.op = Op.OR;
                break;
            case IFF:
                this.op = Op.IFF;
                break;
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        if(op == null)
            return;
        sb.append("(");
        left.toString(sb);
        sb.append(op.toString());
        right.toString(sb);
        sb.append(")");
    }

    @Override
    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            if(op == null)
                return;
            left.toTemplateString(t, value, sb);
            sb.append(op.toString());
            right.toTemplateString(t, value, sb);
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
            if(op == null)
                return;
            left.toQtTemplateString(t, value, sb);
            sb.append(op.toString());
            right.toQtTemplateString(t, value, sb);
    }

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
        return "("+l+op.toString()+r+")";
    }


    @Override
    public void toGenericString(StringBuilder sb){
        left.toGenericString(sb);
        sb.append(op);
        right.toGenericString(sb);
    }

    public Op getOp() {
        return op;
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

    public static enum Op {
        /**
         * =
         */
        EQUALS("="),
        /**
         * !=
         */
        NOT_EQUALS("!="),
        /**
         * =&gt;
         */
        IMPLIES("=>"),
        /**
         * &lt;
         */
        LT("<"),
        /**
         * =&lt;
         */
        LTE("<="),
        /**
         * &gt;
         */
        GT(">"),
        /**
         * &gt;=
         */
        GTE(">="),
        /**
         * !&lt;
         */
        NOT_LT("!<"),
        /**
         * !=&lt;
         */
        NOT_LTE("!<="),
        /**
         * !&gt;
         */
        NOT_GT("!>"),
        /**
         * !&gt;=
         */
        NOT_GTE("!>="),
        /**
         * in
         */
        IN("in"),
        /**
         * !in
         */
        NOT_IN("!in"),
        /**
         * &amp;&amp;
         */
        AND("&&"),
        /**
         * ||
         */
        OR("||"),
        /**
         * &lt;=&gt;
         */
        IFF("<=>");

        String label;

        Op(String label) {
            this.label = label;
        }

        @Override
        public String toString() {
            return " " +  this.label + " ";
        }
    }
}
