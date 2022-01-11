import compare.BugType;
import compare.Difference;
import compare.InstanceGenerator;
import compare.InstancePair;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.AModel;
import parser.ast.Node;
import parser.visitor.InfoCollector;
import parser.visitor.SliceVisitor;
import utility.AlloyUtil;

import java.util.*;

public class loc {

    public static void loc() throws Err {
        InstanceGenerator ig = new InstanceGenerator("benchmark/realbugs/balancedBST2_1.als");
        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs( ig.world.getAllCommands() );
        for( Pair<Command, Command> p : pairs) {
            List<InstancePair> ips = ig.genInstancePair(p.a, p.b, 5);
            for( InstancePair ip : ips){
                Set<String> keywords;
                Difference diff = ip.findDiff();

            }

        }
    }

    public static void main(String args[]) throws Err {
        long begin_time = System.currentTimeMillis();
        InstanceGenerator ig = new InstanceGenerator("benchmark/realbugs/balancedBST2_1.als");
        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs( ig.world.getAllCommands() );

        for(Pair<Command, Command> p : pairs) {
            List<InstancePair> ips = ig.genInstancePair(p.a, p.b, 5);
            for( InstancePair ip : ips) {
                if (ip.bugType == BugType.NO_BUG) {
                    System.out.println("No bug found!");
                } else if (ip.bugType == BugType.NO_EXPECT) {
                    System.out.println("No expected!");
                    System.out.println(ip.locations);
                } else {
                    System.out.println("BOTH");
                    System.out.println(ip.counter.toString());
                    System.out.println("====================");
                    System.out.println(ip.expected.toString());
                    Difference diff = ip.findDiff();
                    diff.calPrio();
                }
            }
            SliceVisitor sv = new SliceVisitor(p.a);

            AModel aModel = new AModel(ig.world);

            sv.visit(aModel);
            InfoCollector ic = new InfoCollector(sv.relatedPreds);
            ic.visit(aModel, null);

            locate(ic, Difference.priority);
            System.out.println("analyse time: " + (System.currentTimeMillis() - begin_time));
        }

    }

    public static void locate(InfoCollector ic, Map<String, Integer> priority){
        PriorityQueue<Pair<Node, Integer>> node2prio = new PriorityQueue<>(new Comparator<Pair<Node, Integer>>() {
            @Override
            public int compare(Pair<Node, Integer> o1, Pair<Node, Integer> o2) {
                return o2.b - o1.b;
            }
        });

        for(Node node : ic.node2keywrod.keySet()){
            List<String> keywords = ic.node2keywrod.get(node);
            int prio = 0;
            for( String keyword : keywords ){
                //   System.out.println(keyword);
                for( String target : priority.keySet()){
                    if( keyword.contains(target) )
                        prio += priority.get(target);
                    else
                        prio -= 1;
                }
                //  prio += priority.get(keyword)==null ? 0 : priority.get(keyword);
            }
            node2prio.add(new Pair<>(node, prio));
        }

        int i = 0;
        while( !node2prio.isEmpty()){
            Pair<Node, Integer> p = node2prio.poll();
            System.out.println(++i + " " + p.a.getAlloyNode().toString() + " " + p.b);
        }
        System.out.println("total number is: " + i );
    }

}
