package compare;

import parser.ast.Exprn;

public class Priority {
    public Exprn node;
    public int relatedrelations;
    public int possiblerelations;
    public double score;

    public  Priority(Exprn node, int rr, int pk, double score){
        this.node = node;
        relatedrelations = rr;
        possiblerelations = pk;
        this.score = score;
    }

    public int compare(Priority that){
        int thisprio = (int) (10000 * relatedrelations + 1000 * possiblerelations +  score);
        int thatprio = (int) (10000 * that.relatedrelations + 1000 * that.possiblerelations +  that.score);
        return thatprio - thisprio;

        /*
         if( this.relatedrelations > that.relatedrelations )
             return -2;
         else if( this.possiblerelations > that.possiblerelations )
             return -1;
         else if( this.score > that.score)
             return 0;
         else
             return 1;
        */

    }

    public int getRelatedrelations() {
        return relatedrelations;
    }

    public void setRelatedrelations(int relatedrelations) {
        this.relatedrelations = relatedrelations;
    }

    public int getPossiblerelations() {
        return possiblerelations;
    }

    public void setPossiblerelations(int possiblerelations) {
        this.possiblerelations = possiblerelations;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String toString(){
        return node + "\t [" + "related: " + relatedrelations + " | " + "possible: " + possiblerelations + " | score: " + score + "]";
    }
}
