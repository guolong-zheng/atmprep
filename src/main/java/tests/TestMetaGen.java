package tests;

import edu.mit.csail.sdg.alloy4.Err;

public class TestMetaGen {
    public static void main(String args[]){
        String path = "benchmark/a4f/classroom/inv10/classroom_inv10_15.als";
        PatcherTest pt = new PatcherTest();
        try {
            pt.repair(path);
        } catch (Err err) {
            err.printStackTrace();
        }
    }
}
