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
  one s1: State | s1 = FSM.start
  all s1, s2: State | s1 = FSM.start and s2 = FSM.start => s1 = s2
  // FSM only has one stop state.
  -- TODO: Your code starts here.
  // Fix: replace "some s1: State | s1 in FSM.stop" with "one s1: State | s1 = FSM.stop"
  some s1: State | s1 in FSM.stop
  all s1, s2: State | s1 = FSM.stop and s2 = FSM.stop => s1 = s2
}

// Part (b)
fact ValidStartAndStop {
  // The start state is different from the stop state.
  -- TODO: Your code starts here.
  all s1: FSM.start, s2: FSM.stop | s1 != s2
  // No transition ends at the start state.
  -- TODO: Your code starts here.
  all s1, s2: State | s2 in s1.transition => s2 !in FSM.start
  // No transition begins at the stop state.
  -- TODO: Your code starts here.
  all s1: FSM.stop | s1.transition = none
}

// Part (c)
fact Reachability {
  // All states are reachable from the start state.
  -- TODO: Your code starts here.
  all s: State | s in FSM.start.*transition
  // The stop state is reachable from any state.
  -- TODO: Your code starts here.
  all s: State | FSM.stop in s.*transition
}

run {} for 5

assert repair_assert_1 {
  one FSM.stop
}
 check repair_assert_1
pred repair_pred_1 {
  one FSM.stop
}
 run repair_pred_1
