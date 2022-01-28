package util;

import edu.mit.csail.sdg.alloy4.Err;
import tests.PatcherTest;

import java.util.concurrent.*;

public class atrepair {

    public static void main(String[] args) {

        System.out.print(args[0]);
        long time = System.currentTimeMillis();

        final Runnable stuffToDo = new Thread() {
            @Override
            public void run() {
                try {
                    PatcherTest.repair(args[0]);
                } catch (Err err) {
                    err.printStackTrace();
                    System.out.println("@-@-@F@-");
                }
            }
        };

        final ExecutorService executor = Executors.newSingleThreadExecutor();
        final Future future = executor.submit(stuffToDo);
        executor.shutdown(); // This does not cancel the already-scheduled task.

        try {
            future.get(60, TimeUnit.MINUTES);
        }
        catch (InterruptedException ie) {
            /* Handle the interruption. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println("@-@"+time/1000.0+"@F@-");
        }
        catch (ExecutionException ee) {
            /* Handle the error. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println("@-@"+time/1000.0+"@F@-");
        }
        catch (TimeoutException te) {
            /* Handle the timeout. Or ignore it. */
            System.out.println("@-@"+3600+"@F@-");
            System.exit(0);
        }
        if (!executor.isTerminated())
            executor.shutdownNow(); // If you want to stop the code that hasn't finished.

    }


    public static void runone(String file){
        long time = System.currentTimeMillis();

        final Runnable stuffToDo = new Thread() {
            @Override
            public void run() {
                try {
                    System.out.print(file+" ");
                    PatcherTest.repair(file);
                } catch (Err err) {
                    err.printStackTrace();
                    System.out.println(file + "@-@-@F@-");
                }
            }
        };

        final ExecutorService executor = Executors.newSingleThreadExecutor();
        final Future future = executor.submit(stuffToDo);
        executor.shutdown(); // This does not cancel the already-scheduled task.

        try {
            future.get(60, TimeUnit.MINUTES);
        }
        catch (InterruptedException ie) {
            /* Handle the interruption. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println(file + "@-@"+time/1000.0+"@F@-");
        }
        catch (ExecutionException ee) {
            /* Handle the error. Or ignore it. */
            time = System.currentTimeMillis() - time;
            System.out.println(file + "@-@"+time/1000.0+"@F@-");
        }
        catch (TimeoutException te) {
            /* Handle the timeout. Or ignore it. */
            System.out.println(file + "@-@"+3600+"@F@-");
            System.exit(0);
        }
        if (!executor.isTerminated())
            executor.shutdownNow(); // If you want to stop the code that hasn't finished.
    }
}
