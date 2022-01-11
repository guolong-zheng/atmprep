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
  all i: Int, e : Element | (i->e) in Array.i2e => i >= 0 and i < Array.length
  // Array length should be greater than or equal to 0.
  -- TODO: Your code starts here.
  Array.length >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  -- TODO: Your code starts here.
  // Fix: all idx: Array.i2e.Element | lone Array.i2e[idx]
  lone Array.i2e[Int]
}

assert repair_assert_1 {
  NoConflict <=> all idx: Array.i2e.Element | lone Array.i2e[idx]
}
 check repair_assert_1
pred repair_pred_1 {
  #Element > 1
  NoConflict <=> all idx: Array.i2e.Element | lone Array.i2e[idx]
}
 run repair_pred_1
