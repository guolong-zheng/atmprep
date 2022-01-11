package synth;

import parser.ast.Exprn;
import synth.syntaxtemplates.template.hole.Hole;

import java.util.*;

public class SearchStat {
    public List<HoleStat> holes;

    public String tmpltStr;

    ASolution sol;

    public SearchStat(List<Hole> hs){
        holes = new ArrayList<>();
        for( Hole h : hs ){
            HoleStat stat = new HoleStat(h, h.getValues());
            holes.add(stat);
        }
    }

    public SearchStat(int size){
        holes = new ArrayList<>(size);
    }

    public boolean hasNext(){
        if(holes.size() == 0)
            return false;
        HoleStat hs = holes.get(holes.size() - 1);
       // HoleStat hs = holes.get(0);
       // return hs.index <= hs.size;
        return hs.index <= hs.size;
    }

    public void nextStat(){
        for(int i = 0; i < holes.size(); ){
            HoleStat hs = holes.get(i);
            if(hs.index == hs.size){
                if( i == holes.size() - 1) {
                    hs.index++;
                    break;
                }
                hs.reset();
                i++;
            }else{
                hs.index++;
                break;
            }
        }
    }

    public SearchStat copy(){
        SearchStat ss = new SearchStat(holes.size());
        for(HoleStat hs : holes){
            HoleStat hole_cp = new HoleStat(hs);
            ss.holes.add(hole_cp);
        }
        return ss;
    }

    public boolean updateHoles(ASolution prev_sol, ASolution cur_sol){
        boolean newValue = false;
        for(HoleStat hole : holes) {
            String val = hole.getCurrentVal();
            List<Exprn> valid_exprns = prev_sol.val2exprs.get(val);

            // FIXME: potential improvement
            List<Exprn> cands = new LinkedList<>();
            for(Exprn e : valid_exprns){
                if(e.getType().equals(hole.hole.getType())){
                    cands.add(e);
                }
            }
            Set<String> res = cur_sol.evalExprns(cands);
            List<String> vals = new ArrayList<>();
            vals.addAll(res);

            if(res.size() > 1)
                newValue = true;
            else if (res.size() == 1) {
                if (!val.equals(res.iterator().next()))
                    newValue = true;
            }

            hole.update(vals);
            // System.exit(0);
        }
        return newValue;
    }

    public ASolution getSol(){
        return sol;
    }

    public void setSol(ASolution sol){
        this.sol = sol;
    }
}
