package parser.visitor;

import parser.ast.*;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Binder implements GenericVisitor<Set<String>, Map<String, Exprn>>{
    
    Set<String> predNames;

    Set<String> skolems;

    Map<Exprn, String> instantiatedexpr;

    public Binder(Set<String> predNames){
        this.predNames = predNames;
    }
    
    @Override
    public Set<String> visit(AModel model, Map<String, Exprn> arg) {
        model.getFacts().stream().forEach(fact -> fact.accept(this, arg));

        model.getPredicates().stream().filter(pred -> this.predNames.contains(pred.getName())).forEach(predicate ->
                predicate.accept(this, arg)
        );

        return null;
    }

    @Override
    public Set<String> visit(Assert asserts, Map<String, Exprn> arg) {
        return null;
    }

    @Override
    public Set<String> visit(Opens open, Map<String, Exprn> arg) {
        return null;
    }

    @Override
    public Set<String> visit(SigDef sigDef, Map<String, Exprn> arg) {
        return null;
    }

    @Override
    public Set<String> visit(DeclField decl, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        decl.getNames().forEach(name -> {
            if (arg != null)
                // collect binding info
                ((Map<String, Exprn>) arg).put(name.toString(), decl.getExpr());
            res.addAll((Set) name.accept(this, arg));
        });
        res.addAll((Set) decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(DeclParam decl, Map<String, Exprn> arg) {

        Set<String> res = new HashSet<>();
        decl.getNames().forEach(name ->
        {
            if (arg != null)
                // collect binding info
                ((Map<String, Exprn>) arg).put(name.toString(), decl.getExpr());
            res.addAll((Set) name.accept(this, arg));
        });
        res.addAll((Set) decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(DeclVar decl, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        decl.getNames().forEach(name -> {
            if (arg != null) {
                // collect binding info
                ((Map<String, Exprn>) arg).put(name.toString(), decl.getExpr());
            }
            res.addAll((Set) name.accept(this, arg));
        });
        res.addAll((Set) decl.getExpr().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(Fact fact, Map<String, Exprn> arg) {
        fact.getExpr().accept(this, arg);
        return null;
    }

    @Override
    public Set<String> visit(Predicate pred, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        pred.getParams().forEach(declParam -> res.addAll((Set) declParam.accept(this, arg)));
        res.addAll((Set) pred.getBody().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(Function func, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        func.getParams().forEach(param -> param.accept(this, arg));
        res.addAll((Set) func.getBody().accept(this, arg));
        func.getReturnExpr().accept(this, arg);
        return res;
    }

    @Override
    public Set<String> visit(Template t, Map<String, Exprn> arg) {
        return null;
    }

    @Override
    public Set<String> visit(Hole h, Map<String, Exprn> arg) {
        return null;
    }

    @Override
    public Set<String> visit(ExprnBinaryBool expr, Map<String, Exprn> arg) {
        Set<String> words = new HashSet<>();
        Exprn left = expr.getLeft();
        Exprn right = expr.getRight();
        words.addAll((Set<String>) left.accept(this, arg));
        words.addAll((Set<String>) right.accept(this, arg));
       // node2keyword.put(expr, words);
        return words;
    }

    @Override
    public Set<String> visit(ExprnBinaryRel expr, Map<String, Exprn> arg) {
        Set<String> words = new HashSet<>();
        Exprn left = expr.getLeft();
        Exprn right = expr.getRight();
        words.addAll((Set<String>) left.accept(this, arg));
        words.addAll((Set<String>) right.accept(this, arg));
       // node2keyword.put(expr, words);
        return words;
    }

    @Override
    public Set<String> visit(ExprnCallBool expr, Map<String, Exprn> arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        Predicate pred = (Predicate) expr.getNodeMap().findFunc(fname);
        return pred.accept(this, arg);
    }

    @Override
    public Set<String> visit(ExprnCallRel expr, Map<String, Exprn> arg) {
        expr.getArgs().forEach(var -> var.accept(this, arg));
        String fname = StringUtil.removeThis(expr.getName());
        if (fname.startsWith("integer")) {
            return new HashSet<>();
        }
        Function fun = (Function) expr.getNodeMap().findFunc(fname);
        return fun.accept(this, arg);
    }

    @Override
    public Set<String> visit(ExprnConst expr, Map<String, Exprn> arg) {

        Set<String> res = new HashSet<>();
        res.add(expr.getOp().toString());
        return res;
    }

    @Override
    public Set<String> visit(ExprnField expr, Map<String, Exprn> arg) {

        Set<String> res = new HashSet<>();
        res.add(expr.getName());
        return res;
    }

    @Override
    public Set<String> visit(ExprnITEBool expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        res.addAll((Set) expr.getCondition().accept(this, arg));
        res.addAll((Set) expr.getThenClause().accept(this, arg));
        res.addAll((Set) expr.getElseClause().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(ExprnITERel expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        res.addAll((Set) expr.getCondition().accept(this, arg));
        res.addAll((Set) expr.getThenClause().accept(this, arg));
        res.addAll((Set) expr.getElseClause().accept(this, arg));
        return res;
    }

    @Override
    public Set<String> visit(ExprnLet expr, Map<String, Exprn> arg) {
        expr.getVar().accept(this, arg);
        expr.getExpr().accept(this, arg);
        expr.getSub().accept(this, arg);
        return null;
    }

    @Override
    public Set<String> visit(ExprnListBool expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        expr.getArgs().forEach(ag -> {
            res.addAll((Set) ag.accept(this, arg));
        });
        return res;
    }

    @Override
    public Set<String> visit(ExprnListRel expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        expr.getArgs().forEach(ag -> {
            res.addAll((Set) ag.accept(this, arg));
        });
        return res;
    }

    @Override
    public Set<String> visit(ExprnQtBool expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        // when decl a var, collect the expr it binds to
        Map<String, Exprn> var2expr;
        if( arg == null)
            var2expr = new HashMap<>();
        else
            var2expr = new HashMap<>((Map)arg);
        expr.getVars().forEach(var -> {
            res.addAll((Set) var.accept(this, var2expr));
        });
        res.addAll((Set) expr.getSub().accept(this, var2expr));
       // node2keyword.put(expr, res);
        return res;
    }

    @Override
    public Set<String> visit(ExprnQtRel expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        // when decl a var, collect the expr it binds to
        Map<String, Exprn> var2expr;
        if( arg == null)
            var2expr = new HashMap<>();
        else
            var2expr = new HashMap<>((Map)arg);
        expr.getVars().forEach(var -> {
            res.addAll((Set) var.accept(this, var2expr));
        });
        //expr.getVars().forEach(var -> res.addAll((Set)var.accept(this, arg)));
        res.addAll((Set) expr.getSub().accept(this, var2expr));
     //   node2keyword.put(expr, res);
        return res;
    }


    @Override
    public Set<String> visit(ExprnSig expr, Map<String, Exprn> arg) {
        // ask
        Set<String> res = new HashSet<>();
        res.add(expr.getName());
        // node2keywrod.put(expr, res);  // no need to add single var
        return res;
    }

    @Override
    public Set<String> visit(ExprnVar expr, Map<String, Exprn> arg) {
        if(arg != null)
            expr.setBindExpr(  ((Map<String, Exprn>)arg).get(expr.toString()) );
        Set<String> res = new HashSet<>();
        String type = expr.getType().toString();
        type = StringUtil.trimTypeStr(type);
        res.add(type);
        // node2keywrod.put(expr, res);  //no need to add single var
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Set<String> visit(ExprnUnaryBool expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        Exprn sub = expr.getSub();
        res.addAll((Set) sub.accept(this, arg));
       // node2keyword.put(expr, res);
        return res;
    }

    /*
    * TODO
    * */
    @Override
    public Set<String> visit(ExprnUnaryRel expr, Map<String, Exprn> arg) {
        Set<String> res = new HashSet<>();
        Exprn sub = expr.getSub();
        res.addAll((Set) sub.accept(this, arg));
       // node2keyword.put(expr, res);
        return res;
    }
}
