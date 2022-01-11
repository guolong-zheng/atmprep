sig Element {}

one sig Array {
  // Maps indexes to elements of Element.
  i2e: Int -> Element,
  // Represents the length of the array.
  length: Int
}

// Assume all objects are in the array.
fact Reachable {
  Element = Array.i2e[Int]
}

// Part (a)
fact InBound {
  // All indexes should be greater than or equal to 0 and less than
  // the array length.
  -- TODO: Your code starts here.
  // Fix: move "Array.length >= 0" out of the quantification.
  all x: Int | (x >= 0 and x < Array.length and Array.length >= 0) or no Array.i2e[x] 

  // Array length should be greater than or equal to 0.
  -- TODO: Your code starts here.
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  -- TODO: Your code starts here.
  all x: Int {
		all e1, e2: Array.i2e[x] | e1 = e2
	} 
}

run NoConflict {}
assert repair_assert_1 {
  Array.length >= 0 and
  all x: Int | (x >= 0 and x < Array.length) or no Array.i2e[x]
}
 check repair_assert_1
pred repair_pred_1 {
  some Element and
  Array.length >= 0 and
    all x: Int | (x >= 0 and x < Array.length) or no Array.i2e[x]
}
 run repair_pred_1
