package synth.syntaxtemplates.template;

import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4.SafeList;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;

import java.util.Set;

public class SearchSeed {
    Pair<A4Solution, A4Solution> tests;
    Set<Sig> sigs;
    Set<Sig.Field> fields;

    public void find(){
        A4Solution cex = tests.a;

        SafeList<Sig> sigs = cex.getAllReachableSigs();
        for(Sig sig : sigs){
            SafeList<Sig.Field> fields = sig.getFields();


        }
    }

    public void temp(){

    }


}
