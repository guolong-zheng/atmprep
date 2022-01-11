sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}

// Correct
fact CardinalityConstraints {
    all l : List | lone l.header
    all n : Node | lone n.link
    all n : Node | one n.elem
}

// Correct
pred Loop ( This : List ) {
    no This.header || one n : This.header.*link | n.^link = n.*link
}

// Underconstraint.  Should be true if no n.link.
pred Sorted ( This : List ) {
    all n: This.header.*link | some n.link => n.elem <= n.link.elem
}

pred RepOk ( This : List ) {
    Loop [This]
    Sorted [This]
}

// Correct
pred Count ( This : List , x : Int , result : Int ) {
    RepOk [This]
    result = #{ n:This.header.*link | n.elem = x }
}

abstract sig Boolean {}
one sig True , False extends Boolean {}

// Underconstraint as result can always be true.
pred Contains ( This : List , x : Int , result : Boolean ) {
    RepOk [ This ]
    // Fix: replace "||" with "else" or replace "( x ! in This.header.*link.elem => result=False ) || result = True" with "x ! in This.header.*link.elem <=> result=False".
    ( x ! in This.header.*link.elem => result=False ) || result = True
}

assert repair_assert_1 {
    all l : List | all x : Int | all result: Boolean | RepOk[l] and Contains[l, x, result] <=>
        RepOk [l] and
        (x ! in l.header.*link.elem <=> result=False)
}
 check repair_assert_1
pred repair_pred_1 {
    all l : List | all x : Int | all result: Boolean | RepOk[l] and Contains[l, x, result] <=>
        RepOk [l] and
        (x ! in l.header.*link.elem <=> result=False)
}
 run repair_pred_1