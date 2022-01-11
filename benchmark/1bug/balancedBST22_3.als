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
	-- TODO: Your code starts here.
        all bt: BinaryTree | n in bt.root.*(left + right) implies n !in n.^(left + right) 
	// A node cannot have more than one parent. 
	-- TODO: Your code starts here.
        lone n.~(left + right)
	// A node cannot have another node as both its left child and // right child.
	-- TODO: Your code starts here.
        all n2: Node | (n2 = n.left implies n2 != n.right) and (n2 = n.right implies n2 != n.left)
	} 
}

// Part (b)
pred Sorted() {
	// All elements in the n’s left subtree are smaller than the n’s elem. 
	-- TODO: Your code starts here.
	all n: Node {
		all n2: Node | n2 in n.left.*(left + right) implies n2.elem < n.elem
	}
	// All elements in the n’s right subtree are bigger than the n’s elem.
	-- TODO: Your code starts here.
	all n: Node {
		all n2: Node | n2 in n.right.*(left + right) implies n2.elem > n.elem
	}
}

// Part (c.1)
pred HasAtMostOneChild(n: Node) { 
	// Node n has at most one child. -- TODO: Your code starts here.
	no n.left or no n.right
}


// Part (c.2)
fun Depth(n: Node): one Int {
	// The number of nodes from the tree’s root to n. 
	-- TODO: Your code starts here.
  #{n.*~(left + right)}
}

// Part (c.3)
pred Balanced() { 
	all n1, n2: Node {
          // If n1 has at most one child and n2 has at most one child, 
          // then the depths of n1 and n2 differ by at most 1.
          -- TODO: Your code starts here.
          // Fix: use HasAtMostOneChild[n1] and HasAtMostOneChild[n2] implies (minus[Depth[n1], Depth[n2]] = 1 or minus[Depth[n1], Depth[n2]] = 0 or minus[Depth[n1], Depth[n2]] = -1)
          // However, replace a-b with minus[a,b] also works in this case.
          HasAtMostOneChild[n1] and HasAtMostOneChild[n2] implies Depth[n1] - Depth[n2] = 1 or Depth[n1] - Depth[n2] = 0 or Depth[n1] - Depth[n2] = -1
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
  #left > 2
  #right > 2
  Balanced <=> {
    all n1, n2 : Node {
      (HasAtMostOneChild[n1] && HasAtMostOneChild[n2]) => (let diff = minus[Depth[n1], Depth[n2]] | -1 <= diff && diff <= 1)
    }
  }
}
 run repair_pred_1
