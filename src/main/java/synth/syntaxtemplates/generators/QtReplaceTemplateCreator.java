package synth.syntaxtemplates.generators;

import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.structures.QtReplaceTemplate;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

// generate replace vars templates
public class QtReplaceTemplateCreator extends VoidVisitorWrapper {
    // order expression by arity as priority?? possible
    Set<Exprn> potentialHoles;   // exprn that will be replaced by values
    Set<Exprn> qtVars; // exprn that can be replaced by a qt var
    Exprn orig;  // the exprn to repair

    public ArrayList<QtReplaceTemplate> templates;

    public QtReplaceTemplateCreator(Exprn expr){
        this.templates = new ArrayList<>();
        this.potentialHoles = new HashSet<>();
        this.qtVars = new HashSet<>();
        this.orig = expr;
    }

    public Set<Exprn> search(){
        orig.accept(this);
        return qtVars;
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        if(expr.getOp() == ExprnBinaryRel.Op.JOIN){
            for(ExprnQtBool.Op op : ExprnQtBool.Op.values()) {
                QtReplaceTemplate qt = new QtReplaceTemplate(orig, expr, op);
                templates.add(qt);
            }
        }
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnCallBool expr) {
       // expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
       // expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {

    }

    @Override
    public void visit(ExprnField expr) {
        for(ExprnQtBool.Op op : ExprnQtBool.Op.values()) {
            QtReplaceTemplate qt = new QtReplaceTemplate(orig, expr, op);
            templates.add(qt);
        }
        //qtVars.add(expr);
    }

    @Override
    public void visit(ExprnSig expr) {
        for(ExprnQtBool.Op op : ExprnQtBool.Op.values()) {
            QtReplaceTemplate qt = new QtReplaceTemplate(orig, expr, op);
            templates.add(qt);
        }
        // qtVars.add(expr);
    }

    @Override
    public void visit(ExprnVar expr) {
        // for already declared vars, no need to add new qt
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
        // TODO: ignore decl vars for now
        // expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        // TODO: ignore decl vars for now
        // expr.getVars().forEach(var->var.accept(this));
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
