package synth.syntaxtemplates.generators;

import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.ast.Type;
import parser.ast.*;
import synth.syntaxtemplates.structures.*;
import synth.syntaxtemplates.template.hole.Hole;
import synth.syntaxtemplates.template.hole.ValueHole;
import synth.syntaxtemplates.template.seed.Seed;
import synth.varcollectors.ExprnVarCollector;
import utility.LOGGER;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

public class TemplateCreator {
    public Exprn orig;
    List<ExprnVar> declVars; // because sigs and fields already included in expression generator
    // no need to include them here
    List<Declaration> decls;

    List<Seed> seeds;

    private int newvars;

    public List<UnaryTemplate> unaryTemplates;// = new ArrayList<>();
    public List<BinaryTemplate> binaryTemplates; //= new ArrayList<>();
    public List<BinaryTemplate> hybridTemplates; // = new ArrayList<>();
    public List<QtReplaceTemplate> qtReplaceTemplates; // add
    public List<QtRemoveTemplate> qtRemoveTemplates;    // remove

    public List<Template> allTemplates;

    public List<Template> seededTemplate; // template generated from seeds

    public Set<Type> types;

    public TemplateCreator(Exprn exprn, List<Seed> seeds){
        orig = exprn;
        newvars = 1;
        this.seeds = seeds;
    }

    public TemplateCreator(Exprn exprn){
        orig = exprn;
        newvars = 1;
    }

    public void initialize(){
        // collect all decl variables in the original expression
        declVars = new ArrayList<>();
        ExprnVarCollector vc = new ExprnVarCollector(orig);
        vc.collect();
        vc.livevars.stream().forEach(v ->
            declVars.add(v.toExprnVar()) );
        decls = vc.decls;

//        for(ExprnVar var : declVars){
//            System.out.println(var);
//        }

        unaryTemplates = new ArrayList<>();
        binaryTemplates = new ArrayList<>();
        hybridTemplates = new ArrayList<>();
        qtReplaceTemplates = new ArrayList<>();
        qtRemoveTemplates = new ArrayList<>();
        allTemplates = new ArrayList<>();

        HoleTypeCollector hc = new HoleTypeCollector();
        types = hc.collect(orig);
    }

    List<Type> typeByPriority;

    public List<Template> getSeededTemplate(){
        List<Template> templates = new ArrayList<>();
        for(Seed seed : seeds){
            if(seed.exprn instanceof ExprnUnaryBool){
                UnaryTemplate ut1 = new UnaryTemplate(orig, seed.exprn, ((ExprnUnaryBool) seed.exprn).op, null, seed.holes, false);
                templates.add(ut1);
                if(decls.size() > 0) {
                    templates.addAll( genUnaryTemplateWithDecl(seed) );
                }

            }else if(seed.exprn instanceof ExprnBinaryBool){
                BinaryTemplate bt1 = new BinaryTemplate(orig, seed.exprn, ((ExprnBinaryBool) seed.exprn).op, null);
                templates.add(bt1);
                if(decls.size() > 0) {
                    templates.addAll( genBinaryTemplateWithDecl(seed) );
                }
            }
        }

        LOGGER.logInfo(this.getClass(), "create " + templates.size() + " seeding templates");

        return templates;
    }

    public List<Template> genUnaryTemplateWithDecl(Seed seed){
        List<Template> tmps = new ArrayList<>();
        List<Exprn> exprns = new ArrayList<>();
        for(Declaration decl : decls){
            exprns.addAll( decl.getNames() );
        }
        ExprnUnaryBool exprnwithhole = (ExprnUnaryBool)seed.exprn;
        Exprn sub = exprnwithhole.getSub();
        ExprnUnaryBool.Op op = exprnwithhole.op;

        if( sub instanceof ValueHole ){
            for(Exprn var : exprns) {
                if(var.getType().equals( sub.getType() )) {
                    ExprnUnaryBool eu = new ExprnUnaryBool(var, op);
                    UnaryTemplate ut = new UnaryTemplate(orig, eu, op, decls, new ArrayList<>(), true);
                    tmps.add(ut);
                }
            }
        }else if( sub instanceof ExprnBinaryRel ){
            Exprn left = ((ExprnBinaryRel) sub).getLeft();
            Hole right = (Hole) ((ExprnBinaryRel) sub).getRight();
            List<Hole> holes = new ArrayList<>();
            holes.add(right);

            for(Exprn var : exprns){
                if(var.getType().equals( left.getType() )){
                    ExprnBinaryRel ebr = new ExprnBinaryRel( var, ((ExprnBinaryRel) sub).right, ((ExprnBinaryRel) sub).op, sub.getType() );
                    ExprnUnaryBool eub = new ExprnUnaryBool( ebr, op );
                    UnaryTemplate ut = new UnaryTemplate(orig, eub, op, decls, holes, true);
                    tmps.add(ut);
                }
            }
        }
        return tmps;
    }

