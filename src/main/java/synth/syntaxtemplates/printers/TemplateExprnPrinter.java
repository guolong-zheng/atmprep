package synth.syntaxtemplates.printers;

import parser.ast.Exprn;
import synth.ASolution;
import synth.HoleStat;
import synth.SearchStat;
import synth.syntaxtemplates.structures.Template;
import synth.syntaxtemplates.template.hole.ValueHole;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class TemplateExprnPrinter extends TemplatePrinter {
    SearchStat state;
    Set<HoleStat> visited;
    ASolution sol;

    public TemplateExprnPrinter(Template t, SearchStat ss, ASolution s) {
        super(t);
        state = ss;
        sol = s;
        visited = new HashSet<>();
    }

    public TemplateExprnPrinter(Template template){
        super(template);
    }

    @Override
    public void visit(ValueHole expr){
//        for(HoleStat hs : state.holes){
//            if (!visited.contains(hs) && hs.hole == expr) {
//                visited.add(hs);
//                List<Exprn> exprs = sol.val2exprs.get(hs.getCurrentVal());
//
//                exprs.get(0).toString(sb);
//                return;
////                for(Exprn n : exprs) {
////                    if(n.getType().isSubtypeOf(hs.hole.getType())) {
////                        n.toString(sb);
////                        return;
////                    }
////                }
//            }
//
//        }
//        System.out.println("hole " + expr);
//        System.out.println("map " + template.hole2exprns);
        List<Exprn> exprns = template.hole2sortedexprns.get(expr);
        exprns.get(0).toString(sb);
    }
}
