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
  all f: FSM | one f.start

  // FSM only has one stop state.
  -- TODO: Your code starts here.
  all f: FSM | one f.stop
}

// Part (b)
fact ValidStartAndStop {
  // The start state is different from the stop state.
  -- TODO: Your code starts here.
  all f : FSM | disj[f.start, f.stop]

  // No transition ends at the start state.
  -- TODO: Your code starts here.
  all f : FSM, s : State | f.start !in s.transition

  // No transition begins at the stop state.
  -- TODO: Your code starts here.
  all f : FSM, s : State | f.stop !in s.~transition
}

// Part (c)
fact Reachability {
  // All states are reachable from the start state.
  -- TODO: Your code starts here.
  State = FSM.start.*transition

  // The stop state is reachable from any state.
  -- TODO: Your code starts here.
  // Fix: all n: State | FSM.stop in n.*transition
  all s : State | s = FSM.stop or s in FSM.start.*transition
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
