package synth.syntaxtemplates.template.hole;

import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Exprn;
import parser.ast.ExprnVar;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public abstract class Hole extends Exprn {
    Type holeType;

    Sig first;
    Sig last;

    int arity;

    public String value;

    List<String> values;

    public boolean is_exprn;
    public List<Exprn> exprns;
    Exprn exprn;

    boolean isval;
    ExprnVar fixedVal;

    public boolean is_atom;
    public ExprnVar atom;

    public Hole() { }

    @Override
    public void toGenericString(StringBuilder sb){
        sb.append(this.holeType);
    }

    public Hole(Type holeType){
        this.type = holeType;
        this.holeType = holeType;
        if(holeType.size() == 0)
        {
            first = null;
            last = null;
            arity = 0;
        }      else {
            first = holeType.getFirst();
            last = holeType.getLast();
            arity = holeType.arity();
        }
        is_atom = false;
    }

    public void setExprn(Exprn exprn){
        is_exprn = true;
        this.exprn = exprn;
    }

    public void setExprns(List<Exprn> exprns){
        is_exprn = true;
        this.exprns = new ArrayList<>(exprns);
    }

    public void setValue(String v){
        value = v;
    }

    @Override
    public Type getType(){
        return holeType;
    }

    public void setValues(Set<String> v){
        values = new ArrayList<>(v);
    }

    public List<String> getValues(){
        return values;
    }
}
