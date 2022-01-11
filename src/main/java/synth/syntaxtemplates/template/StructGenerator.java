package synth.syntaxtemplates.template;

import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import synth.syntaxtemplates.generators.HoleTypeCollector;
import synth.syntaxtemplates.structures.BinaryTemplate;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.structast.*;
import synth.varcollectors.ExprnVarCollector;
import utility.LOGGER;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class StructGenerator {

    Exprn orig;    // original expression to be fixed

    int newQtVars; // max number of new declaration introduced

    Set<Type> types; // all possible types at that location

    List<ExprnVar> declvars;  // all decled vars available at the original expression

    List<Declaration> decls;  // declarations in the original expression

    List<Structure> metaStructs;

    public StructGenerator(Exprn orig, int newQtVars){
        this.orig = orig;
        this.newQtVars = newQtVars;
    }

    public void initialize(){
        LOGGER.logInfo(this.getClass(), "initializing structure generation...");

        declvars = new ArrayList<>();
        ExprnVarCollector vc = new ExprnVarCollector(orig);
        vc.collect();
        vc.livevars.stream().forEach(v ->
                declvars.add(v.toExprnVar()) );

        decls.addAll(vc.decls);

        HoleTypeCollector hc = new HoleTypeCollector();
        types = hc.collect(orig);

        metaStructs = new ArrayList<>();
    }

    public static void generateMeta(){

    }

    public void generateUnaryMeta(){
        for (ExprnUnaryBool.Op op : UnaryStruct.ops) {
            UnaryStruct us = new UnaryStruct(op, null);
            metaStructs.add(us);
        }
    }

    public void generateBinaryMeta(){
        for(ExprnBinaryBool.Op op : BinaryStruct.ops){
            BinaryStruct bs = new BinaryStruct(op, null, null);
            metaStructs.add(bs);
        }
    }

    public void generateQtMeta(){
        for(ExprnQtBool.Op op : QtStruct.ops){
            DeclStruct decl = new DeclStruct();
            QtStruct qs = new QtStruct(op, decl, null);
        }
    }

    public void nextDepth(){

    }

    public void generateBasic(){

    }

    public void addHoles(){
        for(Structure struct : metaStructs){
//            for(int i = 0; i < struct.toInstHoles.size(); i++){
//                Exprn expr = struct.toInstHoles.get(i);
//                for(Type type : types){
//                    ValueHole vh = new ValueHole(type);
//                    expr = vh;
//                }
//            }
        }
    }


    List<Structure> baseStructs = new ArrayList<>();

    public void generateBase(){


    }

    // generate basic uanry structs: some ??; no ??; no v.??; lone v.??
    void generateUnaryBase(){
        for (Type type : types) {
            ValueHole hole = new ValueHole(type);

            for (ExprnUnaryBool.Op op : UnaryStruct.ops) {
                UnaryStruct us = new UnaryStruct(op, hole);
                baseStructs.add(us);
            }

            if(type.arity() == 2){
                for(ExprnVar var : declvars){
                    if( canCombine(var, type) ){
                        ExprnBinaryRel expr_with_declvar = new ExprnBinaryRel(var, hole, true);

                        for (ExprnUnaryBool.Op op : UnaryStruct.ops) {
                            UnaryStruct us = new UnaryStruct(op, expr_with_declvar);
                            baseStructs.add(us);
                        }
                    }
                }
            }
        }
    }

    void generateBinaryBase(){
        List<Exprn> basicExprns = new ArrayList<>();
        List<Exprn> basicHoles = new ArrayList<>();
        for( Type t : types ) {
            Exprn valueHole = new ValueHole(t);
            basicExprns.add(valueHole);
            basicHoles.add(valueHole);
        }

        //basicExprns.add(orig);
        for(ExprnVar var : declvars){
            for(Exprn hole : basicHoles) {
                if(hole.getType().arity() == 2 &&
                        canCombine(var, hole) ) {
                    Exprn basic_expr = new ExprnBinaryRel(var, hole, true);
                    basicExprns.add(basic_expr);
                }
            }
        }

        Exprn[] exprns = basicExprns.toArray(new Exprn[basicExprns.size()]);
        for(int i = 0; i < exprns.length; i++){

            // with constant values 0 and 1
            if(exprns[i].getType().is_int()){
                for(ExprnBinaryBool.Op op : BinaryTemplate.intOps) {
                    baseStructs.add(new BinaryStruct(op, exprns[i], new ExprnConst(0)));
                }
            }

            for(int j = i; j < exprns.length; j++){
                // for asymmetric ops, add both
                for (ExprnBinaryBool.Op op : BinaryTemplate.booleanASymOps) {
                    if(forBool(op)){
                        if( exprns[i].getType().is_bool && exprns[j].getType().is_bool){
                            baseStructs.add( new BinaryStruct(op, exprns[i], exprns[j]) );
                            baseStructs.add( new BinaryStruct(op, exprns[j], exprns[i]) );
                        }
                    }else {
                        if( exprns[i].getType().equals( exprns[j].getType()) ) {
                            baseStructs.add(new BinaryStruct(op, exprns[i], exprns[j]));
                            if(exprns[i] != exprns[j]) {
                                baseStructs.add(new BinaryStruct(op, exprns[j], exprns[i]));
                            }
                        }
                    }
                }

                // for symmetric, add one
                for (ExprnBinaryBool.Op op : BinaryTemplate.booleanSymOps) {
                    if( forBool(op) ) {
                        if( exprns[i].getType().is_bool && exprns[j].getType().is_bool ) {
                            baseStructs.add(new BinaryStruct(op, exprns[i], exprns[j]));
                        }
                    }else{
                        if( exprns[i].getType().equals( exprns[j].getType()) ) {
                            baseStructs.add(new BinaryStruct(op, exprns[i], exprns[j]));
                        }
                    }
                }

                // for int types
                if(exprns[i].getType().is_int() && exprns[j].getType().is_int()){
                    for(ExprnBinaryBool.Op op : BinaryTemplate.intOps){
                        baseStructs.add( new BinaryStruct(op, exprns[i], exprns[j]) );
                    }
                }
            }
        }
    }

    public void goDeeper(){
        List<Structure> nextStructs = new ArrayList<>();
        List<Structure> currStructs = new ArrayList<>();
        for(Structure struct : currStructs){
            List<Exprn> toInst = struct.toInstHoles;
            for(Structure base : baseStructs){
                Structure str = new Structure();
                for(Exprn expr : toInst){
                    expr = base;
                    // update toInstHoles
                    str.toInstHoles = toInst;
                }
            }
        }
    }


    boolean canCombine(Exprn expr, Type type){
        Type eType = expr.getType();
        return eType.getLast() == Sig.UNIV || eType.getLast() == type.getFirst();
    }

    boolean canCombine(Exprn e1, Exprn e2){
        return e1.getType().getLast() == Sig.UNIV ||
                e1.getType().getLast() == e2.getType().getFirst();
    }

    // check if connects boolean exprn
    public boolean forBool(ExprnBinaryBool.Op op){
        switch (op){
            case AND:
            case OR:
            case IFF:
            case IMPLIES:
                return true;
            default:
                return false;
        }
    }
}
