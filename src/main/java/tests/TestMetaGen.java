package tests;

import edu.mit.csail.sdg.alloy4.Err;

public class TestMetaGen {
    public static void main(String args[]){
        String path = "benchmark/1bug/addr.als";
        PatcherTest pt = new PatcherTest();
        try {
            pt.repair(path);
        } catch (Err err) {
            err.printStackTrace();
        }
    }
}
