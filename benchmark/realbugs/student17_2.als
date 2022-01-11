sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}

// Correct.
fact CardinalityConstraints {
    List.header.*link = Node
    all l: List | lone l.header
    all n: Node | lone n.link
    all n: Node | one n.elem
}

// Overconstraint.  Should allow no header
pred Loop(This: List) {
    // Fix: add "no This.header".
    one n: This.header.*link | n.link = n
}

// Overconstraint.  Should allow no n.link
pred Sorted(This: List) {
    all n: This.header.*link | n.elem <= n.link.elem
}

assert repair_assert_2 {
	all l: List | Loop[l] <=> {
	no l.header or one n: l.header.*link | n = n.link
}}
check repair_assert_2

pred repair_pred_2 {
	all l: List | Loop[l] <=> {
	no l.header or one n: l.header.*link | n = n.link
}}
run repair_pred_2

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
    result = True <=> x in This.header.*link.elem
}

pred RepOk(This: List) {
    Loop[This]
    Sorted[This]
}

fact IGNORE {
  one List
  List.header.*link = Node
}
