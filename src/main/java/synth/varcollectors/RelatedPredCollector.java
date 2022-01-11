package synth.varcollectors;

import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.HashSet;
import java.util.Set;

public class RelatedPredCollector extends VoidVisitorWrapper {
    public String name;

    Set<Predicate> preds;
    Set<Function> funcs;

    public RelatedPredCollector(Command cmd){
        name = cmd.label;
        preds = new HashSet<>();
        funcs = new HashSet<>();
    }

    @Override
    public void visit(AModel model) {
        model.getAsserts().stream().forEach( anAssert -> {
            if( anAssert.getName().equals(this.name) ) {
                anAssert.accept(this);
            }
        });

        model.getPredicates().stream().forEach( pred -> {
            if( pred.getName().equals(this.name) ) {
                pred.accept(this);
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
        preds.add(pred);
        pred.getBody().accept(this);
    }

    /*
    * Collect
    * */
    @Override
    public void visit(Function func) {
        funcs.add(func);
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
