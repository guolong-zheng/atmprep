package utility;


import java.util.logging.Logger;

public final class LOGGER {
    private static final Logger logger = Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);

    private static Level logLevel = Level.No;

    private static long time = 0;

    public enum Level {
        No(0),
        Info(1),
        Debug(2);

        private int order;

        private Level(int order){
            this.order = order;
        }

        public boolean isLog(Level level){
            return this.order >= level.order;
        }
    }

    public static void setTimer(){
        time = System.currentTimeMillis();
    }

    public static long getTime(){
        return System.currentTimeMillis() - time;
    }

    public static void setLevel(Level level){
        logLevel = level;
    }

    public static void logInfo(Class clazz, String msg) {
        if(logLevel.isLog(Level.Info))
            log(Level.Info, clazz, msg);
    }

    public static void logDebug(Class clazz, String msg) {
        if(logLevel.isLog(Level.Debug))
            log(Level.Debug, clazz, msg);
    }

    private static void log(Level level, Class clazz, String msg) {
        String message = String.format("[%s] : %s", clazz, msg);
        switch (level) {
            case Info:
                logger.info(message);
                break;
            case Debug:
                logger.warning(message);
        }
    }

}
