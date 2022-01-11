package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprQt;

import java.util.List;
import java.util.stream.Collectors;

/**
 * represents a quantified expression. It can have one of the
 * following forms: <br>
 * <br>
 * ( all a,b:t | formula ) <br>
 * ( no a,b:t | formula ) <br>
 * ( lone a,b:t | formula ) <br>
 * ( one a,b:t | formula ) <br>
 * ( some a,b:t | formula ) <br>
 * ( sum a,b:t | integer expression ) <br>
 * { a,b:t | formula } <br>
 * { a,b:t } <br>
 */
public abstract class ExprnQt extends Exprn {

    public List<Declaration> vars;

    public Exprn sub;

    public ExprnQt(Node parent, ExprQt exprQt) {
        super(parent, exprQt);
        this.vars =
                exprQt.decls.stream().map(decl -> {
                    return new DeclVar(this, decl);
                }).collect(Collectors.toList());
        this.sub = Exprn.parseExpr(this, exprQt.sub);
    }

    public List<Declaration> getVars() {
        return vars;
    }

    public void setVars(List<Declaration> vars) {
        this.vars = vars;
    }

    public Exprn getSub() {
        return sub;
    }

    public void setSub(Exprn sub) {
        this.sub = sub;
        sub.parent = this;
    }
}
