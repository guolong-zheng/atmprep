one sig List {
  header: set Node
}

sig Node {
  link: set Node,
  elem: set Int
}

fact {
	all n : Node | n in List.header.*link and n.elem > 0
}

// Correct
fact CardinalityConstraints {
  all l:List | lone l.header
  all n:Node | lone n.link
  all n:Node | one n.elem
}

// Correct
pred Loop(This: List) {
  no This.header || one n:This.header.^link | n = n.link
}

// Underconstraint, should consider link = n1 -> n2 without loop
pred Sorted(This: List) {
  // Fix: replace "n.elem <= n.link.elem" with "some n.link => n.elem <= n.link.elem".
  all n:(This.header.*link) | n.elem <= n.link.elem
}

pred RepOk(This: List) {
  Loop[This]
  Sorted[This]
}

// Correct
pred Count(This: List, x: Int, result: Int) {
  RepOk[This]
  result = #{n: This.header.*link | n.elem = x}
}

abstract sig Boolean {}
one sig True, False extends Boolean{}

// Correct
pred Contains(This: List, x: Int, result: Boolean) {
  RepOk[This]
  x in This.header.*link.elem => result = True else result = False
}

assert repair_assert_1 {
    all l : List | Sorted[l] <=> all n: l.header.*link | some n.link => n.elem <= n.link.elem
}
 check repair_assert_1 for 6
pred repair_pred_1 {
    all l : List | Sorted[l] <=> all n: l.header.*link | some n.link => n.elem <= n.link.elem
}
 run repair_pred_1 for 6