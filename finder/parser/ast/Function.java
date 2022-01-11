package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Func;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.ArrayList;
import java.util.List;

public class Function extends Node {

    String name;

    Exprn body;

    Exprn returnExpr;

    List<DeclParam> params;

    public Function(Node parent, Func func) {
        super(parent, func);
        this.name = StringUtil.removeThis(func.label);
        this.body = Exprn.parseExpr(this, func.getBody());
        this.returnExpr = Exprn.parseExpr(this, func.returnDecl);
        this.params = new ArrayList<>();
        func.decls.stream().forEach(decl ->{ params.add(new DeclParam(this, decl)); });

        this.nodeMap.put(name, this);
    }

    @Override
    public String toString() {
        if(body.toString().equals("true")){
            return "\n";
        }
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        if(body.toString().equals("true")){
            sb.append("\n");
            return;
        }
        sb.append("fun ").append(name).append(" [");
        for(int i = 0; i < params.size(); i++){
            if(i > 0 && i <= params.size() - 1){
                sb.append(",");
            }
            params.get(i).toString(sb);
        }
        sb.append("] : ");
        returnExpr.toString(sb);
        sb.append("{\n");
        if(body !=null)
            body.toString(sb);
        sb.append("}\n");
    }

    public void toTemplateString(Template t, String value, StringBuilder sb){
        if(body.toString().equals("true")){
            sb.append("\n");
            return;
        }
        sb.append("fun ").append(name).append(" [");
        for(int i = 0; i < params.size(); i++){
            if(i > 0 && i <= params.size() - 1){
                sb.append(",");
            }
            params.get(i).toString(sb);
        }
        sb.append("] : ");
        returnExpr.toTemplateString(t, value, sb);
        sb.append("{\n");
        if(body !=null)
            body.toTemplateString(t, value, sb);
        sb.append("}\n");
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Exprn getBody() {
        return body;
    }

    public void setBody(Exprn body) {
        this.body = body;
    }

    public Exprn getReturnExpr() {
        return returnExpr;
    }

    public void setReturnExpr(Exprn returnExpr) {
        this.returnExpr = returnExpr;
    }

    public List<DeclParam> getParams() {
        return params;
    }

    public void setParams(List<DeclParam> params) {
        this.params = params;
    }
}
