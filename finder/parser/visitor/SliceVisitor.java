package parser.visitor;

import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.*;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import utility.StringUtil;

import java.util.HashSet;
import java.util.Set;

/*
*  Find all preds and funs involved in the targeted cmd
* */
public class SliceVisitor implements VoidVisitor {
    public String name;
    public Set<String> relatedPreds;
    // num of expression sliced out
    int sliced;

    public boolean emptybody;
    public Exprn loc;

    public SliceVisitor(Command cmd){
        this.name = cmd.label;
        relatedPreds = new HashSet<>();
    }

    @Override
    public void visit(AModel model) {
        model.getAsserts().stream().forEach( anAssert -> {
            if( anAssert.getName().equals(this.name) ) {
                anAssert.accept(this);
            }
        });
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

    }

    /*
    * Collect
    * */
    @Override
    public void visit(Predicate pred) {
        if(pred.getName().endsWith("OK") || pred.getName().endsWith("ok") || pred.getName().endsWith("Ok")){
            return;
        }
        if(pred.getName().contains("CanEnter")){
           return;
        }
        if(pred.getBody().toString().equals("true")){
           emptybody = true;
            loc = pred.getBody();
        }

        relatedPreds.add(pred.getName());
        pred.getBody().accept(this);
    }

    /*
    * Collect
    * */
    @Override
    public void visit(Function func) {
        relatedPreds.add(func.getName());
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

    /*
    * collect
    * */
    @Override
    public void visit(ExprnCallBool expr) {
        String name = StringUtil.removeThis(expr.getName());
        expr.getNodeMap().findFunc(name).accept(this);
    }

    /*
    * collect
    * */
    @Override
    public void visit(ExprnCallRel expr) {
        String name = StringUtil.removeThis(expr.getName());
        if( name.contains("integer") || name.contains("order") || name.contains("/next"))
            return;
        expr.getNodeMap().findFunc(name).accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {
    }

    @Override
    public void visit(ExprnField expr) {
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
        expr.getExpr().accept(this);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnListBool expr) {
        expr.getArgs().forEach( exp -> exp.accept(this) );
    }

    @Override
    public void visit(ExprnListRel expr) {
        expr.getArgs().forEach( exp -> exp.accept(this) );
    }

    @Override
    public void visit(ExprnQtBool expr) {
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
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
