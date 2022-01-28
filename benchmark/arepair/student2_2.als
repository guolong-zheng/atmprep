sig List {
    header: set Node
}

sig Node {
    link: set Node,
    elem: set Int
}


fact CardinalityConstraints {
    all l : List | lone l.header
    all n : Node | lone n.link
    all n : Node | one n.elem
}


pred Loop ( This : List ) {
    no This.header || one n : This.header.*link | n.^link = n.*link
}


pred Sorted ( This : List ) {
    all n: This.header.*link | some n.link =>  n.elem <= n.link.elem
}

fact { some Node }

assert repair_assert_2 {
	all l: List | all x : Int | all res : Boolean | { Contains[l, x, res] 
<=>
	{
		RepOk [ l ]
    	( x ! in l.header.*link.elem <=> res=False )
}}
}
check repair_assert_2

pred repair_pred_2 {
   all l : List | RepOk[l] and 
 { all x : Int | x !in l.header.*link.elem <=> ContainsR[l, x, False]}
}
run repair_pred_2

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

pred ContainsR ( This : List , x : Int , result : Boolean ) {
    RepOk [ This ]
    // Fix: replace "||" with "else" or replace "( x ! in This.header.*link.elem => result=False ) || result = True" with "x ! in This.header.*link.elem <=> result=False".
    ( x ! in This.header.*link.elem <=> result=False )
}


// Underconstraint as result can always be true.
pred Contains ( This : List , x : Int , result : Boolean ) {
    RepOk [ This ]
    // Fix: replace "||" with "else" or replace "( x ! in This.header.*link.elem => result=False ) || result = True" with "x ! in This.header.*link.elem <=> result=False".
    ( x ! in This.header.*link.elem => result=False ) || result = True
}

fact IGNORE {
  one List
  List.header.*link = Node
}
