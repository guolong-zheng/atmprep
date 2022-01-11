package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;

import java.util.List;

/* open filename as alias */
public class Opens extends Node {

    /* The alias for this open declaration. */
    protected String alias;

    /* The instantiating arguments. */
    protected List<String> args;

    /* The imported module name. */
    protected String filename;

    AModel model;

    public Opens(Node parent, CompModule.Open open) {
        super(parent, open);
        this.alias = open.alias;
        this.args = open.args;
        this.filename = open.filename;

        // TOFIX
        this.model = (AModel)parent;
        CompModule m = open.getRealModule();
        new AModel(this.model, m);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb) {
        sb.append("open " + filename + "\n");
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public List<String> getArgs() {
        return args;
    }

    public void setArgs(List<String> args) {
        this.args = args;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
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
