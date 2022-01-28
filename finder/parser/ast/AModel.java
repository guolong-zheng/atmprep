package parser.ast;

import edu.mit.csail.sdg.alloy4.ConstList;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.ast.Func;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.syntaxtemplates.structures.Template;

import java.util.*;
import java.util.stream.Collectors;

/* This class represents Alloy module under repair.
* */

public class AModel extends Node {

    /* 'module' */
    protected String modelName;

    /* 'open' */
    protected List<Opens> opens;

    /* 'sig' declarations */
    protected List<SigDef> sigDecls;

    /* 'fact' */
    protected List<Fact> facts;

    /* 'pred' */
    protected List<Predicate> predicates;

    /* 'func' */
    protected List<Function> functions;

    public Map<String, Function> name2func;

    /* 'assert' */
    protected List<Assert> asserts;

    /* 'run' or 'check' */
    protected List<Cmd> cmds;

    public CompModule origModel;

    public boolean containopen = false;
    public String opened;

    public AModel(CompModule compModule) {
        origModel = compModule;
        this.modelName = compModule.getModelName();
        this.sigDecls = parseSigs(compModule.getAllSigs().makeConstList());
        this.predicates = new ArrayList<>();
        this.functions = new ArrayList<>();
        this.name2func = new HashMap<>();
        for (Func func : compModule.getAllFunc()) {
            if (func.isPred) {
                this.predicates.add(new Predicate(this, func));
            } else {
                Function function = new Function(this, func);
                this.functions.add(function);
                this.name2func.put(function.getName(), function);
               // this.functions.add(new Function(this, func));
            }
        }
        this.facts = parseFacts(compModule.getAllFacts().makeConstList());
        this.cmds = parseCmds(compModule.getAllCommands());
        this.asserts = parseAsserts(compModule.getAllAssertions());

        this.opens = parseOpens(compModule.getOpens());
    }

    // TOFIX
    public AModel(AModel parent, CompModule compModule) {
        this.modelName = compModule.getModelName();
        parent.sigDecls = parseSigs(compModule.getAllSigs().makeConstList());
        // System.out.println("this: " + modelName);

        for (Func func : compModule.getAllFunc()) {
            if (func.isPred) {
                parent.predicates.add(new Predicate(this, func));
            } else {
                Function function = new Function(this, func);
                parent.functions.add(function);
                parent.name2func.put(function.getName(), function);
                // this.functions.add(new Function(this, func));
            }
        }
        parent.facts.addAll( parseFacts(compModule.getAllFacts().makeConstList()));
        this.cmds = parseCmds(compModule.getAllCommands());
        this.asserts = parseAsserts(compModule.getAllAssertions());
        this.opens = parseOpens(parent, compModule.getOpens());
    }

//    public AModel(CompModule compModule, Set<Pos> core){
//        this.modelName = compModule.getModelName();
//        this.opens = parseOpens(compModule.getOpens());
//        this.sigDecls = parseSigs(compModule.getAllSigs().makeConstList());
//        this.predicates = new ArrayList<>();
//        this.functions = new ArrayList<>();
//        //for(Pos p : core){
//         //   System.out.println(p.toString());
//        //}
//        for (Func func : compModule.getAllFunc()) {
//            if(core.contains( func.span() )) {
//                continue;
//            }
//            if (func.isPred) {
//                this.predicates.add(new Predicate(this, func));
//            } else
//                this.functions.add(new Function(this, func));
//        }
//        this.facts = parseFacts(compModule.getAllFacts().makeConstList(), core);
//        this.cmds = parseCmds(compModule.getAllCommands());
//        this.asserts = parseAsserts(compModule.getAllAssertions());
//    }

    public AModel(CompModule compModule, Set<Object> core){
        this.modelName = compModule.getModelName();
        this.opens = parseOpens(compModule.getOpens());
        this.sigDecls = parseSigs(compModule.getAllSigs().makeConstList());
        this.predicates = new ArrayList<>();
        this.functions = new ArrayList<>();
        for (Func func : compModule.getAllFunc()) {
            if(func.label.contains("repair")){
                this.predicates.add(new Predicate(this, func));
                continue;
            }
            if(core.contains(func.getBody()) ){
                continue;
            }
            if (func.isPred) {
                this.predicates.add(new Predicate(this, func, core));
            } else {
                this.functions.add(new Function(this, func));
            }
        }
        this.facts = parseFacts(compModule.getAllFacts().makeConstList(), core);
        this.cmds = parseCmds(compModule.getAllCommands());
        this.asserts = parseAsserts(compModule.getAllAssertions());
    }

    protected List<Opens> parseOpens(List<CompModule.Open> opens) {
        // TOFIX, remove filter
        List<Opens> tmp = new ArrayList<>();

        for(CompModule.Open open : opens){
            if( !open.filename.contains("util")){
                tmp.add( new Opens(this, open) );
            }

            // TODO: workaround for production ordering
            if(open.filename.contains("ordering")) {
                containopen = true;
                opened = "open util/ordering[Position]\n";
            }
        }
        return tmp;

//        return opens.stream().filter(open -> !(open.filename.contains("util"))).map(open -> {
//            return new Opens(this, open);
//        }).collect(Collectors.toList());
    }

