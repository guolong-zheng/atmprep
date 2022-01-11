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
  all n : Node - DLL.header | some nxt.n
}

// Part (a)
fact Acyclic {
  // The list has no directed cycle along nxt, i.e., no node is
  // reachable from itself following one or more traversals along nxt.
	no n:Node | n in n.^nxt
}

// Part (b)
pred UniqueElem() {
  // Unique nodes contain unique elements.
	all disj n1, n2 : Node | disj [n1.elem, n2.elem]
}

// Part (c)
pred Sorted() {
  // The list is sorted in ascending order (<=) along nxt.
  // Fix: all n: Node | some n.nxt => n.elem <= n.nxt.elem
	#Node.pre <= #Node.nxt
}

// Part (d)
pred ConsistentPreAndNxt() {
  // For any node n1 and n2, if n1.nxt = n2, then n2.pre = n1; and vice versa.
 	all n1, n2: Node | n1.nxt = n2 implies n2.pre = n1//As I understand p implies q means if p then q
	all n1, n2: Node | n2.pre = n1 implies n1.nxt = n2
}

pred RepOk() {
  UniqueElem
  Sorted
  ConsistentPreAndNxt
}

run RepOk for 5
assert repair_assert_1 {
  Sorted <=> all n : Node | some n.nxt => n.elem <= n.nxt.elem
}
 check repair_assert_1
pred repair_pred_1 {
  Sorted <=> all n : Node | some n.nxt => n.elem <= n.nxt.elem
}
 run repair_pred_1
