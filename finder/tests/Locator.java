package tests;

import compare.*;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.ExprVar;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.translator.A4TupleSet;
import parser.ast.*;
import parser.visitor.CollectSubExpr;
import parser.visitor.SliceVisitor;
import parser.visitor.WordsBinder;
import utility.AlloyUtil;
import utility.NodeCounter;
import utility.StringUtil;
import utility.VisitedNodeCounter;

import java.util.*;

public class Locator {
    Map<Exprn, Double> node2score;
    Set<Exprn> visited;
    boolean writeResult = true;

    public List<Exprn> result;

    public Locator() {
        node2score = new HashMap<>();
        visited = new HashSet<>();
        result = new ArrayList<>();
    }
    public Locator(boolean writeResult){
        node2score = new HashMap<>();
        visited = new HashSet<>();
        this.writeResult = writeResult;
    }

    public void localize(AModel model, CompModule world, int scope) throws Err {
        InstanceGenerator ig = new InstanceGenerator(world);

        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs(ig.world.getAllCommands());
        outloop:
        for (Pair<Command, Command> p : pairs) {
            List<InstancePair> ips = ig.genInstancePair(p.a, p.b, scope);
            for (InstancePair ip : ips) {
                if (ip.bugType == BugType.NO_BUG) {
                    break;
                }
                if (ip.bugType == BugType.NO_EXPECT) {
                    result.addAll(ip.locations);
                    return;
                }
            }

            Iterator<InstancePair> instancePairIterator = ips.iterator();
            while(instancePairIterator.hasNext()){
                if(instancePairIterator.next().bugType == BugType.NO_BUG){
                    instancePairIterator.remove();
                }
            }
            if(ips.size() == 0)
                return;

            for (InstancePair ip : ips) {
                    ip.findDiff();
            }
            // extract relatedrelations and find possible keywords
            Set<String> relatedrelations = new HashSet<>();
            Set<String> possiblekeywords = new HashSet<>();
            extractKeywords(ips, relatedrelations, possiblekeywords);

            // slice alloy model to find related pred and func for the corresponding command
            SliceVisitor sv = new SliceVisitor(p.a);
            sv.visit(model);
            if(sv.emptybody){
                result.add(sv.loc);
                return;
            }

            //System.out.println("related preds: " + sv.relatedPreds);
            // collect keywords
            // WordsCollector kc = new WordsCollector(sv.relatedPreds);
            WordsBinder kc = new WordsBinder(sv.relatedPreds);
            kc.visit(model, null);

            int collected = calScore(relatedrelations, possiblekeywords, kc.node2keyword, ips);

            LinkedHashMap<Exprn, Double> sortedMap = new LinkedHashMap<>();
            node2score.entrySet()
                    .stream()
                    .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                    .forEachOrdered(x -> sortedMap.put(x.getKey(), x.getValue()));

            // output stats
            Set<String> vs = new HashSet<>();
            for (Exprn expr : sortedMap.keySet()) {
                if (vs.contains(expr.toString())) {
                    continue;
                } else {
                    vs.add(expr.toString());
                    result.add(expr);
                }
            }
        }
    }

