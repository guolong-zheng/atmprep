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
  // Fix: replace "Int" with "Array.i2e.Element"
	all i:Int | i>=0 and i<Array.length
   
  // Array length should be greater than or equal to 0.
  -- TODO: Your code starts here.
	Array.length >=0
}

// Part (b)
pred NoConflict() {
  // Each index maps to at most one element.
  -- TODO: Your code starts here.
	all i: Int, e1,e2:Element | i->e1 in Array.i2e and i->e2 in Array.i2e implies e1=e2
	
}

run NoConflict for 5

assert repair_assert_1 {
  all e : Element | e in Array.i2e[Int]
}
check repair_assert_1

pred repair_pred_1 {
  all e : Element | e in Array.i2e[Int]
}
run repair_pred_1
