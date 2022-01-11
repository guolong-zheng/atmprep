package utility;

import edu.mit.csail.sdg.alloy4.ConstList;
import edu.mit.csail.sdg.alloy4.Pair;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import parser.ast.*;

import java.util.*;
import java.util.stream.Collectors;

public class AlloyUtil {

    public static boolean isBuiltin(Sig sig) {
        return sig == Sig.UNIV || sig == Sig.GHOST || sig == Sig.NONE || sig == Sig.SEQIDX || sig == Sig.STRING;
    }

    public static List<Pair<Command, Command>> findCommandPairs(List<Command> commands){
        List<Pair<Command, Command>> pairs = new ArrayList<>();
        Map<Integer, Command> tmpMap = new HashMap<>();
        for( Command cmd : commands ){
            String name = cmd.label;
            if( name.contains("repair_") ){
                int idx = Integer.valueOf(name.split("_")[2]);
                Command tmpCmd = tmpMap.get(idx);
                if( tmpCmd == null ){
                    tmpMap.put(idx, cmd);
                }else{
                    if( cmd.check )
                        pairs.add(new Pair<>(cmd, tmpCmd));
                    else
                        pairs.add(new Pair<>(tmpCmd, cmd));
                }
            }
        }
        return pairs;
    }

    public static Set<String> findParentsNames(Sig sig){
        Set<String> sigNames = new HashSet<>();
        if (sig instanceof Sig.PrimSig) {
            Sig parent = ((Sig.PrimSig)sig).parent;
            if (parent!=null && !parent.builtin)
                sigNames.add( StringUtil.removeThis(parent.toString()) );
        } else {
            ConstList<Sig> parents = ((Sig.SubsetSig)sig).parents;
            for(Sig p: parents)
                sigNames.add(p.toString());
        }
        return sigNames;
    }

    public static String getStringByExprType(Exprn expr, Set<String> words){
        if(expr.toString().contains("."))
            for(String w : words){
                if(w.contains("."))
                    return w;
            }
        return words.stream().collect(Collectors.joining("."));
    }

    public static void count(NodeCounter nc, Exprn exprn){
        if(exprn instanceof ExprnBinaryBool)
            nc.visit((ExprnBinaryBool)exprn);
        if(exprn instanceof ExprnBinaryRel)
            nc.visit((ExprnBinaryRel) exprn);
        if(exprn instanceof ExprnCallBool)
            nc.visit((ExprnCallBool)exprn);
        if(exprn instanceof ExprnCallRel)
            nc.visit((ExprnCallRel)exprn);
        if(exprn instanceof ExprnConst)
            nc.visit((ExprnConst)exprn);
        if(exprn instanceof ExprnField)
            nc.visit((ExprnField)exprn);
        if(exprn instanceof ExprnITEBool)
            nc.visit((ExprnITEBool)exprn);
        if(exprn instanceof ExprnITERel)
            nc.visit((ExprnITERel)exprn);
        if(exprn instanceof ExprnLet)
            nc.visit((ExprnLet)exprn);
        if(exprn instanceof ExprnListBool)
            nc.visit((ExprnListBool)exprn);
        if(exprn instanceof ExprnListRel)
            nc.visit((ExprnListRel)exprn);
        if(exprn instanceof ExprnQtBool)
            nc.visit((ExprnQtBool)exprn);
        if(exprn instanceof ExprnQtRel)
            nc.visit((ExprnQtRel)exprn);
        if(exprn instanceof ExprnSig)
            nc.visit((ExprnSig)exprn);
        if(exprn instanceof ExprnVar)
            nc.visit((ExprnVar)exprn);
        if(exprn instanceof ExprnUnaryBool)
            nc.visit((ExprnUnaryBool)exprn);
        if(exprn instanceof ExprnUnaryRel)
            nc.visit((ExprnUnaryRel)exprn);
    }
}