    public List<Template> genBinaryTemplateWithDecl(Seed seed){
        List<Template> tmps = new ArrayList<>();
        List<Exprn> exprns = new ArrayList<>();
        for(Declaration decl : decls){
            exprns.addAll( decl.getNames() );
        }

        ExprnBinaryBool exprnwithhole = (ExprnBinaryBool)seed.exprn;
        Exprn left = exprnwithhole.getLeft();
        Exprn right = exprnwithhole.getRight();
        ExprnBinaryBool.Op op = exprnwithhole.op;
        Type type = exprnwithhole.type;

        List<Pair<Exprn, List<Hole>>> lefts = toHoleWithVar(left, exprns);
        List<Pair<Exprn, List<Hole>>> rights = toHoleWithVar(right, exprns);

        for(Pair<Exprn, List<Hole>> le : lefts){
            for(Pair<Exprn, List<Hole>> re : rights){
                if(le.b.size() + re.b.size() < seed.holes.size()) {
                    ExprnBinaryBool ebb = new ExprnBinaryBool(le.a, re.a, op);
                    BinaryTemplate bt = new BinaryTemplate(orig, ebb, op, decls);
                    tmps.add(bt);
                }
            }
        }

        return tmps;
    }

    public List<Pair<Exprn, List<Hole>>> toHoleWithVar(Exprn exprn, List<Exprn> vars){
        List<Pair<Exprn, List<Hole>>> exprns = new ArrayList<>();

        if( exprn instanceof ValueHole ){
            List<Hole> leftholes = new ArrayList<>();
            leftholes.add((Hole) exprn);
            exprns.add( new Pair<>(exprn, leftholes) );
            for(Exprn var : vars) {
                if(var.getType().equals( exprn.getType() )) {
                    exprns.add( new Pair(var, new ArrayList<>()) );
                }
            }
        }else if( exprn instanceof ExprnBinaryRel ){
            Exprn leftsub = ((ExprnBinaryRel) exprn).getLeft();
            Hole rightsub = (Hole) ((ExprnBinaryRel) exprn).getRight();

            List<Hole> origholes = new ArrayList<>();
            origholes.add((Hole) leftsub);
            origholes.add((Hole) rightsub);
            exprns.add( new Pair(exprn, origholes) );

            List<Hole> holes = new ArrayList<>();
            holes.add(rightsub);

            for(Exprn var : vars){
                if(var.getType().equals( leftsub.getType() )){
                    ExprnBinaryRel ebr = new ExprnBinaryRel( var, rightsub, ((ExprnBinaryRel) exprn).op, exprn.getType() );
                    exprns.add( new Pair(ebr, holes) );
                }
            }
        }

        return exprns;
    }

    public List<Template> getAllTemplates(){
        createBinary();
        createUnary();
        createHybrid();
      //  createQtAddDecl();
       // createQtDeclRemove();

       allTemplates.addAll(unaryTemplates);
      //  allTemplates.addAll(binaryTemplates);
        allTemplates.addAll(hybridTemplates);
      // allTemplates.addAll(qtReplaceTemplates);
      // allTemplates.addAll(qtRemoveTemplates);
        return allTemplates;
    }

    public List<Template> getUnary(){
        createUnary();
        allTemplates.addAll(unaryTemplates);
        return allTemplates;
    }

