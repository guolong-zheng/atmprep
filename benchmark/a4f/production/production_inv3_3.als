open util/ordering[Position]

// Consider the following model of an automated production line
// The production line consists of several positions in sequence
sig Position {}

// Products are either components assembled in the production line or 
// other resources (e.g. pre-assembled products or base materials)
sig Product {}

// Components are assembled in a given position from other parts
sig Component extends Product {
    parts : set Product,
    cposition : one Position
}
sig Resource extends Product {}

// Robots work somewhere in the production line
sig Robot {
        rposition : one Position
}

// Specify the following invariants!
// You can check their correctness with the different commands and
// specifying a given invariant you can assume the others to be true.
pred inv1 { // A component requires at least one part
	all c:Component | some c.parts
-- all c : Component | some parts --incorrect 1 
-- all c:Component | c not in c.*parts --incorrect 2 
-- all c:Component | c not in c.^parts --incorrect 3 
-- all c:Component | some parts --incorrect 4
-- some Component.parts --incorrect 5
-- some Component<:parts --incorrect 6 
-- some parts --incorrect 7
}


pred inv2 { // A component cannot be a part of itself
	all c:Component | c not in c.^parts
--  all c : Component | c not in c.parts --incorrect 1 
--  all c : Component | c->c in parts --incorrect 2
--  all c : Component | c->c not in parts --incorrect 3 
--  all c : Component | c<:parts in iden --incorrect 4
--  all c : Component | no (c.*parts) --incorrect 5
--  all c : Component | no (c.^parts) --incorrect 6 
--  all c : Component | no (c<:parts).c --incorrect 7 
--  all c : Component | no c->c --incorrect 8
--  all c : Component | no c->parts->c --incorrect 9 
--  all c : Component | no c.(c<:parts) --incorrect 10 
--  all c : Component | no c<:(parts.c) --incorrect 11 
--  all c:Component | (c.parts) in (c.parts - c) --incorrect 12 
--  all c:Component | c not in (c.parts) --incorrect 13 
--  all c:Component | c not in c.parts --incorrect 14 
--  all c:Component | no c.parts & c --incorrect 15 
--  no (Component.*parts) --incorrect 16 
--  no (Component.^parts)<:Component --incorrect 17 
--  no (Component<:*parts) --incorrect 18 
--  no Component.^parts --incorrect 19
}


pred inv3 { // The position where a component is assembled must have at least one robot
--	Component.cposition in Robot.rposition
-- all c:Component | c.^parts.cposition in Robot.rposition --incorrect 1 
-- all c:Component | c.parts.cposition in Robot.rposition --incorrect 2 
 all c:Component | c.cposition = Robot.rposition-- all c:Component | Robot.rposition in c.cposition --incorrect 4 
-- all c:Component | some c.parts.cposition --incorrect 5
-- all c:Component, r:Robot | c.cposition = r.rposition --incorrect 6 
-- all c:Component, r:Robot | c.cposition in r.rposition --incorrect 7
-- all c:Component,p:Product |some r:Robot,pos1,pos2:Position| c->p in parts and p->pos1 in cposition and r->pos2 in rposition implies pos1=pos2 --incorrect 8 
-- all c:Component,p:Product, r:Robot,pos1,pos2:Position| c->p in parts and p->pos1 in cposition and r->pos2 in rposition implies pos1=pos2 --incorrect 9 
-- all c:Component.cposition, r:Robot | some r.rposition & c --incorrect 10
-- all c:Component| c.cposition = Robot.rposition --incorrect 11
-- some r:Robot | Component.cposition = r.rposition --incorrect 12
}


pred inv4 { // The parts required by a component cannot be assembled in a later position
    all c:Component | c.parts.cposition in c.cposition.*prev 
-- all c : Component | all p : c.parts | p in c.cposition.prevs.parts --incorrect 1 
-- all c : Component | all p : c.parts | some pos : c.cposition.prevs | p.cposition = pos --incorrect 2
-- all c: Component | ((c.^parts) & Component).cposition not in (c.cposition).*next --incorrect 3
-- all c: Component | ((c.^parts) & Component).cposition not in (c.cposition).^next --incorrect 4 
-- all c: Component | ((c.^parts) & Component).cposition not in (c.cposition).^next or no c.^parts --incorrect 5
-- all c: Component | ((c.parts) & Component).cposition not in (c.cposition).^next --incorrect 6
-- all c: Component | ((c.parts):>Component).cposition not in (c.cposition).^next --incorrect 7
-- all c: Component | (c.parts).cposition in (c.cposition).^~next --incorrect 8
-- all c: Component | (c.parts).cposition not in (c.cposition).^next --incorrect 9
-- all c: Component | (c.parts).cposition not in (c.cposition).^~next --incorrect 10 
-- all c:Component | all p:c.parts | p not in c.^parts --incorrect 11
-- all c:Component | c.parts in (c.^cposition.~^next) --incorrect 12
-- all c:Component | c.parts in c.cposition.~^next --incorrect 13
-- all c:Component | c.parts.cposition in c.cposition --incorrect 14 
-- all c:Component | c.parts.cposition in c.cposition.~^next --incorrect 15
-- all c:Component | c.parts.cposition in c.cposition.~next --incorrect 16 
-- all c:Component | c.parts.cposition not in c.cposition.^next --incorrect 17 
-- all c:Component | c.cposition in c.cposition.~^next --incorrect 18 
-- all c:Component | c.cposition not in c.cposition.^next --incorrect 19 
-- all c:Component | no  c.parts.cposition.~^next --incorrect 20 
-- all c:Component | no (c.parts & c.parts.cposition.~^next) --incorrect 21
-- all c:Component | no (c.parts & c.cposition.~^next) --incorrect 22 
-- all c:Component, p:c.parts | p in Component implies c.cposition in p.cposition.nexts --incorrect 23 
}



/*======== IFF PERFECT ORACLE ===============*/
pred inv1_OK {
	all c:Component | some c.parts --correct
}
assert inv1_Repaired {
    inv1[] iff inv1_OK[]
}
---------
pred inv2_OK {
		all c:Component | c not in c.^parts --correct
}
assert inv2_Repaired {
    inv2[] iff inv2_OK[]
}
--------
pred inv3_OK {
	Component.cposition in Robot.rposition --correct
}
assert inv3_Repaired {
    inv3[] iff inv3_OK[]
}
--------
pred inv4_OK {
  all c:Component | c.parts.cposition in c.cposition.*prev  --correct
}
assert inv4_Repaired {
    inv4[] iff inv4_OK[]
}

-- PerfectOracleCommands
 check inv1_Repaired expect 0
 check inv2_Repaired expect 0
 check inv3_Repaired expect 0 
 check inv4_Repaired expect 0
pred repair_pred_1{inv3[] iff inv3_OK[] }
run repair_pred_1
assert repair_assert_1{inv3[] iff inv3_OK[] }
check repair_assert_1
