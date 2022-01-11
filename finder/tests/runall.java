package tests;

import edu.mit.csail.sdg.alloy4.Err;
import utility.FileUtil;

import java.nio.file.Path;

public class runall {
    public static void main(String[] args) throws Err {
        String path = "benchmark/experiment/realbugs/";
        boolean start = true;
        for (Path p : FileUtil.readAllFiles(path)) {
            String modelPath = p.toString();
//            if (modelPath.equals("benchmark/experiment/realbugs/student18_2.als"))
//                start = true;
            if (start) {
                Locator l = new Locator(true);
//                System.out.println("start " + modelPath);
                l.localize(modelPath, 5);
            }
        }
    }
}

