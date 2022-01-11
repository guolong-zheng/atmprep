package mutation;

import parser.ast.*;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

public class Mutator implements VoidVisitor {

    @Override
    public void visit(AModel model) {
        model.getFacts().forEach(fact -> fact.accept(this));
        model.getPredicates().stream().filter(pred -> !pred.getName().contains("repair_")).forEach(pred -> pred.accept(this));
        model.getFunctions().forEach( func -> func.accept(this));
    }

    @Override
    public void visit(Assert asserts) {

    }

    @Override
    public void visit(Opens open) {

    }

    @Override
    public void visit(SigDef sigDecl) {

    }

    @Override
    public void visit(DeclField sigField) {

    }

    @Override
    public void visit(DeclParam decl) {

    }

    @Override
    public void visit(DeclVar decl) {

    }

    @Override
    public void visit(Fact fact) {
        fact.getExpr().accept(this);
    }

    @Override
    public void visit(Predicate pred) {
        pred.getBody().accept(this);
    }

    @Override
    public void visit(Function func) {
        func.getBody().accept(this);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
       // ModifyParenthese.modify(expr);
       // BOD.mutate(expr);
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
      //  IntOp2Fun.modify(expr);
     //   BOD.mutate(expr);
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnCallBool expr) {

    }

    @Override
    public void visit(ExprnCallRel expr) {

    }

    @Override
    public void visit(ExprnConst expr) {

    }

    @Override
    public void visit(ExprnField expr) {

    }

    @Override
    public void visit(ExprnITEBool expr) {

    }

    @Override
    public void visit(ExprnITERel expr) {

    }

    @Override
    public void visit(ExprnLet expr) {

    }

    @Override
    public void visit(ExprnListBool expr) {
        expr.getArgs().forEach( arg -> arg.accept(this));
    }

    @Override
    public void visit(ExprnListRel expr) {
        expr.getArgs().forEach( arg -> arg.accept(this));
    }

    @Override
    public void visit(ExprnQtBool expr) {
        //MoveOutQt.modify(expr);
       // QDD.mutate(expr);
        expr.getVars().forEach( var -> {
            var.accept(this);
        });
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        expr.getVars().forEach(var -> expr.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnSig expr) {

    }

    @Override
    public void visit(ExprnVar expr) {

    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        //UOM.mutate(expr);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        //UOM.mutate(expr);
        expr.getSub().accept(this);
       // UOI.mutate(expr);
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
