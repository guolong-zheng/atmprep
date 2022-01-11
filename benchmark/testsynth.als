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

fact{
  #Node = 3
}

// Part (a)
fact Acyclic {
  // The list has no directed cycle along nxt, i.e., no node is
  // reachable from itself following one or more traversals along nxt.
  -- TODO: Your code starts here.
  all n: DLL.header.*nxt | n !in n.^nxt
}

// Part (b)
pred UniqueElem() {
  // Unique nodes contain unique elements.
  -- TODO: Your code starts here.
  // Note: This is correct with Acyclic fact.
  all n: DLL.header.*nxt | n.elem !in n.^nxt.elem
}

// Part (c)
pred Sorted() {
  // The list is sorted in ascending order (<=) along nxt.
  -- TODO: Your code starts here.
  // Fix: repalce n.elem <= n.nxt.elem with some n.nxt => n.elem <= n.nxt.elem
  all n: DLL.header.*nxt | n.elem <= n.nxt.elem
}

// Part (d)
pred ConsistentPreAndNxt() {
  // For any node n1 and n2, if n1.nxt = n2, then n2.pre = n1; and vice versa.
  -- TODO: Your code starts here.
  all n1, n2: DLL.header.*nxt | (n1 = n2.nxt) <=> (n2 = n1.pre)
}

pred RepOk() {
  UniqueElem
  Sorted
  ConsistentPreAndNxt
}

assert repair_assert_1 {
  Sorted <=> all n : Node | some n.nxt => n.elem <= n.nxt.elem
}
 check repair_assert_1
pred repair_pred_1 {
  Sorted <=> all n : Node | some n.nxt => n.elem <= n.nxt.elem
}
 run repair_pred_1
