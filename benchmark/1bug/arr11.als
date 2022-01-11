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
  // Fix: replace <= with <
	all a: Array, m: Int, n: Element | m -> n in a.i2e implies m >= 0 and m <= Array.length
  // Array length should be greater than or equal to 0.
  -- TODO: Your code starts here.
	Array.length >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  -- TODO: Your code starts here.
	all a: Array, m1, m2: Int, n1, n2: Element | m1 -> n1 in a.i2e and m2->n2 in a.i2e and n1 != n2 implies m1 != m2
}

run NoConflict for 5
assert repair_assert_1 {
  all idx : Array.i2e.Element | idx >= 0 and idx < Array.length
}
 check repair_assert_1
pred repair_pred_1 {
  some Element
  all idx : Array.i2e.Element | idx >= 0 and idx < Array.length
}
 run repair_pred_1
