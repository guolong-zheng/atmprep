sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}


fact CardinalityConstraints {
    List.header.*link = Node
    all l: List | lone l.header
    all n: Node | lone n.link
    all n : Node | one n.elem
}

// Overconstraint.  no l.header should be fine.
pred Loop(This: List) {
    // Fix: add "no This.header".
    one n:This.header.*link | n in n.^link
}

// Overconstraint.  Should allow no n.link.
pred Sorted(This: List) {
    // Fix: replace "n.elem <= n.link.elem" with "some n.link => n.elem <= n.link.elem"
    all n : This.header.*link | n.elem <= n.link.elem
}

assert repair_assert_1 {
	all l: List | Sorted[l] <=> { all n: l.header.*link | some n.link => n.elem <= n.link.elem
}}
check repair_assert_1

pred repair_pred_1 {
    
	all l: List | Sorted[l] and { all n: l.header.*link | some n.link => n.elem <= n.link.elem
}}
run repair_pred_1

pred RepOk(This: List){
    Loop[This]
    Sorted[This]
}

// Correct
pred Count(This: List, x: Int, result: Int) {
    RepOk[This]
    result = #{n: This.header.*link | n.elem = x}
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Correct
pred Contains(This: List, x: Int, result: Boolean) {
     RepOk[This]
     x !in This.header.*link.elem <=> result = False
}

fact IGNORE {
  one List
  List.header.*link = Node
}