    public void localize(String path, int scope) throws Err {
        {
//            PrintStream printStream = null;
//            try {
//                printStream = new PrintStream(new FileOutputStream("newResult.txt", true));
//
//            } catch (FileNotFoundException e) {
//                e.printStackTrace();
//            }
//            System.setOut(printStream);
            System.out.println(path + ":");
            //LOGGER.setLevel(LOGGER.Level.Debug);
            long beginTime = System.currentTimeMillis();
            InstanceGenerator ig = new InstanceGenerator(path);
            AModel aModel = new AModel(ig.world);
            List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs(ig.world.getAllCommands());
            outloop:
            for (Pair<Command, Command> p : pairs) {
                List<InstancePair> ips = ig.genInstancePair(p.a, p.b, scope);
              //  System.out.println("example generation time:" + (System.currentTimeMillis()-beginTime)/1000.0);
                int i = 0;
                for( InstancePair ip : ips) {
                    i++;
                    if(ip.bugType == BugType.NO_BUG) {
//                        System.out.println("no bug starting at pair:" + i);
//                        ips.remove(ip);
//                        if(i == 1) {
//                            NodeCounter counter = new NodeCounter();
//                            counter.visit(aModel);
//                            long analyseTime = System.currentTimeMillis() - beginTime;
//                            System.out.println("type a or d bug");
//                            System.out.printf("analyze time(sec): %.2f\n", analyseTime/1000.0);
//                            System.out.println("# Total AST: " + counter.count);
//                            System.out.println("LOC: " + StringUtil.countFile(path));
//                            System.out.println("===================");
//                            String modelname = path.substring(path.lastIndexOf("/")+1, path.length()-4);
//                            Reportor rep = new Reportor(modelname, StringUtil.countFile(path), 0, 0, 0, counter.count, analyseTime/1000.0);
//                            if(writeResult)
//                                rep.writeToCSV("result.csv");
//                            continue outloop;
//                        }
                        continue outloop;
                    }
                    if (ip.bugType == BugType.NO_EXPECT) {
                        long analyseTime = System.currentTimeMillis() - beginTime;
                        System.out.println("type b bug");
                        System.out.println("RANK LIST:");
                        NodeCounter nc = new NodeCounter();
                        for (Exprn exprn : ip.locations) {
                            AlloyUtil.count(nc, exprn);
                            System.out.println(exprn.toString());
                        }
                        //System.out.println("# val: " + valnum / ips.size());
                        // System.out.println("# Slice Out: " + (counter.count - collected));
                        NodeCounter counter = new NodeCounter();
                        counter.visit(aModel);
                        System.out.printf("analyze time(sec): %.2f\n", analyseTime/1000.0);
                        System.out.println("# Total AST: " + counter.count);
                        System.out.println("LOC: " + StringUtil.countFile(path));
                        System.out.println("===================");
                        System.out.println("\n");
                        String modelname = path.substring(path.lastIndexOf("/")+1, path.length()-4);
                        Reportor rep = new Reportor(modelname, StringUtil.countFile(path), 0, 0, (counter.count - nc.count), counter.count, analyseTime/1000.0);
                        if(writeResult)
                        rep.writeToCSV("result.csv");
                        continue outloop;
                    }
                }

//                InstancePair leastip = null;
                int size = 0;
                for(InstancePair ip : ips) {
                    if(size == 0) {
                        ip.findDiff();
                        //  System.out.println(ip.expected);
                        System.out.println(ip.difference);
                        size++;
                    }
                }
//                ips.clear();
//                ips.add(leastip);
//                System.out.println(leastip.difference);

                // extract relatedrelations and find possible keywords
                Set<String> relatedrelations = new HashSet<>();
                Set<String> possiblekeywords = new HashSet<>();
                extractKeywords(ips, relatedrelations, possiblekeywords);
//                System.out.println("related: " + relatedrelations);
//                System.out.println("inferred: " + possiblekeywords);

                // slice alloy model to find related pred and func for the corresponding command
                SliceVisitor sv = new SliceVisitor(p.a);
                sv.visit(aModel);
                //System.out.println("related preds: " + sv.relatedPreds);
                // collect keywords
                // WordsCollector kc = new WordsCollector(sv.relatedPreds);
                WordsBinder kc = new WordsBinder(sv.relatedPreds);
                kc.visit(aModel, null);

//                kc.node2keyword.keySet().stream().forEach( k -> {
//                   System.out.println( k +  ":\n\t " + kc.node2keyword.get(k)+"\n");
//               });
                //System.out.println(kc.node2keyword);
                // calculate priority based on difference and keywords
                //calculatePriority(relatedrelations, possiblekeywords, kc.node2keyword, ips);
//                for( Exprn e : kc.node2keyword.keySet()){
//                    System.out.println(e + " " + kc.node2keyword.get(e)+ "\n");
//                }
                int collected = calScore(relatedrelations, possiblekeywords, kc.node2keyword, ips);
                // }

                long analyseTime = System.currentTimeMillis() - beginTime;
                LinkedHashMap<Exprn, Double> sortedMap = new LinkedHashMap<>();
                node2score.entrySet()
                        .stream()
                        .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                        .forEachOrdered(x -> sortedMap.put(x.getKey(), x.getValue()));

                // output stats
                System.out.println("type c bug");
                System.out.println("RANK LIST:");
                int rank = 0;
                Set<String> vs = new HashSet<>();
                for( Exprn expr : sortedMap.keySet()){
                    if(vs.contains(expr.toString())){
                        continue;
                    }else
                        vs.add(expr.toString());
                    if( expr instanceof ExprnBinaryBool){
                        Exprn left = ((ExprnBinaryBool) expr).getLeft();
                        Exprn right = ((ExprnBinaryBool) expr).getRight();
                        Double leftscore = sortedMap.get(left);
                        Double rightscore = sortedMap.get(right);
                        String append = ( leftscore != rightscore)? ((ExprnBinaryBool) expr).getOp().toString() : "";
                        System.out.println(rank + ": " + expr + " " +  String.format("%.2f", sortedMap.get(expr)) + " " + append);
                    }else{
                        System.out.println(rank + ": " + expr + " " + String.format("%.2f", sortedMap.get(expr)));
                    }
                    rank++;
                }
                NodeCounter counter = new NodeCounter();
                counter.visit(aModel);
                System.out.println("-------------------");
                System.out.printf("analyze time(sec): %.2f\n", analyseTime/1000.0);
                System.out.println("# rel: " + (relatedrelations.size() + possiblekeywords.size()));
                int valnum = 0;
                for(InstancePair ip : ips) {
                    if(ip.difference == null) {
                        System.out.println("type c");
                        break;
                    }
                    valnum += ip.difference.affectedVals.size();
                }
                System.out.println("# val: " + valnum / ips.size());
                System.out.println("# Slice Out: " + (counter.count - collected));
                System.out.println("# Total AST: " + counter.count);
                System.out.println("LOC: " + StringUtil.countFile(path));
                System.out.println("evals: " + eval_count + " | " + "node: " + node_count);
                System.out.println("===================");
                System.out.println("\n");
                String modelname = path.substring(path.lastIndexOf("/")+1, path.length()-4);
                Reportor rep = new Reportor(modelname, StringUtil.countFile(path), (relatedrelations.size() + possiblekeywords.size()), valnum / ips.size(), (counter.count - collected), counter.count, analyseTime/1000.0);
                if(writeResult)
                rep.writeToCSV("result.csv");
            }

            // name
            // rank over total
            // # sliced out AST
            // number of different relations
            // number of different values
            // loc

        }

    }
    static int eval_count = 0;
    static int node_count = 0;

