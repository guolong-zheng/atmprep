package util;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Expr;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import parser.ast.*;
import synth.syntaxtemplates.printers.TemplateCommandPrinter;
import synth.syntaxtemplates.structures.Template;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class SynthUtil {

    public static boolean notSym(ExprnBinaryBool.Op op){
        return op == ExprnBinaryBool.Op.IN || op == ExprnBinaryBool.Op.NOT_IN || op == ExprnBinaryBool.Op.IMPLIES;
    }

    public static Exprn getExprn(AModel world, String filename) {
        List<String> allLines = null;
        try {
            String file = filename.replace("1bug", "bugexpr");
            allLines = Files.readAllLines(Paths.get(file));
        } catch (IOException e) {
            e.printStackTrace();
        }
        String expr = allLines.get(0);
        Expr buggyline = null;
        try {
            buggyline = world.origModel.parseOneExpressionFromString(expr);
        } catch (Err err) {
            err.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        FindExpr fe = new FindExpr(world, Exprn.parseExpr(null, buggyline).toString());

        return fe.find();
    }

    public static boolean inFact(Exprn expr){
        Node parent = expr.getParent();
        while(parent instanceof Exprn ){
            parent = parent.getParent();
        }
        return (parent instanceof Fact);
    }

    public static String printTemplate(AModel model, TemplateCommandPrinter tp, Template template){
        return tp.pre.append(tp.append).toString();
    }

    public static int muNum = 0;

    public static void writeToFile(AModel model){
        String fname = "mutation" + muNum++;
        File file = new File(fname);
        BufferedWriter bw = null;
        try {
            bw = new BufferedWriter(new FileWriter(file));
            bw.write(model.toString());
        } catch (IOException ignored) {
        } finally {
            if (bw != null) {
                try {
                    bw.close();
                } catch (IOException ignored) {
                }
            }
        }
    }

    public static boolean check(RepairOption opt){
        String str = opt.model.toString();
       // if(str.contains("all i: one ((Element . ~((Array . i2e)))) | (i >= 0 && i < (Array . length))")){
  //          System.out.println("=======\n" + str);
//            System.exit(0);
       // }
        List<Command> cmds = opt.cmds;
        CompModule world = null;
        try {
            world = CompUtil.parseEverything_fromString(new A4Reporter(), str);
            for (Command cmd : world.getAllCommands()) {
                for(Command pred : cmds)
                 if(cmd.label.equals(pred.label) && cmd.label.contains("repair")) {
                    A4Solution sol = TranslateAlloyToKodkod.execute_command(new A4Reporter(), world.getAllReachableSigs(), cmd, new A4Options());
                    if(cmd.check && sol.satisfiable()  ||
                            (!cmd.check && !sol.satisfiable()) ){
                        return false;
                    }
                }
            }
        } catch (Err err) {
            //err.printStackTrace();
            return false;
        }
        return true;
    }

    public static ExprnBinaryRel.Op[] getBinaryRelOpValues(){
        return new ExprnBinaryRel.Op[]{ExprnBinaryRel.Op.ARROW, ExprnBinaryRel.Op.JOIN, ExprnBinaryRel.Op.DOMAIN, ExprnBinaryRel.Op.RANGE, ExprnBinaryRel.Op.INTERSECT, ExprnBinaryRel.Op.PLUS, ExprnBinaryRel.Op.IPLUS, ExprnBinaryRel.Op.MINUS, ExprnBinaryRel.Op.IMINUS, ExprnBinaryRel.Op.MUL, ExprnBinaryRel.Op.DIV, ExprnBinaryRel.Op.REM, ExprnBinaryRel.Op.SHL, ExprnBinaryRel.Op.SHR};
    }
}
