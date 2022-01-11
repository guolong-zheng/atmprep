package synth.syntaxtemplates.printers;

import synth.HoleStat;
import synth.SearchStat;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.seed.Seed;

import java.util.HashSet;
import java.util.Set;

public class SeedValuePrinter extends SeedPrinter {
    SearchStat state;
    Set<HoleStat> visited;

    public SeedValuePrinter(Seed seed, SearchStat state) {
        super(seed);
        this.state = state;
        visited = new HashSet<>();
    }

    @Override
    public void visit(ValueHole expr) {
        if (expr.is_atom)
            sb.append(expr.atom);
        else if (expr.is_exprn)
            sb.append(expr.exprns.get(0));
        else {
            for (HoleStat hs : state.holes) {
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
    }
}
