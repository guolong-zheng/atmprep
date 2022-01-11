package mutation.operators;

import parser.ast.*;
import parser.visitor.GenericVisitor;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.structures.Template;

import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class QtInfoCollector implements GenericVisitor<HashSet<String>, Object> {

    public static Set<Exprn> visited = new HashSet<>();
    public Set<String> vars;
    public Set<Exprn> subs;
    boolean collect;

    public QtInfoCollector() {
        vars = new HashSet<>();
        subs = new HashSet<>();
        collect = true;
    }

    @Override
    public HashSet<String> visit(ExprnListBool expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        for(Iterator<Exprn> it = expr.getArgs().iterator(); it.hasNext();){
            Exprn sub = it.next();
            containedVars.addAll(sub.accept(this, it));
        }
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnListRel expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        expr.getArgs().forEach(sub -> containedVars.addAll(sub.accept(this, arg)));
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnQtBool expr, Object arg) {
        expr.getVars().forEach(var -> var.getNames().forEach(n -> vars.add(n.toString())));
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.getSub().accept(this, arg));
        visited.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnQtRel expr, Object arg) {
        expr.getVars().forEach(var -> var.getNames().forEach(n -> vars.add(n.toString())));
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.getSub().accept(this, arg));
        visited.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnBinaryBool expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.left.accept(this, arg));
        containedVars.addAll(expr.right.accept(this, arg));
        if (!(expr.op == ExprnBinaryBool.Op.AND ||
                expr.op == ExprnBinaryBool.Op.OR ||
                expr.op == ExprnBinaryBool.Op.IFF ||
                expr.op == ExprnBinaryBool.Op.IMPLIES)) {
            if (collect && Collections.disjoint(vars, containedVars)) {
                subs.add(expr);
                Exprn parent = (Exprn)expr.getParent();
                if(parent instanceof ExprnBinary){
                    Exprn left = ((ExprnBinary) parent).left;
                    Exprn right = ((ExprnBinary) parent).right;
                    if(left==expr){
                        expr.left = new ExprnConst(parent);
                    }
                    if(right==expr) {
                        expr.right = new ExprnConst(parent);
                    }
                }
                if(parent instanceof ExprnList){
                    ((Iterator)arg).remove();
                }
            }
        }
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnBinaryRel expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.left.accept(this, arg));
        containedVars.addAll(expr.right.accept(this, arg));
//        if (collect && Collections.disjoint(vars, containedVars))
//            subs.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnUnaryBool expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.getSub().accept(this, arg));
        if (collect && Collections.disjoint(vars, containedVars))
            subs.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnUnaryRel expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.addAll(expr.getSub().accept(this, arg));
//        if (collect && Collections.disjoint(vars, containedVars))
//            subs.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnCallBool expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        expr.getArgs().forEach(v->containedVars.addAll(v.accept(this, arg)));
        if (collect && Collections.disjoint(vars, containedVars)) {
            subs.add(expr);
        }
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnCallRel expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        expr.getArgs().forEach(v->containedVars.addAll(v.accept(this, arg)));
        if (collect && Collections.disjoint(vars, containedVars))
            subs.add(expr);
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnITEBool expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        collect = false;
        containedVars.addAll(expr.condition.accept(this, arg));
        containedVars.addAll(expr.thenClause.accept(this, arg));
        containedVars.addAll(expr.elseClause.accept(this, arg));
        if (collect && Collections.disjoint(vars, containedVars))
            subs.add(expr);
        collect = true;
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnITERel expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        collect = false;
        containedVars.addAll(expr.condition.accept(this, arg));
        containedVars.addAll(expr.thenClause.accept(this, arg));
        containedVars.addAll(expr.elseClause.accept(this, arg));
        if (collect && Collections.disjoint(vars, containedVars))
            subs.add(expr);
        collect = true;
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnLet expr, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(ExprnSig expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.add(expr.toString());
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnConst expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.add(expr.toString());
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnVar expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.add(expr.toString());
        return containedVars;
    }

    @Override
    public HashSet<String> visit(ExprnField expr, Object arg) {
        HashSet<String> containedVars = new HashSet<>();
        containedVars.add(expr.toString());
        return containedVars;
    }

    @Override
    public HashSet<String> visit(Function func, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Template t, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Hole h, Object arg) {
        return null;
    }


    @Override
    public HashSet<String> visit(AModel model, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Assert asserts, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Opens open, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(SigDef sigDef, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(DeclField decl, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(DeclParam decl, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(DeclVar decl, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Fact fact, Object arg) {
        return null;
    }

    @Override
    public HashSet<String> visit(Predicate pred, Object arg) {
        return null;
    }
}
