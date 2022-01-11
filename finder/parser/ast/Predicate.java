package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Func;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/* pred name { params | expr }
*  pred p { a : set sig | expr }
* */

public class Predicate extends Node {

    String name;

    Exprn body;

    List<DeclParam> params;

    public Predicate(Node parent, Func func) {
        super(parent, func);
        this.name = StringUtil.removeThis(func.label);
        this.body = Exprn.parseExpr(this, func.getBody());
        this.params = new ArrayList<>();
        func.decls.stream().forEach(decl -> params.add(new DeclParam(this, decl)));
        this.nodeMap.put(name, this);
    }

    public Predicate(Node parent, Func func, Set<Object> core) {
        super(parent, func);
        this.name = StringUtil.removeThis(func.label);
        this.body = Exprn.parseExpr(this, func.getBody(), core);
        this.params = new ArrayList<>();
        func.decls.stream().forEach(decl -> params.add(new DeclParam(this, decl)));
        this.nodeMap.put(name, this);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append("pred ").append(StringUtil.removeDollar(name));
        if(params.size() > 0)
            sb.append("[ ");
        for(int i = 0; i < params.size(); i++){
            if(i > 0 && i <= params.size() - 1){
                sb.append(",");
            }
            params.get(i).toString(sb);
        }
        if(params.size() > 0)
            sb.append("] ");
        sb.append("{\n");
        if(body == null)
            sb.append(" ");
        else if(!body.toString().equals("true"))
            body.toString(sb);
        sb.append("}\n");
    }

    public void toTemplateString(Template t, String value, StringBuilder sb){
        sb.append("pred ").append(StringUtil.removeDollar(name));
        if(params.size() > 0)
            sb.append("[ ");
        for(int i = 0; i < params.size(); i++){
            if(i > 0 && i <= params.size() - 1){
                sb.append(",");
            }
            params.get(i).toString(sb);
        }
        if(params.size() > 0)
            sb.append("] ");
        sb.append("{\n");
        if(body == null)
            sb.append(" ");
        else if(!body.toString().equals("true"))
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

    public List<DeclParam> getParams() {
        return params;
    }

    public void setParams(List<DeclParam> params) {
        this.params = params;
    }
}
