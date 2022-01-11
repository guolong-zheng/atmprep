package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.ExprCall;
import synth.syntaxtemplates.structures.Template;
import utility.StringUtil;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public abstract class ExprnCall extends Exprn {

    String name;

    Function func;

    List<Exprn> args;

    public ExprnCall(Node parent, ExprCall expr) {
        super(parent, expr);
        this.name = expr.fun.label;
        this.args = expr.args.stream().map(arg -> {
            return Exprn.parseExpr(this, arg);
        }).collect(Collectors.toList());
    }

    public ExprnCall(Node parent, String name, List<Exprn> args){
        super(parent);
        if(name.trim().equals("-")){
            this.name = "integer/minus";
        }else if(name.trim().equals("+")){
            this.name = "integer/plus";
        }else if(name.trim().equals("*")) {
            this.name = "integer/mul";
        }else{
            this.name = "";
        }
        this.args = args;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append(StringUtil.removeThis(name) + "[");
        int i = 0;
        for( Exprn arg : args ) {
            arg.toString(sb);
            if (i < args.size() - 1) {
                sb.append(",");
                i++;
            }
        }
        sb.append("]");
    }

    public void toTemplateString(Template t, Exprn e, String value, StringBuilder sb) {
        sb.append(StringUtil.removeThis(name) + "[");
        int i = 0;
        for( Exprn arg : args ) {
            arg.toString(sb);
            if (i < args.size() - 1) {
                sb.append(",");
                i++;
            }
        }
        sb.append("]");
    }

//    @Override
//    public Set<String> getInstantiatedString(Map<String, Set<String>> name2val) {
//        Set<String> res = new HashSet<>();
//        StringBuilder sb = new StringBuilder();
//        sb.append(StringUtil.removeThis( name ) + "[");
//        List<List<String>> instArgs = new ArrayList<>();
//        for( Exprn arg : args ){
//            instArgs.add( new ArrayList<String>( arg.getInstantiatedString(name2val)) );
//        }
//        generatePermutations(instArgs, res, 0, StringUtil.removeThis( name ) + "[");
//        return res;
//    }
//
//    // used to generate all combs of args
//    void generatePermutations(List<List<String>> lists, Set<String> result, int depth, String current) {
//        if (depth == lists.size()) {
//            result.add(current + "]");
//            return;
//        }
//        for (int i = 0; i < lists.get(depth).size(); i++) {
//            generatePermutations(lists, result, depth + 1, current + "," + lists.get(depth).get(i));
//        }
//    }

    @Override
    public String getInstantiatedString(Map<String, String> sig2vals){
        StringBuilder sb = new StringBuilder();
        if(name.contains("order")){
            System.out.println();
        }
        sb.append(StringUtil.removeThis( name ) + "[");
        int i = 0;
        for( Exprn arg : args ){
            sb.append( arg.getInstantiatedString(sig2vals) );
            if( i < args.size() - 1 ) {
                sb.append(",");
                i++;
            }
        }
        // args.stream().forEach( arg -> arg.toString(sb));
        sb.append("]");
        return sb.toString();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Function getFunc() {
        return func;
    }

    public void setFunc(Function func) {
        this.func = func;
    }

    public List<Exprn> getArgs() {
        return args;
    }

    public void setArgs(List<Exprn> args) {
        this.args = args;
    }
}
