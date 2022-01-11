package compare.test;

import compare.InstanceGenerator;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;

public class TestInst {

    public static void main(String[] args){
        InstanceGenerator ig = new InstanceGenerator("examples/dll1.als");
        Command cmd1 = null;
        Command cmd2 = null;
        for(Command cmd : ig.world.getAllCommands()){
            if(cmd.check)
                cmd1 = cmd;
            else
                cmd2 = cmd;
        }
        ig.genInstancePair(cmd1, cmd2);
    }
}
