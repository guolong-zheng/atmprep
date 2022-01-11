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
  all n: DLL.header.*nxt | n !in n.^nxt
}

// Part (b)
pred UniqueElem() {
  // Unique nodes contain unique elements.
  // Fix: remove ".*nxt"
  all n1, n2: Node | n1 = n2 or n1.*nxt.elem != n2.*nxt.elem
}

// Part (c)
pred Sorted() {
  // The list is sorted in ascending order (<=) along nxt.
  all n: Node | all n': n.nxt.*nxt.elem | n' >= n.elem
}

// Part (d)
pred ConsistentPreAndNxt() {
  // For any node n1 and n2, if n1.nxt = n2, then n2.pre = n1; and vice versa.
  all n1, n2: Node {
    n2.pre = n1 iff n1.nxt = n2
    n1.pre = n2 iff n2.nxt = n1
  }
}

pred RepOk() {
  UniqueElem
  Sorted
  ConsistentPreAndNxt
}

run RepOk for 5
assert repair_assert_1 {
  UniqueElem <=> all n1, n2: Node | n1 = n2 or n1.elem != n2.elem
}
 check repair_assert_1
pred repair_pred_1 {
  UniqueElem <=> all n1, n2: Node | n1 = n2 or n1.elem != n2.elem
}
 run repair_pred_1
