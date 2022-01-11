one sig BinaryTree {
  root: lone Node
}

sig Node {
  left, right: lone Node,
  elem: Int
}

// All nodes are in the tree.
fact Reachable {
  Node = BinaryTree.root.*(left + right)
}

// Part (a)
fact Acyclic {
  all n : Node {
    // There are no directed cycles, i.e., a node is not reachable
    // from itself along one or more traversals of left or right.
    n !in n.^(left + right)

    // A node cannot have more than one parent.
    lone n.~(left+right)

    // A node cannot have another node as both its left child and
    // right child.
    disj [n.left, n.right]
  }
}

// Part (b)
pred Sorted() {
  all n: Node {
    all n2:n.left.*(left + right) | n2.elem < n.elem
    all n2:n.right.*(left + right) | n2.elem > n.elem
  }
}

// Part (c.1)
pred HasAtMostOneChild(n: Node) {
  // Node n has at most one child.
  lone n.(left+right)
}

// Part (c.2)
fun Depth(n: Node): one Int {
  // The number of nodes from the tree's root to n.
  // Fix: replace ^ with *
  #(n.~^(left+right))
}

// Part (c.3)
pred Balanced() {
  all n1, n2: Node {
    // If n1 has at most one child and n2 has at most one child,
    // then the depths of n1 and n2 differ by at most 1.
    // Hint: Be careful about the operator priority.
    (n1.HasAtMostOneChild and n2.HasAtMostOneChild) => (
      (Depth[n1].sub[Depth[n2]] ) <= 1 and (Depth[n2].sub[Depth[n1]] ) <= 1 
      )
  }
}

pred RepOk() {
  Sorted
  Balanced
}

run RepOk for 5

pred depthok {
	all n : Node | Depth[n] = #(n.*~(left + right))
}

run RepOk for 5
assert repair_assert_1 {
 depthok
}
 check repair_assert_1
pred repair_pred_1 {
  some Node
  depthok
}
 run repair_pred_1
