package parser.visitor;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

import java.util.List;
import java.util.Map;

public class TypeCollector implements VoidVisitor {

    Map<Node, List<String>> node2keywrod;
    Map<Node, List<Type>> node2type;

    @Override
    public void visit(AModel model) {
        model.getSigDecls().stream().forEach(sigDef -> sigDef.accept(this));
        model.getFacts().stream().forEach(fact -> fact.accept(this));
        model.getFunctions().stream().forEach(function -> function.accept(this));
        model.getPredicates().stream().forEach(predicate -> predicate.accept(this));
    }

    @Override
    public void visit(Assert asserts) {

    }

    @Override
    public void visit(Opens open) {

    }

    @Override
    public void visit(SigDef sigDecl) {
        sigDecl.getFields().forEach(declField -> declField.accept(this));
        sigDecl.getFacts().forEach(fact -> fact.accept(this));
    }

    @Override
    public void visit(DeclField sigField) {
        sigField.getNames().forEach(name -> name.accept(this));
        sigField.getExpr().accept(this);
    }

    @Override
    public void visit(DeclParam decl) {
        decl.getNames().forEach(name -> name.accept(this));
        decl.getExpr().accept(this);
    }

    @Override
    public void visit(DeclVar decl) {
        decl.getNames().forEach(name -> name.accept(this));
        decl.getExpr().accept(this);
    }

    @Override
    public void visit(Fact fact) {
        fact.getExpr().accept(this);
    }

    @Override
    public void visit(Predicate pred) {
        pred.getParams().forEach(declParam -> declParam.accept(this));
        pred.getBody().accept(this);
    }

    @Override
    public void visit(Function func) {
        func.getParams().forEach(param -> param.accept(this));
        func.getBody().accept(this);
        func.getReturnExpr().accept(this);
    }

    /*TODO: Collect*/
    @Override
    public void visit(ExprnBinaryBool expr) {
        System.out.println(expr.getLeft().getAlloyNode().toString());
        System.out.println(expr.getRight().getAlloyNode().toString());
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    /*TODO: Collect*/
    @Override
    public void visit(ExprnBinaryRel expr) {

    }

    @Override
    public void visit(ExprnCallBool expr) {
        expr.getArgs().forEach(var -> var.accept(this));
    }

    @Override
    public void visit(ExprnCallRel expr) {
        expr.getArgs().forEach(var -> var.accept(this));
    }

    /*TODO: Collect*/
    @Override
    public void visit(ExprnConst expr) {

    }

    /*TODO: collect*/
    @Override
    public void visit(ExprnField expr) {

    }

    /*should consider condition ???*/
    @Override
    public void visit(ExprnITEBool expr) {
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    /*should consider condition ???*/
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
        expr.getArgs().forEach(ag -> ag.accept(this));
    }

    @Override
    public void visit(ExprnListRel expr) {
        expr.getArgs().forEach(ag -> ag.accept(this));
    }

    @Override
    public void visit(ExprnQtBool expr) {
        expr.getVars().forEach(var -> var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        expr.getVars().forEach(var -> var.accept(this));
        expr.getSub().accept(this);
    }

    /*TODO: collect*/
    @Override
    public void visit(ExprnSig expr) {

    }

    @Override
    public void visit(ExprnVar expr) {

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
    public void visit(VarHole hole) {

    }

    @Override
    public void visit(ValueHole hole) {

    }

}
