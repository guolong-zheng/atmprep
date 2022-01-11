package mutation;

public class Mutant {
    int depth;

    String original;

    String mutated;

    String modelStr;

    public Mutant(String str, int depth){
        this.depth = depth;
        this.modelStr = str;
    }
}
