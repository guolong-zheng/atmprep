package mutation;

import mutation.operators.*;
import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;
import util.RepairOption;
import util.RepairReporter;
import util.SynthUtil;
import utility.LOGGER;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class ExprMutator extends VoidVisitorWrapper {
    public RepairOption opt;

    public RepairReporter rep;

    public Exprn original; //original expression

    Exprn current;

    public int depth;  //mutation iterations

    static int max = 3;

    static HashMap<String, Exprn> str2mutants;

    static HashMap<String, Exprn> val2expr;

    static Set<Exprn> exprns;

    public static Set<String> mutants;

    public ExprMutator(RepairOption opt, Exprn orig, RepairReporter rep){
        this.original = orig;
        this.opt = opt;
        this.rep = rep;
        depth = 0;
        mutants = new HashSet<>();
    }

    public void mutate(){
        original.accept(this);
    }

    public boolean hasNext(){
        if(depth <= max && !mutants.contains(original.toString())){
            mutants.add(original.toString());
            return true;
        }
        return false;
    }

    public boolean forward(Exprn expr){
        if(SynthUtil.check(opt)){
            rep.fixed(opt);
            LOGGER.logInfo(this.getClass(), "repair found");
            LOGGER.logInfo(this.getClass(), "repaired expr: " + original);
            LOGGER.logInfo(this.getClass(), "repaired model:\n " + opt.model);
            LOGGER.logInfo(this.getClass(), "finished in " + LOGGER.getTime() + "ms");
            LOGGER.logInfo(this.getClass(), "final_result@" + opt.path + "@" + original + "@" + LOGGER.getTime() + "@" + "M");

            System.out.println(opt.path + "@" + original + "@" + LOGGER.getTime()/1000.0 + "@" + "M" + "@3");
            System.exit(0);
            return true;
        }else{
            if(depth < max){
                if(!mutants.contains(original.toString())) {
                    mutants.add(original.toString());
                }
            }else {
                return false;
            }
        }
        return false;
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        UOM.mutate(this, expr);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        UOI.mutate(this, expr);
        UOM.mutate(this, expr);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        if(expr.op == ExprnBinaryBool.Op.IMPLIES){
            ICD.mutate(this, expr);
        }
       // if(SynthUtil.notSym(expr.op))
            BOE.mutate(this, expr);
        BOD.mutate(this, expr);
        BOM.mutate(this, expr);
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        BOD.mutate(this, expr);
        BOM.mutate(this, expr);
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnListBool expr) {
        LED.mutate(this, expr);
        LOM.mutate(this, expr);
        for(Exprn sub : expr.getArgs()){
            sub.accept(this);
        }

    }

    @Override
    public void visit(ExprnListRel expr) {
        LED.mutate(this, expr);
        LOM.mutate(this, expr);
        for(Exprn sub : expr.getArgs()){
            sub.accept(this);
        }
    }

    @Override
    public void visit(ExprnQtBool expr) {
        QOMT.mutate(this, expr);
        QDD.mutate(this, expr);
        QOR.mutate(this, expr);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        QOR.mutate(this, expr);
        expr.getSub().accept(this);
    }

    @Override
    public void visit(Fact fact) {
        FED.mutate(this, fact);
        fact.getExpr().accept(this);
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
    public void visit(Predicate pred) {

    }

    @Override
    public void visit(Function func) {

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
        if(expr.getType().arity() == 2)
            UOI.mutate(this, expr);
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
    public void visit(ExprnSig expr) {

    }

    @Override
    public void visit(ExprnVar expr) {

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
