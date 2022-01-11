package tests;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class Reportor {
    String model;
    int loc;
    double time;
    int rel;
    int val;
    int sliced;
    int total;

    public Reportor(String model, int loc, int rel, int val, int sliced, int total, double time){
        this.model = model;
        this.loc = loc;
        this.rel = rel;
        this.val = val;
        this.sliced = sliced;
        this.total = total;
        this.time = time;
    }

    public void writeToCSV(String path){
        try(FileWriter fw = new FileWriter(path, true);
            BufferedWriter bw = new BufferedWriter(fw);
            PrintWriter out = new PrintWriter(bw);)

        {
            out.print(model + "," + loc + "," + rel + "," + val + ","+sliced+","+total+","+time+"\n");
        } catch (IOException e) {
            //exception handling left as an exercise for the reader
        }
    }
}
