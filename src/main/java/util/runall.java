package util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class runall {
    public static void main(String[] args){
        String path = "benchmark/a4f/classroom/";
        final File folder = new File(path);
        Set<String> visited = new HashSet<>();

        boolean start = true;
        for (String p : listFilesForFolder(folder)) {
            String modelPath = path+p;
//            if (modelPath.equals("benchmark/experiment/realbugs/student18_2.als"))
//                start = true;
          //  if (start) {

            atrepair.runone(modelPath);
            //}
        }
    }

    public static List<String> listFilesForFolder(final File folder) {
        List<String> files = new ArrayList<>();
        for (final File fileEntry : folder.listFiles()) {
            if (fileEntry.isDirectory()) {
                listFilesForFolder(fileEntry);
            } else {
                files.add(fileEntry.getName());
            }
        }
        return files;
    }

}
