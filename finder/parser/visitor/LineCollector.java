package parser.visitor;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.*;

public class LineCollector implements GenericVisitor {
    Set<String> predNames;
    public Map<Node, List<String>> node2keywrod;
    public Map<Node, Type> node2type;


    public LineCollector(Set<String> predNames){
        this.predNames = predNames;
        this.node2keywrod = new HashMap<>();
        this.node2type = new HashMap<>();
    }

    public LineCollector() {
        this.node2keywrod = new HashMap<>();
        this.node2type = new HashMap<>();
    }

    @Override
    public Object visit(AModel model, Object arg) {
        model.getSigDecls().stream().forEach(sigDef -> sigDef.accept(this, arg));
        model.getFacts().stream().forEach(fact -> fact.accept(this, arg));
        model.getFunctions().stream().forEach(function -> function.accept(this, arg));
        if (predNames != null)
            // filter out those irrelevant preds
            model.getPredicates().stream().filter(pred -> this.predNames.contains(pred.getName())).forEach(predicate ->
                    predicate.accept(this, arg)
            );
        else
            model.getPredicates().stream().forEach(predicate -> {
                if (predicate.getName().contains("repair_"))
                    predicate.accept(this, arg);
            });
        return null;
    }

    @Override
    public Object visit(Assert asserts, Object arg) {
        return null;
    }

    @Override
    public Object visit(Opens open, Object arg) {
        return null;
    }

    @Override
    public Object visit(SigDef sigDef, Object arg) {
        sigDef.getFields().forEach(declField -> declField.accept(this, arg));
        sigDef.getFacts().forEach(fact -> fact.accept(this, arg));
        return null;
    }

    @Override
    public Object visit(DeclField decl, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        decl.getNames().forEach(name -> res.addAll((List)name.accept(this, arg)));
        res.addAll((List)decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(DeclParam decl, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        decl.getNames().forEach(name -> res.addAll((List)name.accept(this, arg)));
        res.addAll((List)decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(DeclVar decl, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        decl.getNames().forEach(name -> {
            res.addAll((List) name.accept(this, arg));
        });
        res.addAll((List)decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(Fact fact, Object arg) {
        fact.getExpr().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(Predicate pred, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        pred.getParams().forEach(declParam -> res.addAll((List)declParam.accept(this, arg)));
        res.addAll((List)pred.getBody().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(Function func, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        func.getParams().forEach(param -> param.accept(this, arg));
        res.addAll((List)func.getBody().accept(this, arg));
        func.getReturnExpr().accept(this, arg);
        return res;
    }

    @Override
    public Object visit(Template t, Object arg) {
        return null;
    }

    @Override
    public Object visit(Hole h, Object arg) {
        return null;
    }


    /*TODO: Collect */
    @Override
    public Object visit(ExprnBinaryBool expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        Exprn left = expr.getLeft();
        Exprn right = expr.getRight();
        res.addAll((List) left.accept(this, arg));
        res.addAll((List) right.accept(this, arg));
            node2keywrod.put(expr, res);
            return res;

    }

    /*TODO: Collect*/
    @Override
    public Object visit(ExprnBinaryRel expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        Exprn left = expr.getLeft();
        Exprn right = expr.getRight();
        List leftStr = (List) left.accept(this, arg);
        List rightStr = (List) right.accept(this, arg);
        switch(expr.getOp()){
            case JOIN:
                res.add(String.join(".", leftStr) + "." + String.join(".", rightStr));
                break;
            default:
                res.addAll(leftStr);
                res.addAll(rightStr);
        }
        node2keywrod.put(expr, res);
        return res;
    }

    @Override
    public Object visit(ExprnCallBool expr, Object arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        Predicate pred = (Predicate) expr.getNodeMap().findFunc(fname);
        return pred.accept(this, arg);
    }

    @Override
    public Object visit(ExprnCallRel expr, Object arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        if(fname.startsWith("integer")){
            return new LinkedList<>();
        }
        Function fun = (Function) expr.getNodeMap().findFunc(fname);
        return fun.accept(this, arg);
    }

    /*
    * TODO
    * */
    @Override
    public Object visit(ExprnConst expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.add(expr.getOp().toString());
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Object visit(ExprnField expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.add(expr.getName());
        return res;
    }

    @Override
    public Object visit(ExprnITEBool expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.addAll((List)expr.getCondition().accept(this, arg));
        res.addAll((List)expr.getThenClause().accept(this, arg));
        res.addAll((List)expr.getElseClause().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(ExprnITERel expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.addAll((List)expr.getCondition().accept(this, arg));
        res.addAll((List)expr.getThenClause().accept(this, arg));
        res.addAll((List)expr.getElseClause().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(ExprnLet expr, Object arg) {
        expr.getVar().accept(this, arg);
        expr.getExpr().accept(this, arg);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Object visit(ExprnListBool expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        expr.getArgs().forEach(ag -> {
            res.addAll((List)ag.accept(this, arg));});
        return res;
    }

    @Override
    public Object visit(ExprnListRel expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        expr.getArgs().forEach(ag -> {
            res.addAll((List)ag.accept(this, arg));});
        return res;
    }

    @Override
    public Object visit(ExprnQtBool expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        expr.getVars().forEach(var -> {
            res.addAll((List) var.accept(this, arg));
        });
        res.addAll((List)expr.getSub().accept(this, arg));
        return res;
    }

    @Override
    public Object visit(ExprnQtRel expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        expr.getVars().forEach(var -> res.addAll((List)var.accept(this, arg)));
        res.addAll((List)expr.getSub().accept(this, arg));
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Object visit(ExprnSig expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.add(expr.getName());
        // node2keywrod.put(expr, res);  // no need to add single var
        return res;
    }

    @Override
    public Object visit(ExprnVar expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        res.add(expr.getName());
        // node2keywrod.put(expr, res);  //no need to add single var
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Object visit(ExprnUnaryBool expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        Exprn sub = expr.getSub();
        res.addAll((List)sub.accept(this, arg));
        node2keywrod.put(expr, res);
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Object visit(ExprnUnaryRel expr, Object arg) {
        ArrayList<String> res = new ArrayList<>();
        Exprn sub = expr.getSub();
        res.addAll((List)sub.accept(this, arg));
        node2keywrod.put(expr, res);
        return res;
    }
}
