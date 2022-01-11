package synth.syntaxtemplates.generators;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;

import java.util.HashSet;
import java.util.Set;

public class HoleTypeCollector extends VoidVisitorWrapper {

    Set<Type> types;

    public HoleTypeCollector(){
        types = new HashSet<>();
    }

    public Set<Type> collect(Exprn expr){
        expr.accept(this);
        return types;
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        types.add(expr.getType());
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
        types.add(expr.getType());
        expr.getArgs().forEach(arg->arg.accept(this));
        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnConst expr) {
        types.add(expr.getType());
    }

    @Override
    public void visit(ExprnField expr) {
        types.add(expr.getType());
    }

    @Override
    public void visit(ExprnSig expr) {
        types.add(expr.getType());
    }

    @Override
    public void visit(ExprnVar expr) {
        types.add(expr.getType());
    }

    @Override
    public void visit(ExprnITERel expr) {
        types.add(expr.getType());
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    @Override
    public void visit(ExprnListRel expr) {
        types.add(expr.getType());
        expr.getArgs().forEach(arg->arg.accept(this));
    }

    @Override
    public void visit(ExprnQtRel expr) {
        types.add(expr.getType());
        expr.getVars().forEach(var->var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        types.add(expr.getType());
        expr.getSub().accept(this);
    }
}
