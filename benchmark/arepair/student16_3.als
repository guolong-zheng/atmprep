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

// Underconstraint.
pred Loop(This: List) {
  no This.header or one n: This.header.*link | n = n.link
}

// Underconstraint.
pred Sorted(This: List) {
  all n: This.header.*link | no n.link or n.elem <= n.link.elem
}

pred RepOk(This: List) {
     Loop[This]
     Sorted[This]
}

// Underconstraint.
pred Count(This: List, x: Int, result: Int) {
     RepOk[This]
     result = #{n: This.header.*link | n.elem = x}
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Underconstraint.
pred Contains(This: List, x: Int, result: Boolean) {
     RepOk[This]
     // Fix: add "(some n: This.header.*link | n.elem = x) => result = True else result = False".
}
assert repair_assert_1 {
    all l : List | all x : Int | RepOk[l] and Contains[l, x, True] <=> 
        RepOk [l] and
        ( x in l.header.*link.elem )
}
 check repair_assert_1
pred repair_pred_1 {
    all l : List | all x : Int | RepOk[l] and Contains[l, x, True] <=> 
        RepOk [l] and
        ( x in l.header.*link.elem )
}
 run repair_pred_1
