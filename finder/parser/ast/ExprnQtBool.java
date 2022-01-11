package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprQt;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;

public class ExprnQtBool extends ExprnQt {

    public Op op;

    public ExprnQtBool(Node parent, ExprQt exprQt) {
        super(parent, exprQt);
        switch (exprQt.op) {
            case ALL:
                this.op = Op.ALL;
                break;
            case NO:
                this.op = Op.NO;
                break;
            case LONE:
                this.op = Op.LONE;
                break;
            case ONE:
                this.op = Op.ONE;
                break;
            case SOME:
                this.op = Op.SOME;
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
        sb.append(op);
        for(int i = 0; i < vars.size(); i++){
            if( i > 0 && i <= vars.size() - 1){
                sb.append(", ");
            }
            vars.get(i).toString(sb);
        }
        sb.append(" | ");
        sub.toString(sb);
    }


    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            //TODO: check if this fixing all others
            // changed from sb.append(t.toString);
            sb.append(t.original.toString());
        }else{
            sb.append(op);
            for(int i = 0; i < vars.size(); i++){
                if( i > 0 && i <= vars.size() - 1){
                    sb.append(", ");
                }
                vars.get(i).toString(sb);
            }
            sb.append(" | ");
            sub.toTemplateString(t, value, sb);
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        sb.append(op);
        for(int i = 0; i < vars.size(); i++){
            if( i > 0 && i <= vars.size() - 1){
                sb.append(", ");
            }
            vars.get(i).toString(sb);
        }
        sb.append(" | ");
        sub.toQtTemplateString(t, value, sb);
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        return sub.getInstantiatedString(name2val);
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
         * all a,b:x | formula
         */
        ALL("all"),
        /**
         * no a,b:x | formula
         */
        NO("no"),
        /**
         * lone a,b:x | formula
         */
        LONE("lone"),
        /**
         * one a,b:x | formula
         */
        ONE("one"),
        /**
         * some a,b:x | formula
         */
        SOME("some");

        /**
         * The constructor.
         */
        Op(String label) {
            this.label = label;
        }

        /**
         * The human readable label for this operator.
         */
        private final String label;

        @Override
        public String toString() {
            return this.label + " ";
        }
    }
}