    // TOFIX, better way to parse opened model
    protected List<Opens> parseOpens(AModel parent, List<CompModule.Open> opens) {
        List<Opens> tmp = new ArrayList<>();

        for(CompModule.Open open : opens){
            if( !open.filename.contains("util") || open.filename.contains("ordering")){
                tmp.add( new Opens(parent, open) );
            }
        }
        return tmp;

//        return opens.stream().filter(open -> !(open.filename.contains("util"))).map(open -> {
//            return new Opens(parent, open);
//        }).collect(Collectors.toList());
    }

    protected List<SigDef> parseSigs(List<Sig> allSigs) {
        return allSigs.stream().map(sig -> {
            return new SigDef(this, sig);
        }).collect(Collectors.toList());
    }

//    /* parse facts to remove unsatcore*/
//    protected List<Fact> parseFacts(ConstList<Pair<String, Expr>> allFacts, Set<Pos> core){
//        List<Fact> newFacts = new LinkedList<>();
//        for( Pair<String, Expr> f : allFacts){
//            Fact newF = new Fact(this, f, core);
//            if(newF.getExpr() != null)
//                newFacts.add(newF);
//        }
//        return newFacts;
//    }

    /* parse facts to remove unsatcore*/
    protected List<Fact> parseFacts(ConstList<Pair<String, Expr>> allFacts, Set<Object> core){
        List<Fact> newFacts = new LinkedList<>();
        for( Pair<String, Expr> f : allFacts){
            if( core.contains(f.b) ){
                continue;
            }
            Fact newF = new Fact(this, f, core);
            if(newF.getExpr() != null)
                newFacts.add(newF);
        }
        return newFacts;
    }

    protected List<Fact> parseFacts(ConstList<Pair<String, Expr>> allFacts) {
        return allFacts.stream().map(fact -> {
            return new Fact(this, fact);
        }).collect(Collectors.toList());
    }

    protected List<Cmd> parseCmds(List<Command> commands) {
        return commands.stream().map(command -> {
            return new Cmd(this, command);
        }).collect(Collectors.toList());
    }

    protected List<Assert> parseAsserts(List<Pair<String, Expr>> asserts) {
        return asserts.stream().map(p -> {
            return new Assert(this, p);
        }).collect(Collectors.toList());
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public List<Opens> getOpens() {
        return opens;
    }

    public void setOpens(List<Opens> opens) {
        this.opens = opens;
    }

    public List<SigDef> getSigDecls() {
        return sigDecls;
    }

    public void setSigDecls(List<SigDef> sigDecls) {
        this.sigDecls = sigDecls;
    }

    public List<Fact> getFacts() {
        return facts;
    }

    public void setFacts(List<Fact> facts) {
        this.facts = facts;
    }

    public List<Predicate> getPredicates() {
        return predicates;
    }

    public void setPredicates(List<Predicate> predicates) {
        this.predicates = predicates;
    }

    public List<Function> getFunctions() {
        return functions;
    }

    public void setFunctions(List<Function> functions) {
        this.functions = functions;
    }

    public List<Assert> getAsserts() {
        return asserts;
    }

    public void setAsserts(List<Assert> asserts) {
        this.asserts = asserts;
    }

    public List<Cmd> getCmds() {
        return cmds;
    }

    public void setCmds(List<Cmd> cmds) {
        this.cmds = cmds;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if(containopen)
            sb.append(opened);
        opens.stream().forEach(open -> open.toString(sb));
        sigDecls.stream().forEach(sigDef -> sigDef.toString(sb));
        facts.stream().forEach(fact -> fact.toString(sb));
        predicates.stream().forEach(predicate -> predicate.toString(sb));
        functions.stream().forEach(function -> function.toString(sb));
        asserts.stream().forEach(anAssert -> anAssert.toString(sb));
        cmds.stream().forEach(cmd -> cmd.toString(sb));
        return sb.toString();
    }

    @Override
    public void toString(StringBuilder sb) {
        if(containopen)
            sb.append(opened);
        opens.stream().forEach(open -> open.toString(sb));
        sigDecls.stream().forEach(sigDef -> sigDef.toString(sb));
        facts.stream().forEach(fact -> fact.toString(sb));
        predicates.stream().forEach(predicate -> predicate.toString(sb));
        functions.stream().forEach(function -> function.toString(sb));
        asserts.stream().forEach(anAssert -> anAssert.toString(sb));
        cmds.stream().forEach(cmd -> cmd.toString(sb));
    }

    public String toTemplateString(Template t, Exprn e, String value){
        StringBuilder sb = new StringBuilder();
        if(containopen)
            sb.append(opened);
        opens.stream().forEach(open -> open.toString(sb));
        sigDecls.stream().forEach(sigDef -> sigDef.toString(sb));
        facts.stream().forEach(fact -> fact.toTemplateString(t, value, sb));
        predicates.stream().forEach(predicate -> predicate.toTemplateString(t, value, sb));
        functions.stream().forEach(function -> function.toTemplateString(t, value, sb));
        asserts.stream().forEach(anAssert -> anAssert.toString(sb));
        cmds.stream().forEach(cmd -> cmd.toString(sb));
        return sb.toString();
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

}
