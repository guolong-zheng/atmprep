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
    // All elements in the n's left subtree are smaller than the n's elem.
    // Fix: replace n.left.elem with n.left.*(left+right).elem
    all x: n.left.elem | x < n.elem

    // All elements in the n's right subtree are bigger than the n's elem.
    all x: n.right.*(left+right).elem | x > n.elem
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
  #(n.~*(left+right))
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

assert repair_assert_1 {
  Sorted <=> {
      all n : Node {
        all nl: n.left.*(left + right) | nl.elem < n.elem
        all nr: n.right.*(left + right) | nr.elem > n.elem
      }
   }
}
 check repair_assert_1
pred repair_pred_1 {
  Sorted <=> {
    all n : Node {
      all nl: n.left.*(left + right) | nl.elem < n.elem
      all nr: n.right.*(left + right) | nr.elem > n.elem
    }
  }
}
 run repair_pred_1

