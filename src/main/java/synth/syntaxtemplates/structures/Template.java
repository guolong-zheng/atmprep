package synth.syntaxtemplates.structures;

import at.unisalzburg.dbresearch.apted.costmodel.StringUnitCostModel;
import at.unisalzburg.dbresearch.apted.distance.APTED;
import at.unisalzburg.dbresearch.apted.node.Node;
import at.unisalzburg.dbresearch.apted.node.StringNodeData;
import at.unisalzburg.dbresearch.apted.parser.BracketStringInputParser;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.Declaration;
import parser.ast.Exprn;
import parser.ast.ExprnQtBool;
import parser.ast.ExprnVar;
import parser.visitor.GenericVisitor;
import parser.visitor.VoidVisitor;
import synth.ASolution;
import synth.syntaxtemplates.printers.TemplateDistancePrinter;
import synth.syntaxtemplates.template.hole.Hole;

import java.util.*;

public class Template extends Exprn{
    public Exprn original;  // original exprn to be repaired
    String originalDistStr;
    public Exprn replacement; // new exprn to replace original
    List<ExprnVar> declVars; // because sigs and fields already included in expression generator
                            // no need to include them here
    public List<Declaration> decls;

    public List<Pair<ExprnQtBool.Op, List<Declaration>>> pre_decls;

    public List<Hole> holes;

    public List<Type> types;

    public ReturnType returnType;

    public boolean hasDeclVar;

    public int distance; // distance to original expression

    // cache result
    public Map<ASolution, Boolean> cachResult;

    public Map<Hole, Set<Exprn>> hole2exprns;

    public Map<Hole, List<Exprn>> hole2sortedexprns;

    public static int max = 2;  // max newly introudced decl vars

    public static int count = 0; // used to count distinct variable numbers, also can record # of templates

    public Template(){
        holes = new ArrayList<>();
        TemplateDistancePrinter dp = new TemplateDistancePrinter(this);
        hole2sortedexprns = new HashMap<>();
       // originalDistStr = dp.generateString();
    }

    public Template(boolean hasVar){
        holes = new ArrayList<>();
        hasDeclVar = hasVar;
        hole2sortedexprns = new HashMap<>();
 //       TemplateDistancePrinter dp = new TemplateDistancePrinter(this);
//        originalDistStr = dp.generateString();
    }

    @Override
    public void toString(StringBuilder sb) {}

    @Override
    public void toTemplateString(Template t, String value, StringBuilder sb) {}

    @Override
    public void toQtTemplateString(QtReplaceTemplate t, String value, StringBuilder sb) {}

    @Override
    public <R, V> R accept(GenericVisitor<R, V> visitor, V arg) {
        return visitor.visit(this, arg);
    }

    @Override
    public void accept(VoidVisitor visitor) {
        visitor.visit(this);
    }

    @Override
    public String getInstantiatedString(Map<String, String> name2val) {
        return null;
    }

    public enum ReturnType {
        BOOL,
        INT,
        STR
    }

    public int calDistance(){
        TemplateDistancePrinter dp = new TemplateDistancePrinter(this);
        BracketStringInputParser parser = new BracketStringInputParser();

        originalDistStr = dp.generateString(original);
        System.out.println("original str: " + originalDistStr);

        Node<StringNodeData> t1 = parser.fromString(originalDistStr);
        System.out.println("distance str: " + dp.generateString(replacement));
        Node<StringNodeData> t2 = parser.fromString(dp.generateString(replacement));

        APTED<StringUnitCostModel, StringNodeData> apted = new APTED<>(new StringUnitCostModel());

        distance = (int)apted.computeEditDistance(t1, t2);
        System.out.println(distance);

        return distance;
    }
}
