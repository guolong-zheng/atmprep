package tests;

import compare.*;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.AModel;
import parser.ast.Exprn;
import parser.visitor.Instantiator;
import parser.visitor.KeywordCollector;
import parser.visitor.SliceVisitor;
import utility.AlloyUtil;
import utility.LOGGER;

import java.util.*;

public class oldlocator {
    public static void main(String[] args) throws Err {
        {
            //LOGGER.setLevel(LOGGER.Level.Debug);
            long beginTime = System.currentTimeMillis();
            InstanceGenerator ig = new InstanceGenerator("benchmark/robots/r1.als");
            List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs(ig.world.getAllCommands());
            for (Pair<Command, Command> p : pairs) {
                List<InstancePair> ips = ig.genInstancePair(p.a, p.b, 5);

                // for( InstancePair ip : ips) {
                //     if( ip.bugType == BugType.NO_EXPECT || ip.bugType == BugType.NO_BUG)
                //         continue;
                // extract relatedrelations and find possible keywords
                Set<String> relatedrelations = new HashSet<>();
                Set<String> possiblekeywords = new HashSet<>();
                extractKeywords(ips, relatedrelations, possiblekeywords);

                System.out.println(relatedrelations.toString());
                System.out.println(possiblekeywords.toString());

                // slice alloy model to find related pred and func for the corresponding command
                SliceVisitor sv = new SliceVisitor(p.a);
                AModel aModel = new AModel(ig.world);
                sv.visit(aModel);

                // collect keywords
                KeywordCollector kc = new KeywordCollector(sv.relatedPreds);
                kc.visit(aModel, null);

                // calculate priority based on difference and keywords
                calculatePriority(relatedrelations, possiblekeywords, kc.node2keyword, ips);

                System.out.println("--------------------------");
                // }
            }
            long analyseTime = System.currentTimeMillis() - beginTime;
            System.out.println("analyze time: " + analyseTime);
        }

    }

    /*
    * extract interesting relation names from difference
    * */
    public static void extractKeywords(List<InstancePair> ips, Set<String> relatedrelations, Set<String> possiblekeywords) {

        boolean first = true;
        for (InstancePair ip : ips) {
            if (ip.bugType != BugType.NO_BUG) {
                Difference diff = ip.findDiff();
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

    public static void calculatePriority(Set<String> relatedrelations, Set<String> possiblekeywords,
                                         Map<Exprn, Set<String>> node2keywords, List<InstancePair> ips) {
        // Map<String, Priority> prios = new HashMap<>();
        PriorityQueue<Priority> prios = new PriorityQueue<>(Comparator.comparing(Priority::getRelatedrelations).
                thenComparing(Priority::getPossiblerelations).thenComparing(Priority::getScore).reversed()

                /*new Comparator<Priority>() {
            @Override
            public int compare(Priority o1, Priority o2) {
                return o1.compare(o2);
            }

        }*/);

        for (Exprn node : node2keywords.keySet()) {
            Set<String> keywords = new HashSet<>(node2keywords.get(node));
            keywords.retainAll(relatedrelations);
            int rr = keywords.size();

            // keywords = new HashSet<>( node2keywords.get(node) );
            // keywords.retainAll( possiblekeywords );
            int pk = 0;
            for (String word : possiblekeywords) {
                if (node.toString().contains(word))
                    pk++;
            }
            // int pk = keywords.size();

            double score = evalExprn(node, ips);

            Priority prio = new Priority(node, rr, pk, score);
            prios.add(prio);
            //  prios.put(node, prio);
        }

        int nodesNum = prios.size();
        int rank = 0;
        /*
        Iterator<Priority> it = prios.iterator();
        while(it.hasNext()){
            Priority p = it.next();
            System.out.println(++rank + " " + p.toString());
        }*/

        while (!prios.isEmpty()) {
            Priority p = prios.poll();
            System.out.println(++rank + " " + p.toString());
        }

        System.out.println("total nodes: " + nodesNum);
    }

    public static void calScore(Set<String> relatedrelations, Set<String> possiblekeywords,
                                Map<Exprn, Set<String>> node2keywords, List<InstancePair> ips){
        for (Exprn node : node2keywords.keySet()) {
            Set<String> words = new HashSet<>();
            words.addAll(relatedrelations);
            words.addAll(possiblekeywords);
            Set<String> keywords = new HashSet<>(node2keywords.get(node));
            keywords.retainAll(words);

            if( keywords.size() > 0 ){
                System.out.println(node);
            }

        }
    }

    // calculate priority of an expr based on a set of instance pair
    public static double evalExprn(Exprn expr, List<InstancePair> ips) {
        double score = 0;
        /*if (expr.toString().equals("all n, l: one (Name) | l in lookup[b,n] => l in (b.entry)") ||
                expr.toString().equals("all b: one (Book) | all n, l: one (Name) | l in lookup[b,n] => l in (b.entry)") ||
                expr.toString().equals("all n: one ((b.entry)) | lone ((n.(b.listed)))")
                )
                */
            for (InstancePair ip : ips) {
                if( ip.bugType != BugType.NO_BUG && ip.bugType != BugType.NO_EXPECT) {
                    AlloySolution counter = ip.counter;
                    Set<String> skolem = counter.skolems;
                    // if no skolem vairables, use the difference variables
                    if (skolem == null) {
                        skolem = ip.difference.affectedVals;
                    }
                    Instantiator it = new Instantiator(counter, skolem);
                    expr.accept(it, true);
                    for (String str : it.instatiatedExprs) {
                        // evaluate the instantiated expression to get its possible values
                        Set<String> vals = ip.eval(str);
                        LOGGER.logDebug(oldlocator.class, "instantiated expr:[" + str + "] evals to \t " + vals.toString());
                        score += ip.difference.compare(str, vals);
                    }
                }
            }
        return score;
    }
}
