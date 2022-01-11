package util;

public class RepairReporter {
    public boolean isfix;
    public String model;
    public String exprn;
    public long time;

    public RepairReporter(boolean isfix){
        this.isfix = isfix;
    }

    public RepairReporter(String model, String exprn){
        isfix = true;
        this.model = model;
        this.exprn = exprn;
    }

    public void fixed(String model, String exprn){
        isfix = true;
        this.model = model;
        this.exprn = exprn;
    }

    public void fixed(RepairOption opt){
        isfix = true;
        this.model = opt.model.toString();
    }
}
