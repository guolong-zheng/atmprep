/*
A labeled transition system (LTS) is comprised by States, a sub-set
of which are Initial, connected by transitions, here represented by 
Events.
*/
sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

/*
The LTS does not contain deadlocks, ie, each state has at least a 
transition.
*/
pred inv1 {
	all s: State | some s.trans --correct
-- all s : State | some State.trans  --incorrect 1 
-- all s : State | some trans  --incorrect 2
-- all s1, s2:State | some e:Event | (s1->e->s2 in trans and s1 != s2)  --incorrect 3
-- all s1, s2:State | some e:Event | s1->e->s2 in trans  --incorrect 4
-- all s1, s2:State | some e:Event | s1->e->s2 in trans implies s1!=s2  --incorrect 5
-- all s:State , e:Event | some e->s  --incorrect 6
-- all s:State | lone s.trans  --incorrect 7
-- all s:State | some trans  --incorrect 8 
-- all x : State | some x.trans.Event  --incorrect 9 
-- lone State.trans  --incorrect 10
-- some State.trans  --incorrect 11 
-- some State.trans & Event->State  --incorrect 12 
-- some State.trans.State  --incorrect 13 
-- some State<:trans  --incorrect 14 
-- some trans  --incorrect 15 
-- some trans.State  --incorrect 16 
}

