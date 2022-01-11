/*
Further simplification of Dan's work
access is granted to all assigned groups. 
problem: assigned groups defined as *at least* alas and peds.
fix: assigned groups definded as *only* alas and peds.
*/

//people
sig Person {
   member_of : some Group
}
pred CanEnter(p: Person, r:Room) {
	p.member_of in r.located_in
}

// groups 
sig Group {}
one sig alas extends Group {}  
one sig peds extends Group {}

//rooms
sig Room {
  located_in: set Group
}
one sig seclab extends Room {}
// the problem; this permits, but doesn't restrict
fact {
  // Fix: replace "alas in seclab.located_in and peds in seclab.located_in" with "alas + peds = seclab.located_in".
  alas in seclab.located_in and peds in seclab.located_in
}

// assertion
assert no_thief_in_seclab {
   all p : Person | CanEnter[p, seclab] implies alas in p.member_of or peds in p.member_of
}
check no_thief_in_seclab

assert repair_assert_1 {
  all p : Person | CanEnter[p, seclab] implies alas in p.member_of or peds in p.member_of
}
 check repair_assert_1
pred repair_pred_1 {
  all p : Person | CanEnter[p, seclab] implies alas in p.member_of or peds in p.member_of
}
 run repair_pred_1
