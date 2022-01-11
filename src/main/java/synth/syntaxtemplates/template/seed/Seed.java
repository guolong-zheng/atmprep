package synth.syntaxtemplates.template.seed;

import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Exprn;
import parser.ast.ExprnBinaryBool;
import parser.ast.ExprnUnaryBool;
import synth.SolutionPair;
import synth.syntaxtemplates.structures.BinaryTemplate;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.structures.UnaryTemplate;
import synth.syntaxtemplates.template.hole.Hole;

import java.util.ArrayList;
import java.util.List;

public class Seed {
    public SolutionPair solutions;
    public Exprn exprn;
    public List<Hole> holes;
    public Type type;
    public boolean isAtom = false;

    public Seed(Exprn exprn, Hole hole, SolutionPair sol){
        this.exprn = exprn;
        this.holes = new ArrayList<>();
        holes.add(hole);
        this.solutions = sol;
    }

    // construct seed for a single atom
    public Seed(Exprn exprn, Hole hole, Type type, SolutionPair sol){
        this.exprn = exprn;
        this.holes = new ArrayList<>();
        holes.add(hole);
        this.type = type;
        this.solutions = sol;
    }

    // construct seed for a single atom
    public Seed(Exprn exprn, Hole hole, Type type, boolean isAtom, SolutionPair sol){
        this.exprn = exprn;
        this.holes = new ArrayList<>();
        holes.add(hole);
        this.type = type;
        this.isAtom = isAtom;
        this.solutions = sol;
    }

    public Seed(Exprn exprn, Hole hole1, Hole hole2, Type type, SolutionPair sol){
        this.exprn = exprn;
        this.holes = new ArrayList<>();
        holes.add(hole1);
        holes.add(hole2);
        this.type = type;
        this.solutions = sol;
    }

    public Seed(Exprn exprn, List<Hole> holes, SolutionPair sol){
        this.exprn = exprn;
        this.holes = new ArrayList<>();
        this.holes.addAll(holes);
        this.solutions = sol;
    }

    public Template toTemplate(Exprn orig){
        if(exprn instanceof ExprnUnaryBool){
            UnaryTemplate ut = new UnaryTemplate(orig, exprn, ((ExprnUnaryBool) exprn).op, null, holes, false);
            return ut;
        }else if(exprn instanceof ExprnBinaryBool){
            BinaryTemplate bt = new BinaryTemplate(orig, exprn, ((ExprnBinaryBool) exprn).op, null);
            return bt;
        }else{
            try {
                throw new Exception("unsupported expression type");
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }
    }
}