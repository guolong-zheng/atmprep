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
  all i:Element.~(Array.i2e) | i > 0 && i < Array.length

  // Array length should be greater than or equal to 0.
  Array.length >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  // the line below solves the problem as it is written:
  all idx1, idx2: Int, a1: Array.i2e[idx1], a2: Array.i2e[idx2] | a1 != a2 => idx1 != idx2

  // The line below solves the problem: "Each index maps to at most one UNIQUE element." if that is what was intended
  //all idx1, idx2: Int, a1: Array.i2e[idx1], a2: Array.i2e[idx2] | (a1 != a2 => idx1 != idx2) and (idx1 != idx2 => a1 != a2)
}

run NoConflict for 5

pred repair_pred_1 {
  some i:Element.~(Array.i2e) | i = 0
}
 run repair_pred_1 for 5
