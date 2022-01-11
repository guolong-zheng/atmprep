package synth;

import synth.syntaxtemplates.template.hole.Hole;

import java.util.List;

public class HoleStat {
    public Hole hole;
    public List<String> values;
    int index;
    int size;
    public boolean visited;

    public HoleStat(Hole h, List<String> v){
        hole = h;
        values = v;
        index = 1;
        size = v.size();
        hole.setValue(v.get(0));
        visited = false;
    }

    public HoleStat(HoleStat stat){
        hole = stat.hole;
        values = stat.values;
        index = stat.index;
        size = stat.size;
        visited = false;
    }

    public String getValue(){
        return hole.value;
        //return values.get(index);
    }

    public void next(){
//        if( index == values.size() ) {
//            index = 0;
//            hole.setValue( values.get(0) );
//        }else{
        hole.setValue( values.get(index) );
        index++;
//        }
    }

    public void reset(){
        index = 1;
        hole.setValue( values.get(0) );
    }

    public String getCurrentVal(){
        return values.get(index - 1);
    }

    public void update(List<String> vals){
        index = 1;
        values = vals;
        size = vals.size();
        hole.setValue(vals.get(0));
    }
}
