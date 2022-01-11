sig List {
  header: set Node
}

sig Node {
  link: set Node,
  elem: set Int
}

fact {
  all n: Node | one l: List | n = l.header || n in l.header.^link 
}

// Correct.
fact CardinalityConstraints {
  all l:List | lone l.header
  all n:Node | lone n.link
  all n:Node | one n.elem
}

// Correct.
pred Loop(This: List) {
  no This.header || one n:This.header.*link | n in n.link
}

// Overconstraint.  Should allow no n.link
pred Sorted(This: List) {
  // Fix: Replace "n.elem <= n.link.elem" with "no n.link or n.elem <= n.link.elem"
  all n:Node | n.elem <= n.link.elem
}

pred RepOk(This: List) {
  Loop[This]
  Sorted[This]
}

// Correct.
pred Count(This: List, x: Int, result: Int) {
  RepOk[This]
  #{n:This.header.*link | x in n.elem} = result
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Correct.
pred Contains(This: List, x: Int, result: Boolean) {
  RepOk[This]
  x in This.header.*link.elem => result = True else result = False
}

assert repair_assert_1 {
    all l : List | Sorted[l] <=> all n: l.header.*link | some n.link => n.elem <= n.link.elem
}
 check repair_assert_1
pred repair_pred_1 {
    all l : List | Sorted[l] <=> all n: l.header.*link | some n.link => n.elem <= n.link.elem
}
 run repair_pred_1
