package tests;

import edu.mit.csail.sdg.alloy4.Err;
import synth.Patcher;

public class TestPatcher {
    public static void main(String[] args){
        String model = "benchmark/a4f/cv/cv_inv1_13.als";

        try {
            Patcher.repair(model);
        } catch (Err err) {
            err.printStackTrace();
        }
    }
}
