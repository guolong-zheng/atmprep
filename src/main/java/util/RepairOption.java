package util;

import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import parser.ast.AModel;

import java.util.List;

public class RepairOption {
    public AModel model;

    public List<Command> cmds;

    public String path;

    public int max_inst = 3;

    public int exprn_depth = 2;

    public int init_inst = 3;

    public RepairOption(){

    }

    public RepairOption(AModel model, List<Command> cmds, String path){
        this.model = model;
        this.cmds = cmds;
        this.path = path;
    }
}
