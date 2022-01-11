package util;

import edu.mit.csail.sdg.alloy4.Err;
import tests.PatcherTest;

import java.util.concurrent.*;

public class atrepair {

    public static void main(String[] args) {

        long time = System.currentTimeMillis();

        final Runnable stuffToDo = new Thread() {
            @Override
            public void run() {
                try {
                    PatcherTest.repair(args[0]);
                } catch (Err err) {
                    err.printStackTrace();
                    System.out.println(args[0] + "@-@-@F@-");
                }
            }
        };

        final ExecutorService executor = Executors.newSingleThreadExecutor();
        final Future future = executor.submit(stuffToDo);
        executor.shutdown(); // This does not cancel the already-scheduled task.

        try {
            future.get(10, TimeUnit.MINUTES);
        }
        catch (InterruptedException ie) {
            /* Handle the interruption. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println(args[0] + "@-@"+time/1000.0+"@F@-");
        }
        catch (ExecutionException ee) {
            /* Handle the error. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println(args[0] + "@-@"+time/1000.0+"@F@-");
        }
        catch (TimeoutException te) {
            /* Handle the timeout. Or ignore it. */
            System.out.println(args[0] + "@-@"+3600+"@F@-");
            System.exit(0);
        }
        if (!executor.isTerminated())
            executor.shutdownNow(); // If you want to stop the code that hasn't finished.

    }

}
