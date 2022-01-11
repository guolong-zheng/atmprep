package utility;

import parser.ast.*;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

public class NodeCounter implements VoidVisitor {

    public int count;


    public NodeCounter(){
        this.count = 0;
    }

    @Override
    public void visit(AModel model) {
       // model.getSigDecls().stream().forEach(sigDef -> sigDef.accept(this));
        model.getFacts().stream().forEach(fact -> fact.accept(this));
        model.getFunctions().stream().filter(func -> !func.getName().contains("repair")).forEach(function -> function.accept(this));
        model.getPredicates().stream().filter(func -> !func.getName().contains("repair")).forEach(function -> function.accept(this));
    }

    @Override
    public void visit(Assert asserts) {
        return;
    }

    @Override
    public void visit(Opens open) {
        return;
    }

    @Override
    public void visit(SigDef sigDef) {
//        sigDef.getFields().forEach(declField -> declField.accept(this));
//        sigDef.getFacts().forEach(fact -> fact.accept(this));
//         count++;
    }

    @Override
    public void visit(DeclField decl) {
        decl.getNames().forEach(name -> name.accept(this));
        decl.getExpr().accept(this);
         count++;
    }

    @Override
    public void visit(DeclParam decl) {
        decl.getNames().forEach(name -> name.accept(this));
        decl.getExpr().accept(this);
         count++;
    }

    @Override
    public void visit(DeclVar decl) {
        decl.getNames().forEach(name -> name.accept(this));
        decl.getExpr().accept(this);
        count++;
    }

    @Override
    public void visit(Fact fact) {
        fact.getExpr().accept(this);
         count++;
    }

    @Override
    public void visit(Predicate pred) {
        if(pred.getBody() == null)
            return;
        pred.getBody().accept(this);
        pred.getParams().stream().forEach(param -> param.accept(this));
         count++;
    }

    @Override
    public void visit(Function func) {
        func.getBody().accept(this);
        func.getParams().stream().forEach(param -> param.accept(this));
         count++;
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        expr.getLeft().accept(this);
        expr.getRight().accept(this);

         count++;
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        expr.getLeft().accept(this);
        expr.getRight().accept(this);

         count++;
    }

    @Override
    public void visit(ExprnCallBool expr) {
        expr.getArgs().forEach(arg -> arg.accept(this));

         count++;
    }

    @Override
    public void visit(ExprnCallRel expr) {
        expr.getArgs().forEach(arg -> arg.accept(this));

         count++;
    }

    @Override
    public void visit(ExprnConst expr) {

         count++;
    }

    @Override
    public void visit(ExprnField expr) {

         count++;
    }

    @Override
    public void visit(ExprnITEBool expr) {
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);

         count++;
    }

    @Override
    public void visit(ExprnITERel expr) {
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);

         count++;
    }

    @Override
    public void visit(ExprnLet expr) {
        expr.getVar().accept(this);
        expr.getExpr().accept(this);
        expr.getSub().accept(this);

         count++;
    }

    @Override
    public void visit(ExprnListBool expr) {

        expr.getArgs().forEach(arg->arg.accept(this));
         count++;
    }

    @Override
    public void visit(ExprnListRel expr) {

        expr.getArgs().forEach(arg->arg.accept(this));
         count++;
    }

    @Override
    public void visit(ExprnQtBool expr) {

        expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
         count++;
    }

    @Override
    public void visit(ExprnQtRel expr) {

        expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
         count++;
    }

    @Override
    public void visit(ExprnSig expr) {

         count++;
    }

    @Override
    public void visit(ExprnVar expr) {

         count++;
    }

    @Override
    public void visit(ExprnUnaryBool expr) {

        expr.getSub().accept(this);
         count++;
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        expr.getSub().accept(this);
        if(expr.op != ExprnUnaryRel.Op.NOOP){
            count++;
        }

    }

    @Override
    public void visit(Template template) {

    }

    @Override
    public void visit(VarHole hole) {

    }

    @Override
    public void visit(ValueHole hole) {

    }
}
