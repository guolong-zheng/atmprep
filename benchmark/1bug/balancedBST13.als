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
	n not in n.^(left+right)

	// A node cannot have more than one parent. 
	all n', n1 : Node | n' in n.(left+right) and n!=n1 => n' not in n1.(left+right)
	
	// A node cannot have another node as both its left child and 
	// right child.
	all n' : Node | n.left=n' => n.right !=n'
  } 
}

// Part (b)
pred Sorted() { 
  all n: Node {
	// All elements in the n’s left subtree are smaller than the n’s elem. 
	all n': Node | n' in n.left.*(left+right) => n'.elem < n.elem
	
	// All elements in the n’s right subtree are bigger than the n’s elem.
	all n': Node | n' in n.right.*(left+right) => n'.elem > n.elem 
 } 
}

// Part (c.1)
pred HasAtMostOneChild(n: Node) { 
	// Node n has at most one child. 
	all n':Node | n' in n.left => no n.right
}

// Part (c.2)
fun Depth(n: Node): one Int {
  // The number of nodes from the tree's root to n.
  // Fix: replace "^" with "*"
  #(n.^~(left+right))
}

// Part (c.3)
pred Balanced() {
  all n1, n2: Node {
       HasAtMostOneChild[n1] and HasAtMostOneChild[n2]
	implies sub[Depth[n1], Depth[n2]] <= 1 and  sub[Depth[n1], Depth[n2]] >= -1 
    // If n1 has at most one child and n2 has at most one child,
    // then the depths of n1 and n2 differ by at most 1.
    // Hint: Be careful about the operator priority.
   
  }
}

pred RepOk() {
  Sorted
  Balanced
}

run RepOk for exactly 5 Node

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
