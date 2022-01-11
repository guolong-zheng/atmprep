package compare;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

// compile and run Pardinus as another java program
public class Pardinus {
    static String workingDir = System.getProperty("user.dir") + "/pardinus";
    String file;

    public Pardinus(String file) {
        this.file = file;
    }

    public String getSolution() {
        compile(file);
        return execute(file);
    }

    private void compile(String file) {
      //  LOGGER.log("compiling");
        List<String> command = new LinkedList<>();
        command.add("javac");
        command.add("-cp");
        command.add("pardinus.jar:sat4j-maxsat.jar:.");
        command.add(file);
        run(command);
    }

    private String execute(String file) {
       // LOGGER.log("executing pardinus");
        List<String> command = new ArrayList<>();
        command.add("java");
        command.add("-cp");
        command.add("pardinus.jar:sat4j-maxsat.jar:" + workingDir);
        command.add(file.split("\\.")[0]);
        return run(command);
    }

    private String run(List<String> command) {
        String workingDir = System.getProperty("user.dir") + "/pardinus";
        ProcessBuilder pb = new ProcessBuilder(command);
        pb.directory(new File(workingDir));
        Process process;
        StringBuilder sb = new StringBuilder();
        try {
            process = pb.start();
            process.waitFor();

            InputStream is = process.getInputStream();
            InputStreamReader isr = new InputStreamReader(is);
            BufferedReader br = new BufferedReader(isr);
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
        }
        return sb.toString();
    }
}
