package synth;

import parser.ast.*;
import synth.syntaxtemplates.generators.QtRemoveTemplateCreator;
import synth.syntaxtemplates.generators.QtReplaceTemplateCreator;
import synth.syntaxtemplates.structures.*;

import java.util.ArrayList;
import java.util.List;

@Deprecated
public class TemplateSynthesizer {
    List<Template> templates;
    Exprn expr;

    public TemplateSynthesizer(Exprn expr){
        this.templates = new ArrayList<>();
        this.expr = expr;
    }

    public void synth(){

    }

    public void extractTemplateFromExpression(){

      //  ExprnVarCollector vc = new ExprnVarCollector(expr);

        createQtTemplate(expr);


        if(expr instanceof ExprnBinary){

        }

        if(expr instanceof ExprnUnary){}

        if(expr instanceof ExprnITE){}

        if(expr instanceof ExprnQt){}
    }

    void createQtTemplate(Exprn expr) {
        //List<QtTemplate> qtTemplates = new ArrayList<>();
        QtReplaceTemplateCreator qc = new QtReplaceTemplateCreator(expr);
        qc.search();
        //List<Template> t = qc.templates;
        for(QtReplaceTemplate t : qc.templates){
            System.out.println(t.toString("\'test\'"));
        }

        QtRemoveTemplateCreator qrc = new QtRemoveTemplateCreator(expr);
        qrc.search();
        for(QtRemoveTemplate qt : qrc.templates){
            StringBuilder sb = new StringBuilder();
            qt.original.toTemplateString(qt, "test", sb);
            System.out.println(sb.toString());
        }
    }

    void createBinaryTemplate() {}

    void createUnaryTemplate() {}
}
