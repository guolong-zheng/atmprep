one sig DLL {
  header: lone Node
}

sig Node {
  pre, nxt: lone Node,
  elem: Int
}

// All nodes are reachable from the header along the nxt.
fact Reachable {
  Node = DLL.header.*nxt
}

// Part (a)
fact Acyclic {
  // The list has no directed cycle along nxt, i.e., no node is
  // reachable from itself following one or more traversals along nxt.
  -- TODO: Your code starts here.
  no ^nxt & iden
}

// Part (b)
pred UniqueElem() {
  // Unique nodes contain unique elements.
  -- TODO: Your code starts here.
  // Fix: no disj n1, n2: Node | n1.elem = n2.elem
  all n:Node | one n.elem
}

// Part (c)
pred Sorted() {
  // The list is sorted in ascending order (<=) along nxt.
  -- TODO: Your code starts here.
  all n: DLL.header.*nxt | some n.nxt implies (n.elem <= n.nxt.elem)
}

// Part (d)
pred ConsistentPreAndNxt() {
  // For any node n1 and n2, if n1.nxt = n2, then n2.pre = n1; and vice versa.
  -- TODO: Your code starts here.
  nxt = ~pre
}

pred RepOk() {
  UniqueElem
  Sorted
  ConsistentPreAndNxt
}

run RepOk for 5
assert repair_assert_1 {
  UniqueElem <=> {no disj n1, n2: Node | n1.elem = n2.elem}
}
 check repair_assert_1
pred repair_pred_1 {
  UniqueElem <=> {no disj n1, n2: Node | n1.elem = n2.elem}
}
 run repair_pred_1
