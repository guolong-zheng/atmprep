package parser.ast;

import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.CommandScope;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import utility.StringUtil;

/*
*  run name for scope expect
*  check name for scope expect
* */
public class Cmd extends Node {

    public String name;

    boolean check;

    String stringRep;

    int expects;

    public Cmd(Node parent, Command command) {
        super(parent);
        this.name = command.label;
        this.check = command.check;
        getStringRep(command);
        this.expects = command.expects;
        //this.nodeMap.put(name, this);
    }

    public boolean isAssert(){
        return check;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        toString(sb);
        return sb.toString();
    }

    public void toString(StringBuilder sb){
        sb.append(stringRep).append("\n");
    }

    public void getStringRep(Command command){
        if (command.parent != null) {
            Command p = command.parent;
            while (p.parent != null)
                p = p.parent;
            stringRep = p.toString();
        }
        boolean first = true;
        StringBuilder sb = new StringBuilder(check ? "check " : "run ").append(StringUtil.removeDollar(command.label));
        if (command.overall >= 0 && (command.bitwidth >= 0 || command.maxseq >= 0 || command.scope.size() > 0))
            sb.append(" for ").append(command.overall).append(" but");
        else if (command.overall >= 0)
            sb.append(" for ").append(command.overall);
        else if (command.bitwidth >= 0 || command.maxseq >= 0 || command.scope.size() > 0)
            sb.append(" for");
        if (command.bitwidth >= 0) {
            sb.append(" ").append(command.bitwidth).append(" int");
            first = false;
        }
        if (command.maxseq >= 0) {
            sb.append(first ? " " : ", ").append(command.maxseq).append(" seq");
            first = false;
        }
        for (CommandScope e : command.scope) {
            sb.append(first ? " " : ", ").append(e);
            first = false;
        }
        if (expects >= 0)
            sb.append(" expect ").append(expects);
        this.stringRep =  sb.toString();
    }

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return null;
    }

    @Override
    public void accept(VoidVisitor visitor) {
        return;
    }
}
