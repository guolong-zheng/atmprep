package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Decl;

import java.util.List;
import java.util.stream.Collectors;

/* Declaration that binds a list of names to an expression.
*  Concrete class: SigField; sig a { some b : set c }
*                  Pred or Func Param; pred/func p[a, b]
*
* */
public abstract class Declaration extends Node {

    /* list of names */
    List<Exprn> names;

    /* the bounded values */
    Exprn expr;

    /* whether each variable is disjoint */
    boolean disjoint;

    public Declaration(Node parent, Decl decl) {
        super(parent, decl);

        this.names = (List) decl.names.stream().map(name -> {
            return Exprn.parseExpr(this, name);
        }).collect(Collectors.toList());

        this.expr = Exprn.parseExpr(this, decl.expr);

        this.disjoint = decl.disjoint != null;

        this.children.add(expr);
    }

    public void toString(StringBuilder sb){
        for(int i = 0; i < names.size(); i++){
            if(i > 0){
                sb.append(", ");
            }
            names.get(i).toString(sb);
        }
        sb.append(": ");
        expr.toString(sb);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public Declaration(Node parent) {
        super(parent);
    }

    public List<Exprn> getNames() {
        return names;
    }

    public void setNames(List<Exprn> names) {
        this.names = names;
    }

    public Exprn getExpr() {
        return expr;
    }

    public void setExpr(Exprn expr) {
        this.expr = expr;
    }

    public boolean isDisjoint() {
        return disjoint;
    }

    public void setDisjoint(boolean disjoint) {
        this.disjoint = disjoint;
    }
}
