package parser.visitor;

import parser.ast.*;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.hole.VarHole;
import synth.syntaxtemplates.structures.Template;

public interface VoidVisitor {
    void visit(AModel model);

    void visit(Assert asserts);

    void visit(Opens open);

    void visit(SigDef sigDecl);

    void visit(DeclField sigField);

    void visit(DeclParam decl);

    void visit(DeclVar decl);

    void visit(Fact fact);

    void visit(Predicate pred);

    void visit(Function func);

    void visit(ExprnBinaryBool expr);

    void visit(ExprnBinaryRel expr);

    void visit(ExprnCallBool expr);

    void visit(ExprnCallRel expr);

    void visit(ExprnConst expr);

    void visit(ExprnField expr);

    void visit(ExprnITEBool expr);

    void visit(ExprnITERel expr);

    void visit(ExprnLet expr);

    void visit(ExprnListBool expr);

    void visit(ExprnListRel expr);

    void visit(ExprnQtBool expr);

    void visit(ExprnQtRel expr);

    void visit(ExprnSig expr);

    void visit(ExprnVar expr);

    void visit(ExprnUnaryBool expr);

    void visit(ExprnUnaryRel expr);

    void visit(Template template);

    void visit(VarHole hole);

    void visit(ValueHole hole);
}
