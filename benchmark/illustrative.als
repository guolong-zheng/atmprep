sig Room {}
one sig SecureLab extends Room {}

abstract sig Person { owns : set Key }
sig Employee extends Person {}
sig Researcher extends Person {}

sig Key { opened_by: one Room }

fact {
  some Employee && some Researcher
  some e : Employee | #e.owns > 1
}

fact {
  all r : Room | some opened_by.r
  {all e : Employee | some k : Key | k in e.owns and
   SecureLab != k.opened_by }//and no e.owns&opened_by.SecureLab } //missing constraint
}

pred CanEnter(p: Person, r:Room) {r in p.owns.opened_by}

pred repair_pred_1{
 SecureLab in Person.owns.opened_by
 all p : Person | CanEnter[p, SecureLab] implies p in Researcher
}
run repair_pred_1

assert repair_assert_1 {
  all p : Person | CanEnter[p, SecureLab]
    implies p in Researcher
}
check repair_assert_1