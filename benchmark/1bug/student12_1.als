sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}

// Correct
fact CardinalityConstraints {
    all l: List | lone l.header
    all n: Node | lone n.link && one n.elem
}

// Correct
pred Loop(This: List) {
    This.header.*link = Node
    no This.header || one n: This.header.*link | n in n.link
}

// Overconstraint.  Should not allow link = n1 -> n2 + n2 -> n1
// Underconstraint.  Should allow no n.link
pred Sorted(This: List) {
    all n: This.header.*link | some n.link => n.elem <= n.link.elem
}

pred RepOk(This: List) {
    Loop[This]
    Sorted[This]
}

// Correct
pred Count(This: List, x: Int, result: Int) {
    RepOk[This]
    result = #{ n: This.header.*link | n.elem = x }
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Overconstraint.  result should be True as long as one of the elem = x.
pred Contains(This: List, x: Int, result: Boolean) {
    RepOk[This]
    // Fix: replace "all" with "some".
    { all n: This.header.*link | n.elem = x } =>result = True else result = False
}

assert repair_assert_1 {
    all l : List | all x : Int | all result: Boolean | RepOk[l] and Contains[l, x, result] <=>
        RepOk [l] and
        (x ! in l.header.*link.elem <=> result=False)
}
 check repair_assert_1
pred repair_pred_1 {
    all l : List | all x : Int | some result: Boolean | RepOk[l] and Contains[l, x, result] <=>
       RepOk [l] and
        (x ! in l.header.*link.elem and result=False) or (x in l.header.*link.elem and result=True)
}
 run repair_pred_1
