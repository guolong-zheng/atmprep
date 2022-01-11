package compare.test;

import compare.BugType;
import compare.Difference;
import compare.InstanceGenerator;
import compare.InstancePair;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.AModel;
import parser.visitor.InfoCollector;
import parser.visitor.SliceVisitor;
import utility.AlloyUtil;

import java.io.IOException;
import java.util.List;

//import edu.mit.csail.sdg.ast.Command;

public class DiffTest {

    public static void main(String[] args) throws IOException {
        long begin_time = System.currentTimeMillis();
        InstanceGenerator ig = new InstanceGenerator("finder/realbugs/fsm1.als");
        List<Pair<Command, Command>> pairs = AlloyUtil.findCommandPairs( ig.world.getAllCommands() );
        for(Pair<Command, Command> p : pairs) {

            InstancePair ip = ig.genInstancePair(p.a, p.b);
            if( ip.bugType == BugType.NO_BUG ){
                System.out.println("No bug found!");
            }
            else if( ip.bugType == BugType.NO_EXPECT ) {
                System.out.println(ip.locations);
            }else {
                System.out.println(ip.counter.toString());
                System.out.println("====================");
                System.out.println(ip.expected.toString());
                Difference diff = ip.findDiff();
                diff.calPrio();

                SliceVisitor sv = new SliceVisitor(p.a);

                // ip.ce2map(ig.counterExample);
                //  ip.difference.calculatePrio(ip.difference.notInIncByName);
                //  ip.difference.calculatePrio(ip.difference.notInCounterByName);

                AModel aModel = new AModel(ig.world);

                sv.visit(aModel);
                InfoCollector ic = new InfoCollector(sv.relatedPreds);
                ic.visit(aModel, null);

               //diff.locate(ic);
            }
            System.out.println("analyse time: " + (System.currentTimeMillis() - begin_time));
        }

    }
}
