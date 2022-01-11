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
  n !in n.^(left + right)

    // A node cannot have more than one parent.
    -- TODO: Your code starts here.
 
  		 //no n1, n2:Node | n in n1.(left + right) and n in n2.(left + right) and n1 != n2
    
  all n1, n2:Node |
		n in n1.(left+right) 
		and n in n2.(left+right)
			=> n1 = n2
    // A node cannot have another node as both its left child and
    // right child.
    -- TODO: Your code starts here.
  no n1:Node | n1 in n.left and n1 in n.right
  }
}

// Part (b)
pred Sorted() {
  all n: Node {
    // All elements in the n's left subtree are smaller than the n's elem.
    -- TODO: Your code starts here.
  
		  //no n1:Node.left.*(left+right) | n1.elem >= n.elem
  all n1: n.left.*(left + right) | n1.elem < n.elem


    // All elements in the n's right subtree are bigger than the n's elem.
    -- TODO: Your code starts here.
  		
		//no n1:Node.right.*(left+right) | n1.elem <= n.elem
  all n1: n.right.*(left + right) | n1.elem > n.elem
  }
}

// Part (c.1)
pred HasAtMostOneChild(n: Node) {
  // Node n has at most one child.
  -- TODO: Your code starts here.
  all n1, n2:Node |
		n1 in n.(left + right) 
		and n2 in n.(left+right)
			=> n1 = n2
}

// Part (c.2)
fun Depth(n: Node): one Int {
  // The number of nodes from the tree's root to n.
  -- TODO: Your code starts here.
  // Fix: replace ^ with *
  #n.~^(left + right)
}

// Part (c.3)
pred Balanced() {
  all n1, n2: Node {
    // If n1 has at most one child and n2 has at most one child,
    // then the depths of n1 and n2 differ by at most 1.
    // Hint: Be careful about the operator priority.
    -- TODO: Your code starts here.
  HasAtMostOneChild[n1] and HasAtMostOneChild[n2] 
		=> (Depth[n1].sub[Depth[n2]] <= 1 and Depth[n1].sub[Depth[n2]] >= -1)
  }
}

pred RepOk() {
  Sorted
  Balanced
}

run RepOk for exactly 7 Node


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
