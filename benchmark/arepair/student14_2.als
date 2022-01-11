sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}

// Overconstraint.  Should be lone l.header and lone n.link
fact CardinalityConstraints {
    all l: List | lone l.header
    all n: Node | lone n.link
    all n: Node | one n.elem
}

// Overconstraint.  Should allow no header.
pred Loop(This: List){
    // Fix: add "no This.header".
    one n: This.header.*link | n in n.^link
}

// Overconstraint.  Should allow no n.link
pred Sorted(This: List){
    all n: This.header.*link | some n.link => n.elem <= n.link.elem
}

pred RepOk(This: List){
    Loop[This]
    Sorted[This]
}

// Correct
pred Count(This: List, x: Int, result: Int){
    RepOk[This]
    result = #{ n: This.header.*link | x = n.elem }
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Correct
pred Contains(This: List, x: Int, result: Boolean) {
    RepOk[This]
    result = True <=> x in This.header.*link.elem
}

fact f {
     List.header.*link= Node
}

assert repair_assert_1 {
  all l : List | Loop[l] <=> (no l.header || one n : l.header.*link | n.^link = n.*link)
}
 check repair_assert_1
pred repair_pred_1 {
  all l : List | Loop[l] <=> (no l.header || one n : l.header.*link | n.^link = n.*link)
}
 run repair_pred_1
