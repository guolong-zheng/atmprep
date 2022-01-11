package synth.syntaxtemplates.generators;

import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.structures.QtRemoveTemplate;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public class QtRemoveTemplateCreator extends VoidVisitorWrapper {

    // order expression by arity as priority?? possible
    Set<Exprn> potentialHoles;   // exprn that will be replaced by values
    Set<ExprnVar> qtVars; // exprn that can be replaced by a qt var
    Exprn orig;  // the exprn to repair

    public ArrayList<QtRemoveTemplate> templates;

    public QtRemoveTemplateCreator(Exprn expr){
        this.templates = new ArrayList<>();
        this.potentialHoles = new HashSet<>();
        this.qtVars = new HashSet<>();
        this.orig = expr;
    }

    public void search(){
        orig.accept(this);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnCallBool expr) {
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {
    }

    @Override
    public void visit(ExprnField expr) {
        //qtVars.add(expr);
    }

    @Override
    public void visit(ExprnSig expr) {
        // qtVars.add(expr);
    }

    @Override
    public void visit(ExprnVar expr) {
        // only search for decl vars
        QtRemoveTemplate qt = new QtRemoveTemplate(orig, expr);
        templates.add(qt);
    }

    @Override
    public void visit(ExprnITEBool expr) {
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    @Override
    public void visit(ExprnITERel expr) {
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    @Override
    public void visit(ExprnLet expr) {
        expr.getVar().accept(this);
        expr.getExpr().accept(this);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnListBool expr) {
        expr.getArgs().forEach(arg->arg.accept(this));
    }

    @Override
    public void visit(ExprnListRel expr) {
        expr.getArgs().forEach(arg->arg.accept(this));
    }

    @Override
    public void visit(ExprnQtBool expr) {
        //expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        //expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        expr.getSub().accept(this);
    }

}
