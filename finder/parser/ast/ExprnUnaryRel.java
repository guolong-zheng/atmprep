package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprUnary;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

public class ExprnUnaryRel extends ExprnUnary {

    public Op op;

    public ExprnUnaryRel(Node parent, ExprUnary expr) {
        super(parent, expr);
        switch (expr.op) {
            case SOMEOF:
                this.op = Op.SOME;
                break;
            case LONEOF:
                this.op = Op.LONE;
                break;
            case ONEOF:
                this.op = Op.ONE;
                break;
            case SETOF:
                this.op = Op.SET;
                break;
            case EXACTLYOF:
                this.op = Op.EXACTLYOF;
                break;
            case TRANSPOSE:
                this.op = Op.TRANSPOSE;
                break;
            case RCLOSURE:
                this.op = Op.RCLOSURE;
                break;
            case CLOSURE:
                this.op = Op.CLOSURE;
                break;
            case CARDINALITY:
                this.op = Op.CARDINALITY;
                break;
            case CAST2INT:
                this.op = Op.CAST2INT;
                break;
            case CAST2SIGINT:
                this.op = Op.CAST2SIGINT;
                break;
            case NOOP:
                this.op = Op.NOOP;
                break;
        }
    }

    public ExprnUnaryRel(Node parent, Op op, Exprn expr, Type type) {
        super(parent);
        this.op = op;
        this.sub = expr;
        this.type = type;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append(op);
        sb.append("(");
        sub.toString(sb);
        sb.append(")");
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            sb.append(op);
            sb.append("(");
            sub.toTemplateString(t, value, sb);
            sb.append(")");
        }
    }

    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {

            sb.append(op);
            sb.append("(");
            sub.toQtTemplateString(t, value, sb);
            sb.append(")");

    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        switch(op){
            case TRANSPOSE:
            case RCLOSURE:
            case CLOSURE:
            case CARDINALITY:
                return op.toString() + "(" + sub.getInstantiatedString(name2val) + ")";
            default:
                return sub.getInstantiatedString(name2val);
        }
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
        LONE("lone"),
        ONE("one"),
        SOME("some"),
        SET("set"),
        EXACTLYOF("exactly"),
        TRANSPOSE("~"),
        RCLOSURE("*"),
        CLOSURE("^"),
        CARDINALITY("#"),
        CAST2INT("Int->int"),
        CAST2SIGINT("int->Int"),
        NOOP("");

        private String label;

        private Op(String label) {
            this.label = label;
        }

        public String toString() {
            switch (this) {
                case LONE:
                case ONE:
                case SOME:
                case EXACTLYOF:
                case SET:
                    return label + " ";
                case TRANSPOSE:
                case RCLOSURE:
                case CLOSURE:
                case CARDINALITY:
                    return label;
                case CAST2INT:
                case CAST2SIGINT:
                case NOOP:
                    return "";
                default:
                    return "";

            }
        }
    }
}
