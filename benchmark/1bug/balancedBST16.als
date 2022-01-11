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
    all n2: Node | n = n2 or no n.(left + right) & n2.(left + right)

    // A node cannot have another node as both its left child and
    // right child.
    no n.left & n.right
  }
}

// Part (b)
pred Sorted() {
  all n: Node {
    // All elements in the n's left subtree are smaller than the n's elem.
    no n.left || all l: n.^left.*(left+right) | l.elem < n.elem

    // All elements in the n's right subtree are bigger than the n's elem.
    no n.right || all l: n.^right.*(left+right) | l.elem > n.elem
  }
}

// Part (c.1)
pred HasAtMostOneChild(n: Node) {
  // Node n has at most one child.
  lone n.(left + right)
}

fun ancestor[n: Node] : Node {
  n.*~(left + right)
}

// Part (c.2)
fun Depth(n: Node): one Int {
  // The number of nodes from the tree's root to n.
  # ( ancestor[n] ) 
}

// Part (c.3)
pred Balanced() {
  all n1, n2: Node {
    // If n1 has at most one child and n2 has at most one child,
    // then the depths of n1 and n2 differ by at most 1.
    // Hint: Be careful about the operator priority.
    // Fix: replace a-b with minus[a,b], and a+b with plus[a,b]
    n1=n2 || {
      HasAtMostOneChild[n1] && HasAtMostOneChild[n2] implies {
      Depth[n1] = Depth[n2] ||
      Depth[n1] - 1 = Depth[n2] ||
      Depth[n1] + 1 = Depth[n2]
      }
    }
  }
}

pred RepOk() {
  Sorted
  Balanced
}

run RepOk for 5

assert repair_assert_1 {
  Balanced <=> {
    all n1, n2 : Node {
      (HasAtMostOneChild[n1] && HasAtMostOneChild[n2]) => (let diff = minus[Depth[n1], Depth[n2]] | -1 <= diff && diff <= 1)
    }
  }
}
 check repair_assert_1
pred repair_pred_1 {
  Balanced <=> {
    all n1, n2 : Node {
      (HasAtMostOneChild[n1] && HasAtMostOneChild[n2]) => (let diff = minus[Depth[n1], Depth[n2]] | -1 <= diff && diff <= 1)
    }
  }
}
 run repair_pred_1
