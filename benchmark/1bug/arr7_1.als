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
  //i2e.Element[Array] >= 0 && Element[i2e][Array] < length[Array]
  all i: Int, e: Element | (i -> e in Array.i2e) implies (i >= 0 && i < length[Array])

  // Array length should be greater than or equal to 0.
  length[Array] >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  // Fix: use "all idx: Array.i2e.Element | lone Array.i2e[idx]"
  lone i2e.Element
}

run NoConflict for 5
assert repair_assert_1 {
  NoConflict <=> all idx: Array.i2e.Element | lone Array.i2e[idx]
}
 check repair_assert_1
pred repair_pred_1 {
  NoConflict <=> all idx: Array.i2e.Element | lone Array.i2e[idx]
}
 run repair_pred_1
