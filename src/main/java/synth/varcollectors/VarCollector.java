package synth.varcollectors;

import parser.ast.AModel;
import parser.ast.Exprn;
import parser.ast.SigDef;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class VarCollector {

    public Set<Var> sigNfield;
    public Set<Var> livevars;
    AModel model;

    public VarCollector(AModel model) {
        this.sigNfield = new HashSet<>();
        this.model = model;
        collect(model);
        livevars = new HashSet<>();
        livevars.addAll(sigNfield);
    }

    private void collect(AModel model) {
        List<SigDef> sigDecl = model.getSigDecls();
        for (SigDef def : sigDecl) {
            sigNfield.add(new Var(def.getName(), def.getType()));
            def.getFields().forEach(f -> f.getNames().
                    forEach(n -> {
                                sigNfield.add(new Var(n.toString(), n.getType()));
                            }
                    ));
        }
    }

    public Set<Var> collect(Exprn expr){
        ExprnVarCollector vc = new ExprnVarCollector(expr);
        Set<Var> vars = vc.collectDeclVars();
        vars.addAll(sigNfield);
        return vars;
    }

    public Set<Var> collectDeclVars(Exprn expr){
        ExprnVarCollector vc = new ExprnVarCollector(expr);
        Set<Var> vars = vc.collectDeclVars();
        return vars;
    }
}