    /*
    * extract interesting relation names from difference
    * */
    public  void extractKeywords(List<InstancePair> ips, Set<String> relatedrelations, Set<String> possiblekeywords) {
        boolean first = true;
        for (InstancePair ip : ips) {
            if (ip.bugType != BugType.NO_BUG) {
                Difference diff = ip.findDiff();
                if( diff.notInCounter.size() + diff.notInExpected.size() == 0){
                    Set<String> skolems = ip.counter.skolems;
                    for(String var : skolems){
                        ip.difference.affectedVals.add(var);
                        if(!StringUtil.isInteger(var))
                            relatedrelations.add( StringUtil.findSigName(var) );
                       // relatedrelations.add();
                    }
                }
                relatedrelations.addAll(diff.getRelatedRelations());
                if (first) {
                    possiblekeywords.addAll(diff.getPossibleKeywords());
                    first = false;
                } else {
                    possiblekeywords.retainAll(diff.getPossibleKeywords());
                }
            }
        }
    }

    public  int calScore(Set<String> relatedrelations, Set<String> possiblekeywords,
                                Map<Exprn, Set<String>> node2keywords, List<InstancePair> ips){
        int collectnum = 0;
        for (Exprn node : node2keywords.keySet()) {
            node_count++;
            Set<String> words = new HashSet<>();
            words.addAll(relatedrelations);
            words.addAll(possiblekeywords);
            Set<String> keywords = new HashSet<>(node2keywords.get(node));
            keywords.retainAll(words);

            List<Exprn> suspiciousExprs = new ArrayList<>();
            if( keywords.size() > 0 ){
                suspiciousExprs.add(node);
                //evalExpr(node, ips);
                CollectSubExpr subexprs = new CollectSubExpr();
                node.accept(subexprs, null);
                //TODO: collect qt expressions
                for( Exprn e : subexprs.booleanExpr) {
                    evalBoolean(e, ips);
                    //analyBoolean((ExprnBinaryBool) e, ips);
                    if(!visited.contains(e)) {
                        analyexpr(e, ips);
                        visited.add(e);
                    }
                }
                if( subexprs.booleanExpr.size() == 0) {
                    for (Exprn e : subexprs.relationExpr) {
                        if (!visited.contains(e)) {
                            if (e instanceof ExprnVar || e instanceof ExprnSig || e instanceof ExprnField)
                                continue;
                            analyexpr(e, ips);
                            visited.add(e);
                        }
                    }
                }


                VisitedNodeCounter nc = new VisitedNodeCounter();
                node.accept(nc);
                collectnum += nc.count;
               /* for( Exprn e : subexprs.relationExpr) {
                    evalRelational(e, ips);
                }
                */
                /*
                for(InstancePair ip : ips){
                    instantiatedExpr(node, ip);
                }
                */
            }
        }
        return collectnum;
       // sortedMap.keySet().stream().forEach( key-> System.out.println(key + " " + String.format("%.2f", sortedMap.get(key))));
    }

