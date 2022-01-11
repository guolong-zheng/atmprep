/*   Dan Dougherty, 12/16

Alloy gradebook spec, with some names changed:
Each relation is now denoted by (i) using an appropriate legal English verb-phrase, then
(ii)  eliding "is" is for concision. 
This facilitates matching English translation to spec.

Also: rephrased assertion as an implication.
*/

abstract sig Person {}
sig Student extends Person {}
sig Professor extends Person {}
sig Class {
	assistant_for: set Student,   // as in : "is TA for"
	instructor_of: one Professor
}
sig Assignment {
	associated_with: one Class,
	assigned_to: some Student
}

pred PolicyAllowsGrading(s: Person, a: Assignment) {
	s in a.associated_with.assistant_for or s in a.associated_with.instructor_of
	// Fix: add "s !in a.assigned_to".
}
assert NoOneCanGradeTheirOwnAssignment {
	all s : Person | all a: Assignment | PolicyAllowsGrading[s, a] implies not s in a.assigned_to 
}

check NoOneCanGradeTheirOwnAssignment

assert repair_assert_1 {
	all s : Person | all a: Assignment | PolicyAllowsGrading[s, a] implies not s in a.assigned_to 
}
 check repair_assert_1
pred repair_pred_1 {
	all s : Person | all a: Assignment | PolicyAllowsGrading[s, a] implies not s in a.assigned_to 
}
 run repair_pred_1