    public List<Template> getBinary(){
        createBinary();
        allTemplates.addAll(binaryTemplates);
        return allTemplates;
    }

    public List<Template> getHybird(){
        createUnary();
        createBinary();
        createHybrid();
        System.out.println("un: " + unaryTemplates.size());
        System.out.println("bi: " + binaryTemplates.size());
        System.out.println("hb: " + hybridTemplates.size());
        allTemplates.addAll(hybridTemplates);
        return allTemplates;
    }

    public List<Template> getDeclRemove(){
        createQtDeclRemove();
        allTemplates.addAll(qtRemoveTemplates);
        return allTemplates;
    }

    public List<Template> getDeclAdd(){
        createQtAddDecl();
        allTemplates.addAll(qtReplaceTemplates);
        return allTemplates;
    }
    /**
     * generate unary template, lets consider only already decled vars first
     */
    public void createUnary(){
        for(Type t : types) {
            Hole valueHole = new ValueHole(t);
            List<Hole> holes = new LinkedList<>();
            holes.add(valueHole);
            for (ExprnUnaryBool.Op op : UnaryTemplate.ops) {
                ExprnUnaryBool expr = new ExprnUnaryBool(valueHole, op);
                unaryTemplates.add(new UnaryTemplate(orig, expr, op, null, holes, false));
            }

            if(t.arity() == 2) {
                for (ExprnVar var : declVars) {
                    if( canCombine(var, t) ){
                        ExprnBinaryRel basic_expr = new ExprnBinaryRel(var, valueHole, true);

                        for (ExprnUnaryBool.Op op : UnaryTemplate.ops) {
                            ExprnUnaryBool expr = new ExprnUnaryBool(basic_expr, op);
                            unaryTemplates.add(new UnaryTemplate(orig, expr, op, decls, holes, true));
                        }
                    }
                }
            }
        }
    }

    public boolean canCombine(Exprn expr, Type type){
        Type eType = expr.getType();
        return eType.getLast() == Sig.UNIV || eType.getLast() == type.getFirst();
    }

    public boolean canCombine(Exprn e1, Exprn e2){
        return e1.getType().getLast() == Sig.UNIV ||
                e1.getType().getLast() == e2.getType().getFirst();
    }

    /**
     * generate binary template
     */
    public void createBinary(){
        List<Exprn> basicExprns = new ArrayList<>();
        List<Exprn> basicHoles = new ArrayList<>();
        for( Type t : types ) {
            Exprn valueHole = new ValueHole(t);
            basicExprns.add(valueHole);
            basicHoles.add(valueHole);
        }

        //basicExprns.add(orig);
        for(ExprnVar var : declVars){
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
                    Exprn exprn1 = new ExprnBinaryBool(exprns[i], new ExprnConst(0), op);
                    Exprn exprn2 = new ExprnBinaryBool(exprns[i], new ExprnConst(1), op);
                    binaryTemplates.add(new BinaryTemplate(orig, exprn1, op, decls));
                    binaryTemplates.add(new BinaryTemplate(orig, exprn2, op, decls));
                }
            }

