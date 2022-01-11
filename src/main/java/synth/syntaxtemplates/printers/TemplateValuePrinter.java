package synth.syntaxtemplates.printers;

import parser.ast.DeclParam;
import parser.ast.DeclVar;
import synth.HoleStat;
import synth.SearchStat;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

import java.util.HashSet;
import java.util.Set;

public class TemplateValuePrinter extends TemplatePrinter {
    SearchStat state;

    Set<HoleStat> visited;

    public TemplateValuePrinter(Template t, SearchStat st) {
        super(t);
        state = st;
        visited = new HashSet<>();
    }

    @Override
    public void visit(ValueHole expr){
        for(HoleStat hs : state.holes){
                if (!visited.contains(hs) && hs.hole == expr) {
                    visited.add(hs);
                    if (hs.getCurrentVal().equals("{}")) {
                        if (expr.getType().arity() == 1)
                            sb.append("{none}");
                        else {
                            sb.append("{");
                            for (int i = 0; i < expr.getType().arity(); i++) {
                                if (i >= 1) {
                                    sb.append("->");
                                }
                                sb.append(" {none} ");
                            }
                            sb.append("}");
                        }
                    } else {
                        sb.append("{" + hs.getCurrentVal() + "}");
                    }
                    break;
                }

            }
    }

    @Override
    public void visit(DeclVar decl) {
        decl.toString(sb);
    }

    @Override
    public void visit(DeclParam decl) {
        decl.toString(sb);
    }

    @Override
    public void visit(VarHole expr){
        sb.append(expr);
    }
}
