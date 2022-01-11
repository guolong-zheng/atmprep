package parser.visitor;

import parser.ast.*;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

public class VoidVisitorWrapper implements VoidVisitor {
    @Override
    public void visit(AModel model) {
        model.getOpens().forEach(opens -> opens.accept(this));
        model.getSigDecls().forEach(sigDef -> sigDef.accept(this));
        model.getPredicates().forEach(predicate -> predicate.accept(this));
        model.getFunctions().forEach(function -> function.accept(this));
        model.getFacts().forEach(fact -> fact.accept(this));
        model.getAsserts().forEach(anAssert -> anAssert.accept(this));
        model.getCmds().forEach(cmd -> cmd.accept(this));
    }

    @Override
    public void visit(Assert asserts) {
        asserts.getFormula().accept(this);
    }

    @Override
    public void visit(Opens open) {

    }

    @Override
    public void visit(SigDef sigDecl) {
        sigDecl.getFields().forEach(field->field.accept(this));
        sigDecl.getFacts().forEach(fact->fact.accept(this));
    }

    @Override
    public void visit(DeclField sigField) {
        sigField.getNames().forEach(name->name.accept(this));
        sigField.getExpr().accept(this);
    }

    @Override
    public void visit(DeclParam decl) {
        decl.getNames().forEach(name->name.accept(this));
        decl.getExpr().accept(this);
    }

    @Override
    public void visit(DeclVar decl) {
        decl.getNames().forEach(name->name.accept(this));
        decl.getExpr().accept(this);
    }

    @Override
    public void visit(Fact fact) {
        fact.getExpr().accept(this);
    }

    @Override
    public void visit(Predicate pred) {
        pred.getParams().forEach(decl->decl.accept(this));
        pred.getBody().accept(this);
    }

    @Override
    public void visit(Function func) {
        func.getParams().forEach(decl->decl.accept(this));
        func.getBody().accept(this);
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
        expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
        expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {

    }

    @Override
    public void visit(ExprnField expr) {

    }

    @Override
    public void visit(ExprnSig expr) {

    }

    @Override
    public void visit(ExprnVar expr) {

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
        expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        expr.getVars().forEach(var->var.accept(this));
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

    @Override
    public void visit(Template template) {

    }

    @Override
    public void visit(VarHole hole){}

    @Override
    public void visit(ValueHole hole){}
}
