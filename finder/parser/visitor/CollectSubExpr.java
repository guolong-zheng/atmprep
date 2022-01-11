package parser.visitor;

import parser.ast.*;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.structures.Template;

import java.util.HashSet;
import java.util.Set;

// collect all sub expressions
public class CollectSubExpr implements GenericVisitor {

    public Set<Exprn> booleanExpr;

    public Set<Exprn> relationExpr;

    public CollectSubExpr(){
        booleanExpr = new HashSet<>();
        relationExpr = new HashSet<>();
    }

    @Override
    public Object visit(AModel model, Object arg) {
        return null;
    }

    @Override
    public Object visit(Assert asserts, Object arg) {
        return null;
    }

    @Override
    public Object visit(Opens open, Object arg) {
        return null;
    }

    @Override
    public Object visit(SigDef sigDef, Object arg) {
        return null;
    }

    @Override
    public Object visit(DeclField decl, Object arg) {
        return null;
    }

    @Override
    public Object visit(DeclParam decl, Object arg) {
        return null;
    }

    @Override
    public Object visit(DeclVar decl, Object arg) {
        return null;
    }

    @Override
    public Object visit(Fact fact, Object arg) {
        return null;
    }

    @Override
    public Object visit(Predicate pred, Object arg) {
        return null;
    }

    @Override
    public Object visit(ExprnBinaryBool exp, Object arg) {
        booleanExpr.add(exp);
        Exprn left = exp.getLeft();
        Exprn right = exp.getRight();
        left.accept(this, arg);
        right.accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnBinaryRel expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnCallBool expr, Object arg) {
        booleanExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnCallRel expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnConst expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnField expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnITEBool expr, Object arg) {
        booleanExpr.add(expr);
        expr.getCondition().accept(this, arg);
        expr.getElseClause().accept(this, arg);
        expr.getThenClause().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnITERel expr, Object arg) {
        relationExpr.add(expr);
        expr.getCondition().accept(this, arg);
        expr.getElseClause().accept(this, arg);
        expr.getThenClause().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnLet expr, Object arg) {
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnListBool expr, Object arg) {
        booleanExpr.add(expr);
        for( Exprn ag : expr.getArgs() ){
            ag.accept(this, arg);
        }
        return null;
    }

    @Override
    public Object visit(ExprnListRel expr, Object arg) {
        if( expr.op == ExprnListRel.Op.DISJOINT){
            booleanExpr.add(expr);
        }else {
            relationExpr.add(expr);
        }
        for( Exprn ag : expr.getArgs() ){
            ag.accept(this, arg);
        }
        return null;
    }

    @Override
    public Object visit(ExprnQtBool expr, Object arg) {
       // booleanExpr.add(expr);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnQtRel expr, Object arg) {
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnSig expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnVar expr, Object arg) {
        relationExpr.add(expr);
        return null;
    }

    @Override
    public Object visit(ExprnUnaryBool expr, Object arg) {
        booleanExpr.add(expr);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnUnaryRel expr, Object arg) {
        relationExpr.add(expr);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(Function func, Object arg) {
        return null;
    }

    @Override
    public Object visit(Template t, Object arg) {
        return null;
    }

    @Override
    public Object visit(Hole h, Object arg) {
        return null;
    }
}