            for(int j = i; j < exprns.length; j++){

                // for asymmetric ops, add both
                for (ExprnBinaryBool.Op op : BinaryTemplate.booleanASymOps) {
                    if(forBool(op)){
                        if( exprns[i].getType().is_bool && exprns[j].getType().is_bool){
                            Exprn exprn1 = new ExprnBinaryBool(exprns[i], exprns[j], op) ;
                            Exprn exprn2 = new ExprnBinaryBool(exprns[j], exprns[i], op) ;

                            binaryTemplates.add( new BinaryTemplate(orig, exprn1, op, decls) );
                            binaryTemplates.add( new BinaryTemplate(orig, exprn2, op, decls) );
                        }
                    }else {
                       if( exprns[i].getType().equals( exprns[j].getType()) ) {
                           Exprn exprn1 = new ExprnBinaryBool(exprns[i], exprns[j], op);
                           binaryTemplates.add(new BinaryTemplate(orig, exprn1, op, decls));

                           if(exprns[i] != exprns[j]) {
                               Exprn exprn2 = new ExprnBinaryBool(exprns[j], exprns[i], op);
                               binaryTemplates.add(new BinaryTemplate(orig, exprn2, op, decls));
                           }
                       }
                    }
                }

                // for symmetric, add one
                for (ExprnBinaryBool.Op op : BinaryTemplate.booleanSymOps) {
                    if( forBool(op) ) {
                        if( exprns[i].getType().is_bool && exprns[j].getType().is_bool ) {
                            Exprn exprn1 = new ExprnBinaryBool(exprns[i], exprns[j], op);
                            binaryTemplates.add(new BinaryTemplate(orig, exprn1, op, decls));
                        }
                    }else{
                        if( exprns[i].getType().equals( exprns[j].getType()) ) {
                            Exprn exprn1 = new ExprnBinaryBool(exprns[i], exprns[j], op);
                            binaryTemplates.add(new BinaryTemplate(orig, exprn1, op, decls));
                        }
                    }
                }

                // for int types
                if(exprns[i].getType().is_int() && exprns[j].getType().is_int()){
                    for(ExprnBinaryBool.Op op : BinaryTemplate.intOps){
                        Exprn exprn1 = new ExprnBinaryBool(exprns[i], exprns[j], op) ;
                        Exprn exprn2 = new ExprnBinaryBool(exprns[j], exprns[i], op) ;

                        binaryTemplates.add( new BinaryTemplate(orig, exprn1, op, decls) );
                        binaryTemplates.add( new BinaryTemplate(orig, exprn2, op, decls) );
                    }
                }
            }
        }
    }

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

    // mix of unary and binary template
    public void createHybrid(){
        ExprnBinaryBool.Op[] symops = {ExprnBinaryBool.Op.AND, ExprnBinaryBool.Op.OR};
        ExprnBinaryBool.Op[] asymops = {ExprnBinaryBool.Op.IMPLIES};

        Exprn sub = orig;
        ArrayList<Pair<ExprnQtBool.Op, List<Declaration>>> pre = new ArrayList<>();
        if(sub instanceof ExprnQtBool){
            Pair<ExprnQtBool.Op, List<Declaration>> prepend = new Pair( ((ExprnQtBool)sub).op, ((ExprnQtBool) sub).getVars());
            pre.add(prepend);
            sub = ((ExprnQtBool) sub).getSub();
        }

        for(UnaryTemplate ut : unaryTemplates){
            for(ExprnBinaryBool.Op op : symops){
                if(ut.hasDeclVar) {
                    // unary template and sub expression
                    ExprnBinaryBool e1 = new ExprnBinaryBool(ut.replacement, sub, op);
                    BinaryTemplate hybridBtSub1 = new BinaryTemplate(orig, e1, op, decls, pre);
                    hybridTemplates.add(hybridBtSub1);
                }

                // for qt exprn, create template to whole exprn, only add when template contains no declvars
                //if(orig instanceof ExprnQt && !ut.hasDeclVar){
                if(!ut.hasDeclVar){
                    ExprnBinaryBool exprwithorig = new ExprnBinaryBool(ut.replacement, orig, op);
                    BinaryTemplate hybridBt1 = new BinaryTemplate(orig, exprwithorig, op, null);
                    hybridTemplates.add(hybridBt1);
                }
            }
            for(ExprnBinaryBool.Op op : asymops){
                if(ut.hasDeclVar) {
                    ExprnBinaryBool e1 = new ExprnBinaryBool(ut.replacement, sub, op);
                    ExprnBinaryBool e2 = new ExprnBinaryBool(sub, ut.replacement, op);
                    BinaryTemplate hybridBtSub1 = new BinaryTemplate(orig, e1, op, decls, pre);
                    BinaryTemplate hybridBtSub2 = new BinaryTemplate(orig, e2, op, decls, pre);
                    hybridTemplates.add(hybridBtSub1);
                    hybridTemplates.add(hybridBtSub2);
                }

                //if(orig instanceof ExprnQt && !ut.hasDeclVar){
                if(!ut.hasDeclVar){
                    ExprnBinaryBool exprwithorig3 = new ExprnBinaryBool(ut.replacement, orig, op);
                    ExprnBinaryBool exprwithorig4 = new ExprnBinaryBool(orig, ut.replacement, op);
                    BinaryTemplate hybridBt3 = new BinaryTemplate(orig, exprwithorig3, op, null);
                    BinaryTemplate hybridBt4 = new BinaryTemplate(orig, exprwithorig4, op, null);
                    hybridTemplates.add(hybridBt3);
                    hybridTemplates.add(hybridBt4);
                }
            }
        }

        for(BinaryTemplate bt : binaryTemplates){
            for(ExprnBinaryBool.Op op : symops){
                if(bt.hasDeclVar) {
                    // binary template and sub expression
                    ExprnBinaryBool e1 = new ExprnBinaryBool(bt.replacement, sub, op);
                    BinaryTemplate hybridBtSub1 = new BinaryTemplate(orig, e1, op, decls, pre);
                    hybridTemplates.add(hybridBtSub1);
                }else{
                    // no decl var and put outside
                    ExprnBinaryBool exprwithorig = new ExprnBinaryBool(bt.replacement, orig, op);
                    BinaryTemplate hybridBt1 = new BinaryTemplate(orig, exprwithorig, op, null);
                    hybridTemplates.add(hybridBt1);
                }

//                // for qt exprn, create template to whole exprn
//                if(orig instanceof ExprnQt && !bt.hasDeclVar){
//                    ExprnBinaryBool exprwithorig = new ExprnBinaryBool(bt.replacement, orig, op);
//                    BinaryTemplate hybridBt1 = new BinaryTemplate(orig, exprwithorig, op, null);
//                    hybridTemplates.add(hybridBt1);
//                }
            }
            for(ExprnBinaryBool.Op op : asymops){
                if(bt.hasDeclVar) {
                    ExprnBinaryBool e1 = new ExprnBinaryBool(bt.replacement, sub, op);
                    ExprnBinaryBool e2 = new ExprnBinaryBool(sub, bt.replacement, op);
                    BinaryTemplate hybridBtSub1 = new BinaryTemplate(orig, e1, op, decls, pre);
                    BinaryTemplate hybridBtSub2 = new BinaryTemplate(orig, e2, op, decls, pre);
                    hybridTemplates.add(hybridBtSub1);
                    hybridTemplates.add(hybridBtSub2);
                }

                if(!bt.hasDeclVar){
                    ExprnBinaryBool exprwithorig3 = new ExprnBinaryBool(bt.replacement, orig, op);
                    ExprnBinaryBool exprwithorig4 = new ExprnBinaryBool(orig, bt.replacement, op);
                    BinaryTemplate hybridBt3 = new BinaryTemplate(orig, exprwithorig3, op, null);
                    BinaryTemplate hybridBt4 = new BinaryTemplate(orig, exprwithorig4, op, null);
                    hybridTemplates.add(hybridBt3);
                    hybridTemplates.add(hybridBt4);
                }
            }
        }
        /* FIXME : skip for now
        // combine both un and bin
        for(UnaryTemplate ut : unaryTemplates){
            for(BinaryTemplate bt : binaryTemplates){
                for(ExprnBinaryBool.Op op : symops){
                    ExprnBinaryBool expr = new ExprnBinaryBool(ut.replacement, bt.replacement, op);
                    BinaryTemplate hybridBt = new BinaryTemplate(orig, expr, op, decls);
                    hybridTemplates.add(hybridBt);
                }
            }
        }
        */
    }

    /**
     * generate qt template by adding decl vars
     */
    public void createQtAddDecl(){
            QtReplaceTemplateCreator tempCreator = new QtReplaceTemplateCreator(orig);
            tempCreator.search();
            qtReplaceTemplates = tempCreator.templates;
    }

    /**
     * generate qt template by removing decl vars
     */
    public void createQtDeclRemove(){
        QtRemoveTemplateCreator tempCreator = new QtRemoveTemplateCreator(orig);
        tempCreator.search();
        qtRemoveTemplates = tempCreator.templates;
    }

    public void createNewQtDecl(){


    }
}
