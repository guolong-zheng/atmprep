sig List {
    header: set Node
}

sig Node {
    link: set Node, 
    elem: set Int
}

// Correct
fact CardinalityConstraints {
    all l: List | lone l.header
    all n: Node | lone n.link
    all n: Node | one n.elem
}

// Overconstraint.  no header is not allowed given the fact allNodesBelongToOneList.
// Underconstraint. link = n1 -> n2 + n2 -> n3 + n3 -> n1 is allowed.
pred Loop(This: List) {
    // Fix: replace "&&" with "||" and replace "no n: Node | n = (n - This.header).link" with "no This.header".
    no n: Node | n = (n - This.header).link
    // Fix: replace "one n:Node | n.link = This.header" with "one n: This.header.*link | n = n.link".
    one n:Node | n.link = This.header
}

fact allNodesBelongToOneList{
    all n: Node | one l: List | n in l.header.*link
}

// Overconstraint, l.header = n1, link = n1->n2, elem = n1->1 + n2->2, not allowed.
pred Sorted(This: List) {
    all n: Node | some n.link => n.elem <= n.link.elem
}

run Sorted

pred RepOk(This: List) { 
    Loop[This]
    Sorted[This]
}

// Correct
pred Count(This: List, x: Int, result: Int) {
    RepOk[This]
    result = #{n: Node |  n in This.header.*link && n.elem = x}
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Correct
pred Contains(This: List, x: Int, result: Boolean) {
    RepOk[This]
    #{n: Node | n in This.header.*link && n.elem = x} > 0 => result = True else result = False
}

assert repair_assert_1 {
  all l : List | Loop[l] <=> (no l.header || one n : l.header.*link | n = n.link)
}
 check repair_assert_1
pred repair_pred_1 {
  all l : List | Loop[l] <=> (no l.header || one n : l.header.*link | n = n.link)
}
 run repair_pred_1
