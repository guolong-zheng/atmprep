package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprQt;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.printers.TemplatePrinter;
import utility.StringUtil;

import java.util.HashMap;
import java.util.Map;

public class ExprnQtRel extends ExprnQt {
    public Op op;

    public ExprnQtRel(Node parent, ExprQt exprQt) {
        super(parent, exprQt);
        switch (exprQt.op) {
            case SUM:
                this.op = Op.SUM;
                break;
            case COMPREHENSION:
                this.op = Op.COMPREHENSION;
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
        if( op == Op.COMPREHENSION)
            sb.append("{");
        else
            sb.append(op);
        for(int i = 0; i < vars.size(); i++){
            if( i > 0 && i <= vars.size() - 1){
                sb.append(", ");
            }
            vars.get(i).toString(sb);
        }
        sb.append(" | ");
        sub.toString(sb);
        if( op == Op.COMPREHENSION){
            sb.append("}");
        }
    }

    public void toTemplateString(Template t, String value, StringBuilder sb) {
        if(this == t.original) {
            TemplatePrinter tp = new TemplatePrinter(t);
            sb.append( tp.instantiate(value) );
        }else{
            if( op == Op.COMPREHENSION)
                sb.append("{");
            else
                sb.append(op);
            for(int i = 0; i < vars.size(); i++){
                if( i > 0 && i <= vars.size() - 1){
                    sb.append(", ");
                }
                vars.get(i).toString(sb);
            }
            sb.append(" | ");
            sub.toTemplateString(t, value, sb);
            if( op == Op.COMPREHENSION){
                sb.append("}");
            }
        }
    }

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {
        if( op == Op.COMPREHENSION)
            sb.append("{");
        else
            sb.append(op);
        for(int i = 0; i < vars.size(); i++){
            if( i > 0 && i <= vars.size() - 1){
                sb.append(", ");
            }
            vars.get(i).toString(sb);
        }
        sb.append(" | ");
        sub.toQtTemplateString(t, value, sb);
        if( op == Op.COMPREHENSION){
            sb.append("}");
        }
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        switch(op){
            case COMPREHENSION:
                if( this.parent instanceof ExprnUnaryRel ){
                    ExprnUnaryRel p = (ExprnUnaryRel) this.parent;
                    if(p.op == ExprnUnaryRel.Op.CARDINALITY){
                        Map<String, String> newmap = new HashMap<>();
                        newmap.put("Int", name2val.get("Int"));
                        name2val.keySet().stream().filter( n -> StringUtil.isInteger( name2val.get(n))).forEach(
                              n-> newmap.put(n, name2val.get(n))
                        );
                        String pre = "";
                        for( Declaration decl : this.vars){
                            pre += decl.toString();
                        }
                        pre += "|";
                        return  "{" + pre + sub.getInstantiatedString(newmap) + "}";
                    }
                }
                String pre = "";
                for(Declaration decl : vars){
                    pre += decl.toString();
                }
                return "{" + pre + "{" + sub.getInstantiatedString(name2val) + "}" + "}";
            default:
                return op.toString() + "(" +  sub.getInstantiatedString(name2val) + ")";
        }

    }

    public static enum Op {
        SUM("sum"),
        /**
         * { a,b:x | formula }
         */
        COMPREHENSION("comprehension");

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
        public String toString() {
            return label;
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

    public Op getOp() {
        return op;
    }

    public void setOp(Op op) {
        this.op = op;
    }
}
