package parser.visitor;

public interface Visitable {

    <R, V> R accept(GenericVisitor<R, V> visitor, V arg);

    void accept(VoidVisitor visitor);

}
