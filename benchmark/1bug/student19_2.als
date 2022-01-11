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
    all n: Node | lone n.link
    all n: Node | one n.elem
}

// Correct
pred Loop(This: List) {
    no This.header || one n: This.header.*link | n in n.^link
}

// Overconstraint.  Should allow no n.link
pred Sorted(This: List) {
    all n:This.header.*link | some n.link => n.elem <= n.link.elem
}

pred RepOk(This: List) {
     Loop[This]
     Sorted[This]
}

// Underconstraint.  result should be number of n
pred Count(This: List, x: Int, result: Int) {
    RepOk[This]
    result = #{n: This.header.*link | n.elem = x}
}

abstract sig Boolean {}
one sig True, False extends Boolean {}

// Overconstraint.  Should allow no l.header
pred Contains(This: List, x: Int, result: Boolean) {
    RepOk[This]
    // Fix: replace "(some n: This.header.*link | x in n.elem && result = True) || (all n: This.header.*link | x !in n.elem && result = False)" with "
    //((some n: This.header.*link | x in n.elem) && result = True) || ((all n: This.header.*link | x !in n.elem) && result = False)".
    (some n: This.header.*link | x in n.elem && result = True) || (all n: This.header.*link | x !in n.elem && result = False)
}

assert repair_assert_1 {
    all l : List | all x : Int | all result : Boolean | RepOk[l] and Contains[l, x, result] <=>
        RepOk [l] and
        ( x in l.header.*link.elem <=> result = True)
}
 check repair_assert_1
pred repair_pred_1 {
    all l : List | all x : Int | all result : Boolean | RepOk[l] and Contains[l, x, result] <=>
            RepOk [l] and
            ( x in l.header.*link.elem <=> result = True)
}
 run repair_pred_1
