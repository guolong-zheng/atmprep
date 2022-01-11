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
  #(FSM.start)  = 1

  // FSM only has one stop state.
  -- TODO: Your code starts here.
  #(FSM.stop)  = 1
}

// Part (b)
fact ValidStartAndStop {
  // The start state is different from the stop state.
  -- TODO: Your code starts here.
  FSM.start != FSM.stop

  // No transition ends at the start state.
  -- TODO: Your code starts here.
  // Fix: all s: State | FSM.start !in s.^transition
  all s: State | s.*transition != FSM.start

  // No transition begins at the stop state.
  -- TODO: Your code starts here.
  no FSM.stop.transition
}

// Part (c)
fact Reachability {
  // All states are reachable from the start state.
  -- TODO: Your code starts here.
  State = FSM.start.*transition

  // The stop state is reachable from any state.
  -- TODO: Your code starts here.
  all s: State | FSM.stop & s.*transition = FSM.stop
}

run {} for 5
assert repair_assert_1 {
  all s: State | FSM.start !in s.^transition
}
 check repair_assert_1
pred repair_pred_1 {
  all s: State | FSM.start !in s.^transition
}
 run repair_pred_1
