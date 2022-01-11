package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprList;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class ExprnList extends Exprn {

    public List<Exprn> args;

    public ExprnList(Node parent, ExprList expr) {
        super(parent, expr);
        this.args = expr.args.stream().map(arg -> {
            return Exprn.parseExpr(this, arg);
        }).
                collect(Collectors.toList());
    }

    public ExprnList(Node parent, ExprList expr, Set<Object> core) {
        super(parent, expr);
        this.args = expr.args.stream().map(arg -> {
            return Exprn.parseExpr(this, arg, core);
        }).filter( exprn -> exprn != null).
                collect(Collectors.toList());
    }

    public List<Exprn> getArgs() {
        return args;
    }

    public void setArgs(List<Exprn> args) {
        this.args = args;
    }
}
