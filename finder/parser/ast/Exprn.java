package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.*;
import synth.syntaxtemplates.structures.QtReplaceTemplate;
import synth.syntaxtemplates.structures.Template;

import java.util.Map;
import java.util.Set;

// each expression needs to contain information of the sig names or relation names it uses, can be collected using a
// visitor; break down to atom expressions that are connected by AND or IMPLIES or OR or other operators(?)

public abstract class Exprn extends Node {

    /**
     * Only for expression that returns boolean value;
     * True if this expression cannot be break down into smaller part;
     * For example, (a && b).atomic = false; a.atomic = true;
     * TODO: consider other boolean operators: or(||) , not(!), implies(=>), iff(<=>)
     */
    public boolean atomic;

    /* Type of the expression:
    *   (1) boolean, see ExprBool
    *   (2) relation, see ExprRel
     *  Distinguished by operator and 'return' value
    * */
    public Type type;

    boolean isHole;

    public boolean hasDeclVar;

    public Exprn(Node parent, Expr expr) {
        super(parent, expr);
        this.type = expr.type();
        this.atomic = false;
        this.isHole = false;
    }

    // construct expression for purpos of mutation
    public Exprn(Node parent){
        super(parent);
        this.type = Type.smallIntType();
        this.atomic = true;
        this.isHole = false;
    }

    public Exprn(){

    }

    public Exprn(Node parent, Expr expr, Boolean atomic){
        super(parent, expr);
        this.type = expr.type();
        this.atomic = atomic;
    }

    public static Exprn parseExpr(Node parent, Expr expr) {
        if (expr instanceof ExprUnary) {
            ExprUnary exprUnary = (ExprUnary) expr;
            switch (exprUnary.op) {
                case CAST2INT:
                case CAST2SIGINT:
                case NOOP:
                    return parseExpr(parent, exprUnary.sub);
                case NOT:
                case NO:
                case SOME:
                case LONE:
                case ONE:
                    return new ExprnUnaryBool(parent, exprUnary);
                default:
                    return new ExprnUnaryRel(parent, exprUnary);
            }
        } else if (expr instanceof ExprBinary) {
            ExprBinary exprBinary = (ExprBinary) expr;
            switch (exprBinary.op) {
                case EQUALS:
                case NOT_EQUALS:
                case IMPLIES:
                case LT:
                case LTE:
                case GT:
                case GTE:
                case NOT_LT:
                case NOT_LTE:
                case NOT_GT:
                case NOT_GTE:
                case SHL:
                case SHA:
                case SHR:
                case IN:
                case NOT_IN:
                case AND:
                case OR:
                case IFF:
                    return new ExprnBinaryBool(parent, exprBinary);
                default:
                    if(((ExprBinary) expr).left.toString().equals("this"))
                        return parseExpr(parent, ((ExprBinary) expr).right);
                    return new ExprnBinaryRel(parent, exprBinary);
            }
        } else if (expr instanceof Sig) {
            return new ExprnSig(parent, (Sig) expr);
        } else if (expr instanceof Sig.Field) {
            return new ExprnField(parent, (Sig.Field) expr);
        } else if (expr instanceof ExprList) {
            ExprList exprList = (ExprList) expr;
            switch (exprList.op) {
                case AND:
                case OR:
                    return new ExprnListBool(parent, exprList);
                default:
                    return new ExprnListRel(parent, exprList);
            }
        } else if (expr instanceof ExprCall) {
            ExprCall exprCall = (ExprCall) expr;
            return exprCall.fun.isPred ? new ExprnCallBool(parent, exprCall) :
                    new ExprnCallRel(parent, exprCall);
        } else if (expr instanceof ExprVar) {
            return new ExprnVar(parent, (ExprVar) expr);
        } else if (expr instanceof ExprQt) {
            ExprQt exprQt = (ExprQt) expr;
            switch (exprQt.op) {
                case SUM:
                case COMPREHENSION:
                    return new ExprnQtRel(parent, exprQt);
                default:
                    return new ExprnQtBool(parent, exprQt);
            }
        } else if (expr instanceof ExprITE) {
            ExprITE exprITE = (ExprITE) expr;
            return exprITE.type().is_bool ? new ExprnITEBool(parent, exprITE) :
                    new ExprnITERel(parent, exprITE);
        } else if (expr instanceof ExprLet) {
            return new ExprnLet(parent, (ExprLet) expr);
        } else if (expr instanceof ExprConstant) {
            return new ExprnConst(parent, (ExprConstant) expr);
        } else {
            //LOGGER.logFatal(this.getClass(), "unspported");
            return null;
        }
    }

