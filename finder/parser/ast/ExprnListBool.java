package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprList;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;
import java.util.Set;

public class ExprnListBool extends ExprnList {

    public Op op;

    public ExprnListBool(Node parent, ExprList exprList) {
        super(parent, exprList);
        switch (exprList.op) {
            case AND:
                this.op = Op.AND;
                break;
            case OR:
                this.op = Op.OR;
                break;
        }
    }

    public ExprnListBool(Node parent, ExprList exprList, Set<Object> core) {
        super(parent, exprList, core);
        switch (exprList.op) {
            case AND:
                this.op = Op.AND;
                break;
            case OR:
                this.op = Op.OR;
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
        if(args.size() > 0) {
            sb.append("(");
            for (int i = 0; i < args.size(); i++) {
                if (i > 0) {
                    sb.append(op.toString());
                }
                args.get(i).toString(sb);
            }
            sb.append(")");
        }
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            sb.append(t.toString());
        }else{
            if(args.size() > 0) {
                sb.append("(");
                for (int i = 0; i < args.size(); i++) {
                    if (i > 0) {
                        sb.append(op.toString());
                    }
                    args.get(i).toTemplateString(t, value, sb);
                }
                sb.append(")");
            }
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        if(args.size() > 0) {
            sb.append("(");
            for (int i = 0; i < args.size(); i++) {
                if (i > 0) {
                    sb.append(op.toString());
                }
                args.get(i).toQtTemplateString(t, value, sb);
            }
            sb.append(")");
        }
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
            if(args.size() > 0) {
            StringBuilder sb = new StringBuilder();
            sb.append("(");
            for (int i = 0; i < args.size(); i++) {
                if (i > 0) {
                    sb.append(op.toString());
                }
               sb.append( args.get(i).getInstantiatedString(name2val) );
            }
            sb.append(")\n");
            return sb.toString();
        }else
            return "";
    }

    public static enum Op {
        AND("&&"),
        OR("||");

        String label;

        Op(String label) {
            this.label = label;
        }

        @Override
        public String toString() {
            return " " + this.label + " ";
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
}