    public void analyexpr(Exprn expr, List<InstancePair> ips){
        CollectSubExpr sc = new CollectSubExpr();
        expr.accept(sc, null);
        double score = 0.0;
        for( InstancePair ip : ips){
//            if( ip.difference.notInExpectedSigs.size() > 0 || ip.difference.notInCounterSigs.size() > 0)
//                ;
            Set<Exprn> subs = sc.relationExpr;
            AlloySolution counter = ip.counter;
            AlloySolution expected = ip.expected;
            Set<String> ints = new HashSet<>();
            for( String s : ip.counter.skolems) {
               if(StringUtil.isInteger(s))
                    ints.add(s);
            }
            Set<String> skolem = ip.difference.affectedVals;
            skolem.addAll(ints);
            Set<String> vals = new HashSet<>( ip.difference.affectedVals );
            Set<Map<String, String>> maps = calMap(skolem, ip.counter, ip);
            double mscore = 0.0;
            for (Map<String, String> m : maps) {
                Set<String> countervals = new HashSet<>();
                Set<String> expectvals = new HashSet<>();
                for( Exprn e : subs){
                    eval_count++;
                    String inst = e.getInstantiatedString(m);
                   //System.out.println(inst);
                    if( inst == null ){
                        continue;
                    }
                    for (String used : m.values()) {
                        if (inst.contains(used)) {
                            countervals.add(used);
                            expectvals.add(used);
                        }
                    }
                    // TODO : problem with # operator's instantiation some times no need to instantiate
                    // check to ensure the variables are legal
                    // System.out.println(inst);
                    if( ip.difference.notInCounterSigs.size() == 0)
                        countervals.addAll( counter.evalInstantiated(inst) );
                    if( ip.difference.notInExpectedSigs.size() == 0)
                        expectvals.addAll( expected.evalInstantiated(inst) );
                }
                if( subs.size() == 0)
                    continue;
                if( countervals.size() == 0 || expectvals.size() == 0)
                    mscore += 0;
                else {
                    double cscore = (double) vals.size() / countervals.size();
                    double escore = (double) vals.size() / expectvals.size();
                    mscore += (cscore + escore) / 2.0;
                }
            }
            if(maps.size() == 0) {
                score += mscore / 1;
            }
            else {
                score += mscore / maps.size();
            }
        }
        Double s = node2score.getOrDefault(expr, 0.0);
        //System.out.println(expr + "\t " + (s + score/ips.size()));
        node2score.put(expr, s + score / ips.size());
    }

