package compare;

import edu.mit.csail.sdg.alloy4.A4Reporter;

// used to get KodKod output from Alloy
public class KodReporter extends A4Reporter {
    public String kodjava;

    @Override
    public void resultCNF(String filename) {
        kodjava = filename;
        super.resultCNF(filename);
    }
}
