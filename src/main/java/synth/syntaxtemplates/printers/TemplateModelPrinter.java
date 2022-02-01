package synth.syntaxtemplates.printers;

import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import parser.ast.*;
import utility.StringUtil;

public class TemplateModelPrinter extends TemplateCommandPrinter {
    public TemplateModelPrinter(AModel md, Exprn fault) {
        super(md, fault);
    }

    public void print() {
        if(model.containopen)
            sb.append(model.opened);
        model.getOpens().stream().forEach(open -> open.toString(sb));
        model.getSigDecls().stream().forEach(sigDef -> sigDef.toString(sb));
        model.getFacts().stream().forEach(fact -> fact.accept(this));
        model.getPredicates().stream().forEach(predicate -> predicate.accept(this));
        model.getFunctions().stream().forEach(function -> function.accept(this));
        model.getAsserts().stream().forEach(anAssert -> anAssert.toString(sb));
        model.getCmds().stream().forEach(cmd -> cmd.toString(sb));
    }

    @Override
    public void visit(Fact fact) {
        sb.append("fact ").append(fact.getName()).append(" {\n");
        fact.expr.accept(this);
        sb.append("}\n");
    }

    @Override
    public void visit(Predicate pred) {
        sb.append("pred ").append(StringUtil.removeDollar(pred.getName()));
        if(pred.getParams().size() > 0)
            sb.append("[ ");
        for(int i = 0; i < pred.getParams().size(); i++){
            if(i > 0 && i <= pred.getParams().size() - 1){
                sb.append(",");
            }
            pred.getParams().get(i).toString(sb);
        }
        if(pred.getParams().size() > 0)
            sb.append("] ");
        sb.append("{\n");
        if(pred.getBody() == null)
            sb.append(" ");
        else if(pred.getBody().toString().equals("true")){
            if(pred.getBody() == target){
                sb = append;
            }
        }
        else if(!pred.getBody().toString().equals("true"))
            pred.getBody().accept(this);
        sb.append("}\n");
    }

    @Override
    public void visit(Function func) {
        if(func.getBody().toString().equals("true")){
            sb.append("\n");
            return;
        }
        sb.append("fun ").append(func.getName()).append(" [");
        for(int i = 0; i < func.getParams().size(); i++){
            if(i > 0 && i <= func.getParams().size() - 1){
                sb.append(",");
            }
            func.getParams().get(i).toString(sb);
        }
        sb.append("] : ");
        func.getReturnExpr().toString(sb);
        sb.append("{\n");
        if(func.getBody() !=null)
            func.getBody().accept(this);
        sb.append("}\n");
    }

    @Override
    public void visit(ExprnCallBool expr) {
        sb.append(StringUtil.removeThis(expr.getName()) + "[");
        int i = 0;
        for( Exprn arg : expr.getArgs() ) {
            arg.toString(sb);
            if (i < expr.getArgs().size() - 1) {
                sb.append(",");
                i++;
            }
        }
        sb.append("]");
    }

    @Override
    public void visit(ExprnCallRel expr) {
        sb.append(StringUtil.removeThis(expr.getName()) + "[");
        int i = 0;
        for( Exprn arg : expr.getArgs() ) {
            arg.toString(sb);
            if (i < expr.getArgs().size() - 1) {
                sb.append(",");
                i++;
            }
        }
        sb.append("]");
    }

}
