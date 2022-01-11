package synth.varcollectors;

import parser.ast.Exprn;
import parser.visitor.VoidVisitorWrapper;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;

import java.util.ArrayList;
import java.util.List;

public class HoleCollector extends VoidVisitorWrapper {
    List<Hole> holes;

    public HoleCollector(){
    }

    public List<Hole> collect(Exprn exprn){
        holes = new ArrayList<>();
        exprn.accept(this);
        return holes;
    }

    @Override
    public void visit(VarHole hole){
        holes.add(hole);
    }

    @Override
    public void visit(ValueHole hole){
        holes.add(hole);
    }
}
