one sig FSM {
  start: set State,
  stop: set State
}

sig State {
  transition: set State
}

// Part (a)
fact OneStartAndStop {
  // FSM only has one start state.
  all x: FSM | one x.start

  // FSM only has one stop state.
  all x: FSM | one x.stop
}

// Part (b)
fact ValidStartAndStop {
  // The start state is different from the stop state.
  all x: FSM | disj [x.start, x.stop]
	  
  // No transition ends at the start state.
  no transition.(FSM.start)

  // No transition begins at the stop state.
  no (FSM.stop).transition 
}

// Part (c)
fact Reachability {
  // All states are reachable from the start state.
  State = FSM.start.*transition

  // The stop state is reachable from any state.
  // Fix: all n: State | FSM.stop in n.*transition
  #State.transition +1 = #FSM.stop 
}

run {} for 5
assert repair_assert_1 {
  all n: State | FSM.stop in n.*transition
}
 check repair_assert_1
pred repair_pred_1 {
  all n: State | FSM.stop in n.*transition
}
 run repair_pred_1