    public void evalBoolean(Exprn expr, List<InstancePair> ips){
        for( InstancePair ip : ips) {
            if( ip.difference.notInExpectedSigs.size() > 0 || ip.difference.notInCounterSigs.size() > 0)
                continue;
            AlloySolution counter = ip.counter;
            AlloySolution expected = ip.expected;
            Set<String> skolem =  ip.difference.affectedVals; //counter.skolems == null ? ip.difference.affectedVals : counter.skolems;//
            Set<Map<String, String>> maps = new HashSet<>();
            //System.out.println(ip.difference);
            if( ip.difference.notInCounter.size() + ip.difference.notInExpected.size() == 0){
                Map<String, String> counter_map = new HashMap<>();
                for(ExprVar v : ip.counter.sol.getAllSkolems()){
                    String s = v.toString();
                    String name =  s.substring(s.lastIndexOf("_")+1, s.length()) ;
                    try {
                        A4TupleSet r = (A4TupleSet)ip.counter.sol.eval(v);
                        if(r==null || r.size()==0)
                            continue;
                        String val = r.iterator().next().toString();
                        counter_map.put(name, val);
                    } catch (Err err) {
                        err.printStackTrace();
                    }
                }
                maps = calSkolmizedMap(ip);
                String counterinst = expr.getInstantiatedString(counter_map);
                //System.out.println(counterinst);
                Boolean counter_res = counter.evalInstantiatedBoolean(counterinst);
                if(counterinst.contains("#")){
                    counter_res = false;
                }
                if(counter_res != null && !counter_res){
                for (Map<String, String> m : maps) {
                    eval_count++;
                    // System.out.println("expr: " + expr);
                    String inst = expr.getInstantiatedString(m);
                    Boolean expected_res = expected.evalInstantiatedBoolean(inst);
                    if(expected_res!=null && expected_res){
                        Double score = node2score.getOrDefault(expr, 0.0);
                        node2score.put(expr, score + 1.0);
                        if( expr.getParent() instanceof Exprn) {
                            Exprn parent = (Exprn)expr.getParent();
                            if( parent instanceof ExprnList) {
                                continue;
                            }

                            Double snew = node2score.getOrDefault(parent, 0.0);
                            node2score.put(parent, snew + 1.0);
                        }
                    }
                }
                }
                continue;
            }else
                maps = calMap(skolem, ip.counter, ip);

            for (Map<String, String> m : maps) {
                eval_count++;
               // System.out.println("expr: " + expr);
                String inst = expr.getInstantiatedString(m);

                Boolean counter_res = counter.evalInstantiatedBoolean(inst);
                Boolean expected_res = expected.evalInstantiatedBoolean(inst);
                if (counter_res != expected_res) {
 //                 System.out.println(counter_res + " not equal: " + expr + " " + inst);
//                   System.out.println(counter);
                    Double score = node2score.getOrDefault(expr, 0.0);
                    node2score.put(expr, score + 1.0);
                    if( expr.getParent() instanceof Exprn) {
                        Exprn parent = (Exprn)expr.getParent();
                        if( parent instanceof ExprnList) {
                            continue;
                        }

                        Double snew = node2score.getOrDefault(parent, 0.0);
                        node2score.put(parent, snew + 1.0);
                    }
                }
            }
        }
    }

