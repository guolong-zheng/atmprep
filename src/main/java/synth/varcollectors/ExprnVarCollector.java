package synth.varcollectors;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprUnary;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import parser.visitor.VoidVisitorWrapper;
import util.CollectSigNfield;

import java.util.*;
import java.util.stream.Collectors;

public class ExprnVarCollector extends VoidVisitorWrapper {
    Exprn target; // target expression
    Map<String, Type> declvars;
    Map<String, Type> usedvars;
    public Set<Var> livevars;
    public ArrayList<Declaration> decls;
    Set<Node> parents;
    boolean intarget;

    public ExprnVarCollector(Exprn target) {
        this.target = target;
        declvars = new HashMap<>();
        livevars = new HashSet<>();
        usedvars = new HashMap<>();
        parents = new HashSet<>();
        decls = new ArrayList<>();
    }

    public ExprnVarCollector(Exprn target, AModel model){
        this.target = target;
        declvars = CollectSigNfield.collect(model);
        livevars = new HashSet<>();
        usedvars = new HashMap<>();
        parents = new HashSet<>();
        decls = new ArrayList<>();
    }

    public Set<Var> collect() {
        parents.add(target);
        Node parent = target.parent;
        if(parent == null)
            target.accept(this);
        else {
            while (parent instanceof Exprn) {
                parents.add(parent);
                parent = parent.parent;
            }
            parent.accept(this);
        }
        usedvars.forEach((s,t) -> livevars.add(new Var(s, t)));
        declvars.forEach((s,t) -> livevars.add(new Var(s, t)));
        return livevars;
    }

    public Set<Var> collectDeclVars(){
        this.collect();
        return declvars.keySet().stream().map(s -> new Var(s, declvars.get(s))).collect(Collectors.toSet());
    }

    @Override
    public void visit(Fact fact) {
        fact.getExpr().accept(this);
    }

    @Override
    public void visit(Predicate pred) {
        pred.getParams().forEach(decl -> decl.accept(this));
        pred.getBody().accept(this);
    }

    @Override
    public void visit(Function func) {
        func.getParams().forEach(decl -> decl.accept(this));
        func.getBody().accept(this);
    }

    @Override
    public void visit(DeclParam decl){
        decls.add(decl);
        Type type = decl.getExpr().getType();
        decl.getNames().forEach(name -> {
                declvars.put(name.toString(), type); }
        );
    }

    @Override
    public void visit(DeclVar decl){
        decls.add(decl);
        ExprUnary eu = (ExprUnary)decl.getExpr().getAlloyNode();
        Type type = decl.getExpr().getType();
        decl.getNames().forEach(name ->
                declvars.put(name.toString(), type)
        );
    }

    @Override
    public void visit(DeclField decl){
        decls.add(decl);
        Type type = decl.getExpr().getType();
        decl.getNames().forEach(name ->
                declvars.put(name.toString(), type)
        );
    }

    @Override
    public void visit(ExprnBinaryBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnBinaryRel expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }

    @Override
    public void visit(ExprnCallBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getArgs().forEach(arg -> arg.accept(this));
//        expr.getFunc().accept(this);
    }

    @Override
    public void visit(ExprnCallRel expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getArgs().forEach(arg -> arg.accept(this));
//        expr.getFunc().accept(this);
    }

    // TODO: deal with const
    @Override
    public void visit(ExprnConst expr) {
        if(declvars.containsKey(expr.toString())){
            usedvars.put(expr.toString(), declvars.get(expr.toString()));
        }
    }

    @Override
    public void visit(ExprnField expr) {
        if(declvars.containsKey(expr.toString())){
            usedvars.put(expr.toString(), declvars.get(expr.toString()));
        }
    }

    @Override
    public void visit(ExprnSig expr) {
        if(declvars.containsKey(expr.toString())){
            usedvars.put(expr.toString(), declvars.get(expr.toString()));
        }
    }

    @Override
    public void visit(ExprnVar expr) {
        if(declvars.containsKey(expr.toString())){
            usedvars.put(expr.toString(), declvars.get(expr.toString()));
        }
    }

    @Override
    public void visit(ExprnITEBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    @Override
    public void visit(ExprnITERel expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getCondition().accept(this);
        expr.getThenClause().accept(this);
        expr.getElseClause().accept(this);
    }

    @Override
    public void visit(ExprnLet expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        declvars.put(expr.getVar().toString(), expr.getSub().getType());
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnListBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getArgs().forEach(arg -> arg.accept(this));
    }

    @Override
    public void visit(ExprnListRel expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getArgs().forEach(arg -> arg.accept(this));
    }

    @Override
    public void visit(ExprnQtBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getVars().forEach(var -> var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnQtRel expr) {
        if(!parents.contains(expr))
            return;
        expr.getVars().forEach(var -> var.accept(this));
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryBool expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getSub().accept(this);
    }

    @Override
    public void visit(ExprnUnaryRel expr) {
        if(expr == target)
            intarget = true;
        if(!parents.contains(expr) && !intarget)
            return;
        expr.getSub().accept(this);
    }
}
