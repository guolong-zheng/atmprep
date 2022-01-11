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
	all idx : Array.i2e.Element | idx >= 0 and idx < Array.length
  // Array length should be greater than or equal to 0.
  -- TODO: Your code starts here.
	all a : Array | a.length >= 0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  -- TODO: Your code starts here.
	// each idx map to exactly one element (but might map to the same element
	all idx : Array.i2e.Element | lone Array.i2e[idx]
	// make sure that two unique idices map to unique elements
        // Fix: remove constraint
	all idx1, idx2 : Array.i2e.Element | idx1 != idx2 => Array.i2e[idx1] != Array.i2e[idx2]
	
}

run NoConflict for 5
assert repair_assert_1 {
  NoConflict <=> all idx : Array.i2e.Element | lone Array.i2e[idx]
}
 check repair_assert_1
pred repair_pred_1 {
  NoConflict <=> all idx : Array.i2e.Element | lone Array.i2e[idx]
}
 run repair_pred_1