    // TOFIX: only consider single skolem value
    public Set<Map<String, String>> calSkolmizedMap(InstancePair ip){
        List<List<Pair<String, String>>> listOfAllVars = new ArrayList<>();
        for(ExprVar v : ip.counter.sol.getAllSkolems()){
            List<Pair<String,String>> tmpList = new ArrayList<>();
            String s = v.toString();
            String name =  s.substring(s.lastIndexOf("_")+1, s.length()) ;
            try {
                A4TupleSet r = (A4TupleSet)ip.counter.sol.eval(v);
                if( r == null || r.size() == 0)
                    continue;
                String val = r.iterator().next().toString();
                if(StringUtil.isInteger(val)){
                    for(int i = 0; i < 7; i++){
                        tmpList.add(new Pair<>(name, String.valueOf(i)));

                    }
                }else{
                    tmpList.add(new Pair<>(name, val));
                }
            } catch (Err err) {
                err.printStackTrace();
            }
            listOfAllVars.add(tmpList);
        }
        Set<Map<String, String>> prev = new HashSet<>();
        for(List<Pair<String, String>> l : listOfAllVars){
            if(prev.isEmpty()){
                Map<String, String> cur = new HashMap<>();
                l.stream().forEach(p -> cur.put(p.a, p.b));
                prev.add(cur);
            }else{
                Set<Map<String, String>> current = new HashSet<>();
                for(Pair<String, String> pair : l){
                    for( Map<String, String> pre : prev ){
                        Map<String, String> p = new HashMap<>();
                        p.putAll(pre);
                        p.put(pair.a, pair.b);
                        current.add(p);
                    }
                }
                prev = current;
            }
        }
        return prev;
    }


    public Set<Map<String, String>> calMap(Set<String> skolems, AlloySolution sol, InstancePair ip){
        Map<String, Set<String>> skolemSig2Val = new HashMap();
        for( String skolem : skolems ){
            // add Int type skolem values
            if( StringUtil.isInteger(skolem)){
                // TODO: see ip.difference.findiff() for adding ints
                String relname = ip.difference.val2sig.get(skolem);
                if(relname == null)
                    relname = "Int";
                Set<String> vals = skolemSig2Val.get(relname);
                if( vals == null )
                    vals = new HashSet<>();
                vals.add(skolem);
                skolemSig2Val.put(relname, vals);
                // TODO: use this temporarily to avoid the problem of predicates with parameters, this need to be fixed
                Set<String> intvals = skolemSig2Val.get("Int");
                if( intvals == null)
                    intvals = new HashSet<>();
                intvals.add(skolem);
                skolemSig2Val.put("Int", intvals);
                continue;
            }
            // keep direct sig and parent sigs
            Set<String> sigNames = new HashSet<>();
            String sigName = StringUtil.findSigName(skolem);
            sigNames.add(sigName);
            // check if there is any parent
            Sig sig = sol.getSig(sigName);
            if( sig == null) {
                continue;
            }
            sigNames.addAll( AlloyUtil.findParentsNames(sig));
            for( String name : sigNames) {
                Set<String> vals = skolemSig2Val.get(name);
                if (vals == null)
                    vals = new HashSet<>();
                vals.add(skolem);
                skolemSig2Val.put(name, vals);
            }
        }

        Set<Map<String, String>> result = new HashSet<>();
        generateperm(result, skolemSig2Val, new ArrayList<>(skolemSig2Val.keySet()), 0, new HashMap());
        return result;
    }

    public void generateperm( Set<Map<String, String>> result, Map<String, Set<String>> maps, List<String> keys, int depth, Map current){
        if( depth == keys.size() ){
            result.add( new HashMap(current) );
            return;
        }
        String currentKey = keys.get(depth);
        Set<String> currentVals = maps.get(currentKey);
        for( String val : currentVals ){
            current.put(currentKey, val);
            generateperm( result, maps, keys, depth+1, current);
            current.remove(currentKey,val);
        }

    }


    public  boolean isBoolExpr(Exprn expr){
        return expr instanceof ExprnBinaryBool || expr instanceof ExprnCallBool || expr instanceof ExprnITEBool
                || expr instanceof ExprnListBool || expr instanceof ExprnQtBool || expr instanceof ExprnUnaryBool;
    }
}