/*
There is a single initial state.
*/
pred inv2 {
	one Init --correct
-- all s1,s2:Init | s1=s2  --incorrect 1 
-- all s1,s2:State | s1 in Init and s2 in Init implies s1=s2  --incorrect 2 
-- all s:State | no s.trans  --incorrect 3 
-- all x, y : Init | some x implies x = y  --incorrect 4 
-- all x, y : Init | x = y  --incorrect 5 
-- all x, y : Init | x = y and some x  --incorrect 6 
-- lone Init  --incorrect 7 
-- one s : State | no trans.s  --incorrect 8
-- one State  --incorrect 9
-- one State && all s:State | no s.trans  --incorrect 10
-- one State && no trans --incorrect 11
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/
pred inv3 {
--	all s : State, e : Event | lone e.(s.trans) --correct 
-- ((State.trans).Event) in State  --incorrect 1 
-- (Event.(State.trans)) in State  --incorrect 2 
-- all  y : Event | lone trans.y  --incorrect 3
-- all  y : State | lone y.trans  --incorrect 4 
-- all e : Event | lone e<:(State.trans)  --incorrect 5
-- all e : Event | lone e<:(State.trans.State)  --incorrect 6
-- all e:Event, s:State | lone e  --incorrect 7
-- all s : State | lone s.trans  --incorrect 8 
-- all s : State | lone s.trans.State  --incorrect 9 
-- all s : State | one s.trans  --incorrect 10
-- all s : State, e : Event | lone s.(e.trans)  --incorrect 11 
-- all s : State, e : Event | one e.(s.trans)  --incorrect 12 
-- all s : State, e : Event | one s.(e.trans)  --incorrect 13 
-- all s,s1:State,e:Event | s->e->s1 in trans  --incorrect 14 
-- all s1, s2:State | one e:Event | lone s1->e->s2  --incorrect 15 
-- all s1, s2:State, e:Event | lone s1->e->s2  --incorrect 16 
-- all s:State | all e1,e2:Event | e1->s in s.trans and e2->s in s.trans implies e1=e2  --incorrect 17 
-- all s:State | all e:Event |  e->s in s.trans  --incorrect 18 
-- all s:State | Event = s.trans.State  --incorrect 19 
-- all s:State | lone (s.trans)  --incorrect 20 
 all s:State | lone (State-s).trans -- all s:State | lone e:Event |  e->s in s.trans  --incorrect 22 
-- all s:State | lone s.trans  --incorrect 23 
-- all s:State | lone s.trans.Event  --incorrect 24 
-- all s:State | lone s.trans.State  --incorrect 25 
-- all s:State | lone State.~(s.trans)  --incorrect 26 
-- all s:State | lone trans.s  --incorrect 27 
-- all s:State | one e:Event |  e->s in s.trans  --incorrect 28 
-- all s:State | s.trans.State in Event  --incorrect 29 
-- all s:State, e:Event | lone s.trans  --incorrect 30 
-- all s:State, e:Event | lone s.trans.e  --incorrect 31 
-- all s:State, s1:State, e:Event | lone e->s1  --incorrect 32 
-- all s:State,e:Event | lone s.trans  --incorrect 33 
-- all s:State,e:Event | lone s.trans.e  --incorrect 34 
-- all s:State,e:Event | lone s.trans.Event  --incorrect 35 
-- all s:State| lone Event->State & s.trans  --incorrect 36 
-- all x : Event, y : State | lone y.trans.x  --incorrect 37 
-- all x : State | lone x.trans  --incorrect 38 
-- all x : State, y : Event | lone (x.trans).y  --incorrect 39 
-- all x : State, y : Event | lone x.trans.y  --incorrect 40 
-- lone State.trans.State  --incorrect 41 
-- lone trans  --incorrect 42 
-- lone trans.State --incorrect 43
}


/*
All states are reachable from an initial state.
*/
pred inv4 {
    let tr = { s1, s2 : State | some e : Event | s1->e->s2 in trans } |
  State in Init.^tr --correct
-- all e:Event | State in e.^(Init.trans)  --incorrect 1 
-- all i : Init, s : State | s in i.*(trans[Event])  --incorrect 2
-- all i : Init, s : State | s in i.*tr  --incorrect 3
-- all i:Init | i.trans in State.trans  --incorrect 4
-- all i:Init | State in Event.(i.trans)  --incorrect 5
-- all i:Init | State in Event.^(i.trans)  --incorrect 6
-- all i:Init, s:State, e:Event | i!=s and i->e->s in trans  --incorrect 7
-- all i:Init, s:State, e:Event | i->e->s in trans  --incorrect 8
-- all s : State | one Init  --incorrect 9
-- all s : State | s in Init.^(Event.trans)  --incorrect 10
-- all s : State | s in Init.^onlyStates  --incorrect 11 
-- all s : State | some (Init <: trans).s  --incorrect 12 
-- all s : State | some (Init.trans).s  --incorrect 13 
-- all s : State | some Init.( s.trans)  --incorrect 14 
-- all s : State | some Init.(s<:trans)  --incorrect 15 
-- all s : State | some Init.*(s.trans)  --incorrect 16 
-- all s : State | some Init<:(s.trans)  --incorrect 17 
-- all s : State | some s.(Init . trans)  --incorrect 18 
-- all s : State | some s.(Init.trans)  --incorrect 19 
-- all s : State | some s.(Init<:trans)  --incorrect 20 
-- all s : State | some s.(Init<:trans:>State)  --incorrect 21 
-- all s : State | State in Init.*(s.trans)  --incorrect 22 
-- all s : State | State in Init.^(s.trans)  --incorrect 23 
-- all s : State, e : Event | State in e.^(s.trans)  --incorrect 24 
-- all s : State, e : Event| State in e.^(s.trans)  --incorrect 25
-- all s : State, i : Init | some (i <: trans).s  --incorrect 26 
-- all s : State, i : Init | some s.(i <: trans)  --incorrect 27 
-- all s: State | s in Init.^(Event.trans)  --incorrect 28 
-- all s:(State-Init) | s in Event.(Init.trans)  --incorrect 29 
-- all s:(State-Init) | s in Event.^(Init.trans)  --incorrect 30 
-- all s:(State-Init) | s in Init.(Event.trans)  --incorrect 31 
-- all s:State | Init->Event->(s-Init) in trans  --incorrect 32 
-- all s:State | Init->Event->s in trans  --incorrect 33 
-- all s:State | s in Event.(Init.trans)  --incorrect 34 
-- all s:State | s in Event.^(Init.trans)  --incorrect 35 
-- all s:State | s.^(s.trans) = State  --incorrect 36 
-- all s:State | some i:Init | s in i.^succ  --incorrect 37 
-- all s:State | some s.trans  --incorrect 38 
-- all s:State | State in s.trans.Event  --incorrect 39 
-- all s:State, s1:State, e:Event | e->s1 in s.trans  --incorrect 40 
-- all s:State, s1:State, e:Event | lone s.trans.Event  --incorrect 41 
-- all x  : Event | State in *(Init.trans).x  --incorrect 42 
-- all x  : Event | State in Init.(*(trans.x))  --incorrect 43 
-- all x  : Event | State in Init.*(trans.x)  --incorrect 44 
-- all x : Init | State in (*(x.trans)).Event  --incorrect 45 
-- all x : Init | State in (x.trans).Event  --incorrect 46 
-- all x : Init | State in Event.*(x.trans)  --incorrect 47 
-- all x : Init | State in Event.*(x.trans) + x  --incorrect 48 
-- all x : Init | State in x.trans.Event  --incorrect 49 
-- all x : Init, y : Event | State in *(x.trans).y  --incorrect 50 
-- all x : Init, y : Event | State in x.*(trans.y)  --incorrect 51 
-- all x : Init, y : Event | State in y.(x.trans)  --incorrect 52 
-- all x : Init, y : Event | State in y.*(x.trans)  --incorrect 53 
-- all x : Init, y : Event | State in y.*(x.trans) + x  --incorrect 54 
-- all x : Init, y : Event | State in y.^(x.trans)  --incorrect 55 
-- all x : Init, y : State | State in y.(x.trans)  --incorrect 56
-- all x : Init, y : State | State in y.^(x.trans)  --incorrect 57 
-- all x : State | State in Event.*(x.trans)  --incorrect 58 
-- Init in Event  --incorrect 59 
-- Init in State  --incorrect 60 
-- Init->State in *tr  --incorrect 61 
-- Init.*(Event.trans) in State  --incorrect 62 
-- Init.*trans_bin = State  --incorrect 63 
-- Init.^trans_bin = State  --incorrect 64
-- Init.trans.Event = State  --incorrect 65 
-- no trans[Event]  --incorrect 66
-- some (Event.(Init.trans))  --incorrect 67 
-- some *(Init.trans)  --incorrect 68 
-- some ^(Init.trans)  --incorrect 69
-- some Event.(Init.trans)  --incorrect 70 
-- some Event.^(Init.trans)  --incorrect 71 
-- some Init.trans  --incorrect 72 
-- some Init.trans.Event  --incorrect 73 
-- State in (Event.(Init.trans) + Init)  --incorrect 74
-- State in Event.(*(Init.trans))  --incorrect 75 
-- State in Event.(Init.trans)  --incorrect 76 
-- State in Event.(Init.trans) + Init  --incorrect 77 
-- State in Event.*(Init.trans)  --incorrect 78 
-- State in Event.^(Init.trans)  --incorrect 79 
-- State in Init.(Event.trans)  --incorrect 80 
-- State in Init.*(Event.trans)  --incorrect 81 
-- State in Init.*tr  --incorrect 82 
-- State in Init.trans.Event  --incorrect 83 
-- State.(Event.trans) in Init.*(Event.trans)  --incorrect 84 
-- State.^trans in State  --incorrect 85 
-- x and (all s:State | some i:Init | s in i.^succ)  --incorrect 86 
-- x implies (all s:State | some i:Init | s in i.^succ)  --incorrect 87
-- x implies all s:State | some i:Init | s in i.^succ --incorrect 88
}

/*
All the states have the same events available.
*/
pred inv5 {
	all s:State, s1:State | s.trans.State = s1.trans.State --correct
-- all s : State | Event = s.(State->Event)  --incorrect 1
-- all s : State | Event in s.(State->Event)  --incorrect 2 
-- all s : State | Event in s.(trans.Event)  --incorrect 3 
-- all s : State | Event.(s.trans) in Event.(State.trans)  --incorrect 4
-- all s : State | s.trans = State.trans  --incorrect 5
-- all s : State | s.trans in State.trans  --incorrect 6 
-- all s : State | some (s.trans).Event  --incorrect 7 
-- all s : State | some Event.(s.trans)  --incorrect 8 
-- all s : State | some Event.(s<:trans)  --incorrect 9 
-- all s : State | some s->Event  --incorrect 10 
-- all s : State, e : Event | e.(s.trans) in Event.(State.trans)  --incorrect 11 
-- all s : State, e : Event | some (s.trans).e  --incorrect 12 
-- all s : State, e : Event | some e.(s.trans)  --incorrect 13 
-- all s,s1:State,e:Event | s->e->s1 in trans  --incorrect 14 
-- all s,s1:State,e:Event|some s2,s3:State | s->e->s2 in trans implies s1->e->s3 in trans  --incorrect 15 
-- all s1, s2 : State | s1.trans = s2.trans  --incorrect 16 
-- all s1, s2:State, e:Event | s1->e->s2 in trans  --incorrect 17 
-- all s1, s2:State, e:Event | s1->e->s2 in trans and s1->e->s1 in trans  --incorrect 18 
-- all s1,s2 : State, e : Event | e.(s1.trans) = e.(s2.trans)  --incorrect 19 
-- all s1,s2:State |some e:Event |some e.(s1.trans) implies some e.(s2.trans)  --incorrect 20 
-- all s1,s2:State|some e:Event | some e.(s1.trans) implies some e.(s2.trans)  --incorrect 21
-- all s:State | all e:Event |  some e<:s.trans  --incorrect 22 
-- all s:State | all e:Event | e in State.~(s.trans)  --incorrect 23 
-- all s:State | Event in Event.~(s.trans)  --incorrect 24 
-- all s:State | Event in s.~(State.trans)  --incorrect 25 
-- all s:State | Event in State.~(s.trans)  --incorrect 26 
-- all s:State | Event.~(s.trans) in Event  --incorrect 27 
-- all s:State | s.~(State.trans) in Event  --incorrect 28 
-- all s:State | State.(s.trans) in Event  --incorrect 29 
-- all s:State | State.~(s.trans) in Event  --incorrect 30 
-- all s:State, e:Event | s->e->s in trans  --incorrect 31 
-- all x : State | (x.trans).Event in Event  --incorrect 32 
-- all x : State | (x.trans.State) in Event  --incorrect 33 
-- all x : State | (x.trans.x) in Event  --incorrect 34 
-- all x : State | Event in x<:Event  --incorrect 35 
-- all x : State | Event.(trans.x) in Event  --incorrect 36 
-- all x : State | Event.(x.trans) in Event  --incorrect 37 
-- all x : State | some (x->Event->State)  --incorrect 38 
-- all x : State | some (x.trans)  --incorrect 39 
-- all x : State | some e : Event | x.trans = State.trans  --incorrect 40 
-- all x : State | some x->Event->State  --incorrect 41 
-- all x : State | some y : State | some x->Event->y  --incorrect 42 
-- all x : State | State in x:>Event  --incorrect 43 
-- all x : State | State.(x.trans) in Event  --incorrect 44 
-- all x : State | State.trans in x.trans  --incorrect 45 
-- all x : State | x.trans = State.trans  --incorrect 46 
-- all x : State | x.trans in State.trans  --incorrect 47 
-- all x : State, e : Event | some x->e->State  --incorrect 48 
-- all x : State, e : Event | some x->Event  --incorrect 49 
-- all x : State, e : Event | x->e->State in trans  --incorrect 50 
-- all x, y : State | all e : Event | some x->e->y implies some y->e->y  --incorrect 51 
-- all x, y : State | all e : Event | x->e->y in trans and y->e->y in trans  --incorrect 52 
-- all x, y : State | some e : Event | some x->e->y implies some y->e->y  --incorrect 53 
-- all x, y : State | some e : Event | x->e->State in trans implies y->e->State in trans  --incorrect 54 
-- all x, y : State | some e : Event | x->e->y in trans  --incorrect 55 
-- all x, y : State | some e : Event | x->e->y in trans implies y->e->y in trans  --incorrect 56 
-- all x, y : State | some e : Event | x->Event->y in trans  --incorrect 57 
-- all x, y : State | some x->Event implies some y->Event  --incorrect 58 
-- all x, y : State | some x.trans & y.trans  --incorrect 59 
-- all x, y : State | x->Event->y in trans  --incorrect 60 
-- all x, y : State | x->Event->y in trans implies y->Event->y in trans  --incorrect 61 
-- all x, y : State | x.trans in y.trans  --incorrect 62 
-- all x, y : State | x.trans in State.trans  --incorrect 63 
-- all x, y : State, e : Event | some x->e implies some y->e  --incorrect 64 
-- all x, y : State, e : Event | x->e->y in trans  --incorrect 65 
-- all x, y, z : State | some e : Event | x->e->y in trans implies y->e->x in trans  --incorrect 66 
-- Event in (Event.(State.trans))  --incorrect 67 
-- one State->Event  --incorrect 68 
-- some State->Event->State  --incorrect 69 
-- State in Event.(State.trans)  --incorrect 70 
-- State in State.(trans.Event)  --incorrect 71 
-- State->Event in iden  --incorrect 72 
-- State.~(State.trans) in Event  --incorrect 73
}

/*
Each event is available in at least a state.
*/
pred inv6 {
	all e:Event | some s1,s2:State | s1->e->s2 in trans --correct
}

/*
The LTS is reversible, ie, from a reacheable state it is always possible 
to return to an initial state.
*/
pred inv7 {
  let tr = { s1, s2 : State | some e : Event | s1->e->s2 in trans } |
	all s : Init.^tr | some i : Init | i in s.^tr --correct
-- (State.trans).~(State.trans) in iden  --incorrect 1 
-- all e:Event,s1,s2:State | s1->e->s2 in trans implies s2->e->s1 in trans  --incorrect 2
-- all e:Event,s1,s2:State |some e1:Event| s1->e->s2 in trans implies s2->e1->s1 in trans  --incorrect 3
-- all s : State | some i1,i2: Init | s.isReachableFromState[i1] implies i2.isReachableFromState[s]  --incorrect 4
-- all s : State | some i: Init | s.isReachableFromState[i] implies i.isReachableFromState[s]  --incorrect 5
-- all s1, s2:State, e:Event | s1->e->s2 in trans implies s2->e->s1 in trans  --incorrect 6
-- all s1,s2:State | some e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans  --incorrect 7
-- all s1,s2:State, e1,e2,e3,e4:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans  --incorrect 8 
-- all s1,s2:State, e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans  --incorrect 9
-- all s1,s2:State, e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans  all s:State,e1,e2:Event | s->e1->s in trans implies s->e1->s in trans  --incorrect 10
-- all s1,s2:State, e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans  all s:State,e1,e2:Event | s->e1->s in trans implies s->e2->s in trans  --incorrect 11 
-- all s1,s2:State, e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans and s1 in e2.(s1.trans)  --incorrect 12 
-- all s1,s2:State, e1,e2:Event  | s1->e1->s2 in trans implies s2->e2->s1 in trans or s1->e2->s1 in trans  --incorrect 13 
-- all x : Event | (trans.x) in State one -> one Init  --incorrect 14 
-- all x : Event | (trans.x) in State one -> one State  --incorrect 15 
-- all x : Event | some (*(~(trans.x))).Init  --incorrect 16 
-- all x : Event | some Init.(*(~(trans.x)))  --incorrect 17 
-- all x : Event | some Init.(^(~(trans.x)))  --incorrect 18 
-- all x : Init | (x.trans) in Event one -> one State  --incorrect 19 
-- all x : State | (no iden & (x.trans)) and some ((*(~(x.trans))).Init)  --incorrect 20
-- all x : State | (x.trans) in Event one -> one State  --incorrect 21 
-- all x : State | no iden & (x.trans)  --incorrect 22 
-- all x : State | some (*(~(x.trans))).Init  --incorrect 23 
-- all x : State | some Init.(*(~(x.trans)))  --incorrect 24 
-- all x : State, y : Init, z : Event | (trans in y one -> one z one -> one x) and x != y  --incorrect 25 
-- all x : State, y : Init, z : Event | (trans in y one -> one z one -> one x) implies x != y  --incorrect 26 
-- all x : State, y : Init, z : Event | trans in y one -> one z one -> one x  --incorrect 27 
-- all x : State, y : Init, z : Event | trans in y one -> one z one -> one x and x != y  --incorrect 28 
-- all x : State, y : Init, z : Event | trans in y one -> one z one -> one x and z != y  --incorrect 29 
-- some (Event.(State.trans))  --incorrect 30 
-- some trans.(Event.(State.trans))  --incorrect 31 
-- ~(State.trans).(State.trans) in iden --incorrect 32
}


/*======== IFF PERFECT ORACLE ===============*/
pred inv1_OK {
	all s: State | some s.trans --correct
}
assert inv1_Repaired {
    inv1[] iff inv1_OK[]
}
---------
pred inv2_OK {
	one Init --correct
}
assert inv2_Repaired {
    inv2[] iff inv2_OK[]
}
--------
pred inv3_OK {
	all s : State, e : Event | lone e.(s.trans) --correct
}
assert inv3_Repaired {
    inv3[] iff inv3_OK[]
}
--------
pred inv4_OK {
 let tr = { s1, s2 : State | some e : Event | s1->e->s2 in trans } |
  State in Init.^tr --correct
}
assert inv4_Repaired {
    inv4[] iff inv4_OK[]
}
--------
pred inv5_OK {
	all s:State, s1:State | s.trans.State = s1.trans.State --correct
}
assert inv5_Repaired {
    inv5[] iff inv5_OK[]
}
--------
pred inv7_OK {
let tr = { s1, s2 : State | some e : Event | s1->e->s2 in trans } |
	all s : Init.^tr | some i : Init | i in s.^tr --correct
}
assert inv7_Repaired {
    inv7[] iff inv7_OK[]
}
--------

--- PerfectOracleCommands
 check inv1_Repaired expect 0
 check inv2_Repaired expect 0
 check inv3_Repaired expect 0 
 check inv4_Repaired expect 0
 check inv5_Repaired expect 0
 check inv7_Repaired expect 0



pred repair_pred_1{inv3[] iff inv3_OK[] }
run repair_pred_1
assert repair_assert_1{inv3[] iff inv3_OK[] }
check repair_assert_1
