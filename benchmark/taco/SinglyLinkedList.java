public class SinglyLinkedList {

    public /*@nullable@*/ SinglyLinkedListNode header;

    public SinglyLinkedList() { }

    /*@
      @ invariant (\forall SinglyLinkedListNode n; \reach(this.header, SinglyLinkedListNode, next).has(n); \reach(n.next, SinglyLinkedListNode, next).has(n)==false);
      @*/

    /*@
      @ requires this.header!=null;
      @ ensures (\exists SinglyLinkedListNode n; \reach(this.header, SinglyLinkedListNode, next).has(n); n.value==valueParam) <==> (\result==true);
      @ signals (RuntimeException e) false;
      @
      @*/
    public boolean contains(int valueParam)
    {
        SinglyLinkedListNode current = this.header.next; // buggy line
        boolean result = false;
        while (result == false && current != null) {
            if (current.value == valueParam) { 
                result = true;
            }
            current = current.next; 
        }
        return result;
    }

}
