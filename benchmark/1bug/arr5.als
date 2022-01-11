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
  // Fix: replace > with >=
	all a: Array, i: a.i2e.Element | i > 0 and i < a.length

  // Array length should be greater than or equal to 0.
	all a: Array | int a.length >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  all a: Array, i: a.i2e.Element | one i.(a.i2e)
}

run NoConflict for 5
assert repair_assert_1 {
  some i:Element.~(Array.i2e) | i = 0
}
 check repair_assert_1 for 5
pred repair_pred_1 {
  some i:Element.~(Array.i2e) | i = 0
}
 run repair_pred_1 for 5
