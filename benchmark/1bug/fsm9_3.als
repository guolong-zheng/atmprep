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
  -- TODO: Your code starts here.
  one s:State| s in FSM.start
  // FSM only has one stop state.
  -- TODO: Your code starts here.
  one s:State | s in FSM.stop
}

// Part (b)
fact ValidStartAndStop {
  // The start state is different from the stop state.
  -- TODO: Your code starts here.
  all f: FSM | f.start != f.stop
  // No transition ends at the start state.
  -- TODO: Your code starts here.
  no s:State | FSM.start in s.transition 

  // No transition begins at the stop state.
  -- TODO: Your code starts here.
  no s:State | some transition.s & FSM.stop
}

// Part (c)
fact Reachability {
  // All states are reachable from the start state.
  -- TODO: Your code starts here.
  // Fix: replace = with in
  all s:State | s = FSM.start.*transition
  // The stop state is reachable from any state.
  -- TODO: Your code starts here.
  all s:State | FSM.stop in s.*transition
}

run {} for 5
assert repair_assert_1 {
  all s:State | s in FSM.start.*transition
}
 check repair_assert_1
pred repair_pred_1 {
  one FSM.start
  one FSM.stop
  FSM.start != FSM.stop
  all s:State | s in FSM.start.*transition
}
 run repair_pred_1