    /* parse an expr with unsat core, if the expr has the same pos with core then ignore it */
    public static Exprn parseExpr(Node parent, Expr expr, Set<Object> core) {
        if( core.contains( expr )){
            return null;
        }
        if (expr instanceof ExprUnary) {
            ExprUnary exprUnary = (ExprUnary) expr;
            switch (exprUnary.op) {
                case CAST2INT:
                case CAST2SIGINT:
                case NOOP:
                    return parseExpr(parent, exprUnary.sub, core);
                case NOT:
                case NO:
                case SOME:
                case LONE:
                case ONE:
                    return new ExprnUnaryBool(parent, exprUnary);
                default:
                    return new ExprnUnaryRel(parent, exprUnary);
            }
        } else if (expr instanceof ExprBinary) {
            ExprBinary exprBinary = (ExprBinary) expr;
            switch (exprBinary.op) {
                case EQUALS:
                case NOT_EQUALS:
                case IMPLIES:
                case LT:
                case LTE:
                case GT:
                case GTE:
                case NOT_LT:
                case NOT_LTE:
                case NOT_GT:
                case NOT_GTE:
                case SHL:
                case SHA:
                case SHR:
                case IN:
                case NOT_IN:
                case AND:
                case OR:
                case IFF:
                    if(core.contains( exprBinary.left) && core.contains(exprBinary.right)) {
                        return null;
                    }else if(core.contains(exprBinary.left)) {
                        return parseExpr(parent, exprBinary.right);
                    }
                    else if(core.contains(exprBinary.right))
                        return parseExpr(parent, exprBinary.left);

                    return new ExprnBinaryBool(parent, exprBinary);
                default:
                    return new ExprnBinaryRel(parent, exprBinary);
            }
        } else if (expr instanceof Sig) {
            return new ExprnSig(parent, (Sig) expr);
        } else if (expr instanceof Sig.Field) {
            return new ExprnField(parent, (Sig.Field) expr);
        } else if (expr instanceof ExprList) {
            ExprList exprList = (ExprList) expr;
            switch (exprList.op) {
                case AND:
                case OR:
                    return new ExprnListBool(parent, exprList, core);
                default:
                    return new ExprnListRel(parent, exprList, core);
            }
        } else if (expr instanceof ExprCall) {
            ExprCall exprCall = (ExprCall) expr;
            return exprCall.fun.isPred ? new ExprnCallBool(parent, exprCall) :
                    new ExprnCallRel(parent, exprCall);
        } else if (expr instanceof ExprVar) {
            return new ExprnVar(parent, (ExprVar) expr);
        } else if (expr instanceof ExprQt) {
            ExprQt exprQt = (ExprQt) expr;
            switch (exprQt.op) {
                case SUM:
                case COMPREHENSION:
                    return new ExprnQtRel(parent, exprQt);
                default:
                    return new ExprnQtBool(parent, exprQt);
            }
        } else if (expr instanceof ExprITE) {
            ExprITE exprITE = (ExprITE) expr;
            return exprITE.type().is_bool ? new ExprnITEBool(parent, exprITE) :
                    new ExprnITERel(parent, exprITE);
        } else if (expr instanceof ExprLet) {
            return new ExprnLet(parent, (ExprLet) expr);
        } else if (expr instanceof ExprConstant) {
            return new ExprnConst(parent, (ExprConstant) expr);
        } else {
           // LOGGER.log("unspported");
            return null;
        }
    }

    public void toGenericString(StringBuilder sb){

    }

    public abstract String getInstantiatedString(Map<String, String> name2val);

    public abstract void toString(StringBuilder sb);

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public abstract void toTemplateString(Template t, String value, StringBuilder sb);

    public abstract void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb);

//    @Override
//    public int hashCode(){
//        StringBuilder sb = new StringBuilder();
//        toString(sb);
//        return sb.toString().hashCode();
//    }
}