//    public static void evalRelational(Exprn expr, List<InstancePair> ips){
//        for( InstancePair ip : ips) {
//            AlloySolution counter = ip.counter;
//            AlloySolution expected = ip.expected;
//            Set<String> skolem = ip.difference.affectedVals; //counter.skolems == null ? ip.difference.affectedVals : counter.skolems;
//            Set<String> vals = new HashSet<>( ip.difference.affectedVals );
//            Set<Map<String, String>> maps = calMap(skolem, ip.counter);
//            for (Map<String, String> m : maps) {
//                String inst = expr.getInstantiatedString(m);
//                // TODO: stupid way to remove used values
//                for( String s : m.values()){
//                    if( inst.contains(s) ){
//                        vals.remove(s);
//                    }
//                }
//                Set<String> counter_res = counter.evalInstantiated(inst);
//                Set<String> expected_res = expected.evalInstantiated(inst);
//                Set<String> res = new HashSet<>();
//                res.addAll(counter_res);
//                res.addAll(expected_res);
//                if (res.containsAll(vals)) {
//                    Double score = node2score.getOrDefault(expr, 0.0);
//                    node2score.put(expr, score + 1.0);
//                }
//            }
//        }
//    }
//
//    public static void analyBoolean(ExprnBinaryBool boolexpr, List<InstancePair> ips) {
//        Exprn left = boolexpr.getLeft();
//        Exprn right = boolexpr.getRight();
//        CollectSubExpr leftsubs = new CollectSubExpr();
//        left.accept(leftsubs, null);
//        CollectSubExpr rightsubs = new CollectSubExpr();
//        right.accept(rightsubs, null);
//        double s = 0.0;
//        for( InstancePair ip : ips ) {
//            Set<Exprn> lefts = leftsubs.relationExpr;
//            Set<Exprn> rights = rightsubs.relationExpr;
//            AlloySolution counter = ip.counter;
//            AlloySolution expected = ip.expected;
//            Set<String> skolem = ip.difference.affectedVals; //counter.skolems == null ? ip.difference.affectedVals : counter.skolems;
//            Set<String> vals = new HashSet<>( ip.difference.affectedVals );
//            Set<Map<String, String>> maps = calMap(skolem, ip.counter);
//            for (Map<String, String> m : maps) {
//                Set<String> leftvals_counter = new HashSet<>();
//                Set<String> leftvals_expected = new HashSet<>();
//                Set<String> rightvals_counter = new HashSet<>();
//                Set<String> rightvals_expected = new HashSet<>();
//                for (Exprn l : lefts) {
//                    String inst = l.getInstantiatedString(m);
//                    // TODO: stupid way to remove used values
//                    for (String used : m.values()) {
//                        if (inst.contains(used)) {
//                            leftvals_counter.add(used);
//                            leftvals_expected.add(used);
//                        }
//                    }
//                    Set<String> counter_res = counter.evalInstantiated(inst);
//                    Set<String> expected_res = expected.evalInstantiated(inst);
//                    leftvals_counter.addAll(counter_res);
//                    leftvals_expected.addAll(expected_res);
//                }
//
//                for (Exprn r : rights) {
//                    String inst = r.getInstantiatedString(m);
//                    // TODO: stupid way to remove used values
//                    for (String used : m.values()) {
//                        if (inst.contains(used)) {
//                            rightvals_counter.add(used);
//                            rightvals_expected.add(used);
//                        }
//                    }
//                    Set<String> counter_res = counter.evalInstantiated(inst);
//                    Set<String> expected_res = expected.evalInstantiated(inst);
//                    rightvals_counter.addAll(counter_res);
//                    rightvals_expected.addAll(expected_res);
//                }
//
//                double cscor = (double) vals.size() / (leftvals_counter.size() + rightvals_counter.size());
//                double escor = (double) vals.size() / (leftvals_expected.size() + rightvals_expected.size());
//                DecimalFormat df2 = new DecimalFormat("#.##");
//                s += (cscor + escor)/2;
//            }
//        }
//        Double score = node2score.getOrDefault(boolexpr, 0.0);
//        node2score.put(boolexpr, score + s/ips.size());
//
//    }