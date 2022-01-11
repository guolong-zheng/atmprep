package synth.varcollectors;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.ExprnVar;

public class Var {
    public String name;
    public Type type;

    public Var(String name, Type type) {
        this.name = name;
        this.type = type;
    }

    public ExprnVar toExprnVar(){
        return new ExprnVar(this);
    }

    @Override
    public String toString() {
        return name + ":" + type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }
}
