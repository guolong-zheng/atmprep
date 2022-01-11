package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import utility.StringUtil;

import java.util.List;
import java.util.stream.Collectors;

/* The definition of a sig. [abstract] [mult] sig name { fields } { facts }*/
public class SigDef extends Node {

    /* mult:
     *   one
     *   some
     *   lone
     *   ''
    */
    protected MULT mult;

    // abstract sig
    protected boolean isAbstract;

    // sig does not extends other sig
    protected boolean isTopLevel;

    // subset sig that extends other sig
    protected boolean isSubSig;

    // name of the sig
    protected String name;

    // fields
    protected List<DeclField> fields;

    // sig fact
    protected List<Exprn> facts;

    // parent sig name
    protected String parentSig;

    protected Type type;

    /*
    // parent sig this sig extends
    protected SigDef parentSig;

    // sigs extends this sig
    protected List<SigDef> descendent;
    */
    public SigDef(Node parent, Sig sig) {
        super(parent, sig);
        this.mult = this.convert(sig);
        this.isAbstract = sig.isAbstract != null;
        this.isTopLevel = sig.isTopLevel();
        if (!this.isTopLevel) {
            this.isSubSig = sig.isSubsig != null;
            if (this.isSubSig) {
                this.parentSig = ((Sig.PrimSig) sig).parent.label;
            } else {
                this.parentSig = ((Sig.SubsetSig) sig).parents.get(0).label;
            }
        }
        this.name = StringUtil.removeThis(sig.label);

        this.fields = (List) sig.getFieldDecls().makeConstList().stream().map(field -> {
            return new DeclField(this, field);
        }).collect(Collectors.toList());

        this.facts = sig.getFacts().makeConstList().stream().map(fact -> {
            return Exprn.parseExpr(this, fact);
        }).collect(Collectors.toList());

        this.children.addAll(this.facts);
        this.children.addAll(this.facts);
        this.type = sig.type();

        this.nodeMap.put(name, this);
    }

    public MULT convert(Sig sig) {
        if (sig.isOne != null)
            return MULT.ONE;
        else if (sig.isLone != null)
            return MULT.LONE;
        else if (sig.isSome != null)
            return MULT.SOME;
        else
            return MULT.SET;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb) {
        if(isAbstract)
            sb.append("abstract ");
        sb.append(mult.toString());
        sb.append("sig " + name);
        if(parentSig != null)
            sb.append(" extends "  + StringUtil.removeThis(parentSig));
        sb.append(" {\n");
        for(int i = 0; i < fields.size(); i++){
            if(i > 0)
                sb.append(",\n");
            fields.get(i).toString(sb);
        }
        sb.append("\n}\n");
        facts.stream().forEach(fact -> fact.toString());
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    public static enum MULT {
        LONE("lone"),
        ONE("one"),
        SOME("some"),
        SET("");

        private final String label;

        private MULT(String label) {
            this.label = label;
        }

        public String getLabel() {
            return this.label;
        }

        public String toString(){
            switch(this){
                case SET:
                    return "";
                default:
                    return this.label + " ";
            }
        }

    }

    public MULT getMult() {
        return mult;
    }

    public void setMult(MULT mult) {
        this.mult = mult;
    }

    public boolean isAbstract() {
        return isAbstract;
    }

    public void setAbstract(boolean anAbstract) {
        isAbstract = anAbstract;
    }

    public boolean isTopLevel() {
        return isTopLevel;
    }

    public void setTopLevel(boolean topLevel) {
        isTopLevel = topLevel;
    }

    public boolean isSubSig() {
        return isSubSig;
    }

    public void setSubSig(boolean subSig) {
        isSubSig = subSig;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<DeclField> getFields() {
        return fields;
    }

    public void setFields(List<DeclField> fields) {
        this.fields = fields;
    }

    public List<Exprn> getFacts() {
        return facts;
    }

    public void setFacts(List<Exprn> facts) {
        this.facts = facts;
    }

    public String getParentSig() {
        return parentSig;
    }

    public void setParentSig(String parentSig) {
        this.parentSig = parentSig;
    }

    public Type getType() {return type;}
}
