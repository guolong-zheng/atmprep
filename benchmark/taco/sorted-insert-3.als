/* 
 * DynAlloy translator options 
 * --------------------------- 
 * assertionId= check_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0
 * loopUnroll= 3
 * removeQuantifiers= true
 * strictUnrolling= false
 * build_dynalloy_trace= false
 */ 

//-------------- prelude--------------//
module moduleId
open util/integer
open util/sequniv as sequniv
one sig null {}
fun fun_reach[h: univ, 
              holeType: set univ,
              field: univ -> univ
]: set univ { 
  h.*(field & holeType->(holeType+null)) & holeType
}

fun fun_weak_reach[h: univ, 
              holeType: set univ,
              field: univ -> univ
]: set univ { 
  h.*(field) & holeType
}

one
sig AssertionFailureLit extends java_lang_Throwable {}
abstract sig boolean {}
one sig true extends boolean {}
one sig false extends boolean {}
abstract sig char {}
pred TruePred[] {}
pred FalsePred[] { not TruePred[] }
pred equ[l,r:univ] {l=r}
pred neq[l,r:univ] {l!=r}
fun shl[l,r: Int]: Int { l << r } 
fun sshr[l,r: Int]: Int { l >> r } 
fun ushr[l,r: Int]: Int { l >>> r } 

fun fun_univ_equals[
  l:univ, 
  r: univ 
]: boolean { 
  (equ[l,r]) => true else false 
} 

fun fun_set_add[
  l: set univ,
  e: univ
]: set univ { 
  l+e 
} 

fun fun_set_remove[
  l: set univ,
  e: univ
]: set univ {
  l-e
}
fun fun_set_contains[
  l: set univ,
  e: univ
]: boolean {
  (e in l) => true else false 
}
pred isSubset[
  l: set univ,
  r: set univ
] {
  (l in r) 
}
pred isNotSubset[
  l: set univ,
  r: set univ
] {
  (l !in r) 
}
fun fun_set_size[s: set univ]: Int { #s } 

fun fun_not_empty_set[s: set univ]: boolean { (no s) => false else true } 

fun fun_set_is_empty[s: set univ]: boolean { (no s) => true else false }
pred pred_empty_set[l: set univ] { (no l) }
pred pred_set_some[l: set univ] { some l }
pred pred_set_one[l: set univ] { one l }
pred pred_set_lone[l: set univ] { lone l }
pred pred_Object_subset[
  s: set univ
] {
  s in java_lang_Object+null
}
fun fun_set_intersection[
  l: set univ,
  r: set univ
]: set univ {
  l & r 
} 
fun fun_set_difference[
  l: set univ,
  r: set univ
]: set univ {
  l - r 
} 
fun fun_rel_difference[ 
  rel: univ -> univ, 
  l: univ,
  r: univ
]: univ->univ {
 rel - (l->r) 
}
fun fun_rel_add[ 
  rel: univ -> univ, 
  l: univ,
  r: univ
]: univ->univ {
 rel + (l->r) 
}
fun fun_set_sum[
  s: set Int
]: Int {
  sum s 
}
pred pred_empty_list[l: Int -> univ] { (no l) }
fun fun_list_add[
  l: Int -> univ,
  e: univ
]: Int -> univ {
  l + (Int[#(l.univ)]->e)
} 

fun fun_list_get[
  l: Int -> univ, 
  index: Int
]: univ { 
  index.l 
} 

fun fun_list_contains[
  l: Int -> univ, 
  e: univ
]: boolean { 
  (e in Int.l) => true else false 
} 

fun fun_list_remove[
  l: Int -> univ, 
  index: Int
]: Int -> univ { 
  prevs[index]<:(l-(index->univ)) + next.(nexts[index]<:(l-(index->univ))) 
} 

fun fun_list_size[s: Int -> univ]: Int { #s } 

fun fun_list_equals[
  s1:Int -> univ, 
  s2: Int -> univ
]: boolean { 
  (s1=s2) => true else false 
} 

fun fun_list_empty[s: Int -> univ]: boolean { (#s = 0) => true else false }
pred pred_empty_map[map: univ -> univ] { (no map) }
fun fun_map_put[
  map: univ->univ, 
  k: univ, 
  v: univ
]: univ-> univ { 
  map ++ (k->v) 
}

fun fun_map_contains_key[
  map: univ -> univ, 
  k: univ
]: boolean { 
  (some k.map) => true else false 
}

fun fun_map_remove[
  map: univ -> univ, 
  k: univ
]: univ->univ {
  map - (k->univ) 
} 

fun fun_map_get[
  map: univ -> univ, 
  k: univ
]: univ { 
  (some k.map) => k.map else null 
} 

fun fun_map_is_empty[
  map: univ -> univ, 
]: boolean { 
  (some map) => false else true 
}

fun fun_map_clear[
  mapEntries1: univ -> univ -> univ, 
  map: univ
]: univ -> univ -> univ { 
  mapEntries1 - (map -> univ -> univ)
}

fun fun_map_size[
  map: univ -> univ, 
]: univ {
  #map 
}
pred isEmptyOrNull[u: univ] { u in null }
fun fun_closure[
  rel: univ -> univ 
]: univ -> univ {
  ^rel 
} 

fun fun_reflexive_closure[
  rel: univ -> univ 
]: univ -> univ {
  *rel 
} 

fun fun_transpose[
  rel: univ -> univ 
]: univ -> univ {
  ~rel 
}
pred liftExpression[
  expr: univ 
] {
  expr=true 
}
pred updateMapPost[
  f1:univ->univ->univ,
  f0:univ->univ->univ,
  map:univ, 
  entries:univ->univ
]{ 
  f1 = f0 ++ (map->entries) 
}
fun rel_override[
  r:univ->univ,
  k:univ, 
  v:univ
]: univ->univ { 
  r - (k->univ) + (k->v) 
} 

fun Not[a: boolean]: boolean {
    (a=true) => false else true 
}
fun Or[a: boolean, b: boolean]: boolean {
    (a=true or b=true) => true else false
}
fun And[a: boolean, b: boolean]: boolean {
    (a=true and b=true) => true else false
}
fun Xor[a: boolean, b: boolean]: boolean {
    ((a=true and b=false) or (a=false and b=true)) => true else false
}
fun AdderCarry[a: boolean, b: boolean, cin: boolean]: boolean {
    Or[ And[a,b], And[cin, Xor[a,b]]] 
}
fun AdderSum[a: boolean, b: boolean, cin: boolean]: boolean {
    Xor[Xor[a, b], cin]
}
pred updateFieldPost[
  f1:univ->univ,
  f0:univ->univ,
  l:univ,
  r:univ
]{ 
  (r=none) => f1=f0-(l->univ) else f1 = f0 ++ (l->r) 
}
pred havocVarPost[u:univ]{}
pred havocVariable2Post[u:univ->univ]{}
pred havocVariable3Post[u:univ->(seq univ)]{}
pred havocFieldPost[f0,f1: univ->univ, u:univ]{ 
  u<:f0 = u<:f1 
  some u.f1  
}
fun fun_alloy_int_java_util_set_size[
   s : java_util_Set,
   java_util_Set_elems : java_util_Set -> univ] : Int { 
      #(s.java_util_Set_elems)
} 

fun fun_java_util_set_contains[
   s : java_util_Set, o : java_lang_Object + null,
   java_util_Set_elems : java_util_Set -> univ] : boolean { 
      (o in s.java_util_Set_elems) => true else false
}
pred havocArrayContentsPost[array:  univ,
                            domain: set univ,
                            Array_0: univ -> (Int set -> lone univ),
                            Array_1: univ -> (Int set -> lone univ)
                           ] {
  Array_1 - (array->(domain->univ)) = Array_0 - (array->(domain->univ))
  (array.Array_1).univ = (array.Array_0).univ
}
pred havocFieldContentsPost[target: univ, 
                            field_0: univ -> univ, 
                            field_1: univ -> univ] { 
  field_1 - (target->univ) = field_0 - (target->univ) 
}
pred havocListSeqPost[target: univ,
                            field_0: univ -> Int -> univ, 
                            field_1: univ -> Int -> univ] { 
  field_1 - (target->Int->univ) = field_0 - (target->Int->univ) 
}
pred pred_in[n: univ, t: set univ] { n in t }
pred instanceOf[n: univ, t: set univ] { n in t }
pred isCasteableTo[n: univ, t: set univ] { (n in t) or (n = null) }
pred getUnusedObjectPost[
  usedObjects1:set java_lang_Object, 
  usedObjects0:set java_lang_Object,
  n1: java_lang_Object+null
]{ 
  n1 !in usedObjects0 
  usedObjects1 = usedObjects0 + (n1)
}
pred updateArrayPost[
     Object_Array1: java_lang_ObjectArray -> (Int set -> lone univ), 
     Object_Array0: java_lang_ObjectArray -> (Int set -> lone univ),
     array: java_lang_ObjectArray+null,
     index:Int,
     elem:univ
]{ 
     Object_Array1 = Object_Array0 ++ 
     (array->(array.Object_Array0++(index->elem)))
}
fun arrayAccess[
     Object_Array:java_lang_ObjectArray, 
     array_field: java_lang_ObjectArray -> (Int set -> lone (java_lang_Object + null)), 
     index: Int
]: univ {
     some (Object_Array.array_field)[index] implies (Object_Array.array_field)[index] else null
}

fun arrayLength[
     array: java_lang_ObjectArray+null,
     length_field: java_lang_ObjectArray -> one Int
]: Int {
     array.length_field
}

fun arrayElements[
  Object_Array:java_lang_ObjectArray->(Int set -> lone univ), 
  array: java_lang_ObjectArray+null
]: set univ {
  Int.(array.Object_Array)
}
pred updateArrayPost[
  Int_Array1: java_lang_IntArray -> (Int set -> lone Int), 
  Int_Array0: java_lang_IntArray -> (Int set -> lone Int),
  array: java_lang_IntArray+null,
  index:Int,
  elem:Int
]{ 
  Int_Array1 = Int_Array0 ++ 
  (array->(array.Int_Array0++(index->Int)))
}
fun arrayAccess[
  Int_Array:java_lang_IntArray, 
  array_field:java_lang_IntArray -> (Int set -> lone Int),
  index: Int
]: Int {
  some (Int_Array.array_field)[index] implies (Int_Array.array_field)[index] else 0
}

fun arrayLength[
  array: java_lang_IntArray+null,
  length_field: java_lang_IntArray -> one Int
]: Int {
  array.length_field
}

fun arrayElements[
  Int_Array:java_lang_IntArray->(Int set -> lone Int), 
  array: java_lang_IntArray+null
]: set Int {
  Int.(array.Int_Array)
}
//-------------- java_lang_IntArray--------------//
sig java_lang_IntArray extends java_lang_Object {}
{}




//-------------- java_lang_Throwable--------------//
abstract sig java_lang_Throwable extends java_lang_Object {}
{}



one
sig java_lang_ThrowableLit extends java_lang_Throwable {}
{}

//-------------- java_util_NoSuchElementException--------------//
abstract one sig java_util_NoSuchElementException extends java_lang_Exception {}
{}



one
sig java_util_NoSuchElementExceptionLit extends java_util_NoSuchElementException {}
{}

//-------------- sos_koa_AuditLogXMLReader--------------//
sig sos_koa_AuditLogXMLReader extends java_lang_Object {}
{}




//-------------- java_lang_Integer--------------//
sig java_lang_Integer extends java_lang_Object {}
{}




//-------------- java_lang_NegativeArraySizeException--------------//
abstract one sig java_lang_NegativeArraySizeException extends java_lang_RuntimeException {}
{}



one
sig java_lang_NegativeArraySizeExceptionLit extends java_lang_NegativeArraySizeException {}
{}

//-------------- java_lang_Object--------------//
abstract sig java_lang_Object {}
{}




//-------------- java_lang_IndexOutOfBoundsException--------------//
abstract one sig java_lang_IndexOutOfBoundsException extends java_lang_RuntimeException {}
{}



one
sig java_lang_IndexOutOfBoundsExceptionLit extends java_lang_IndexOutOfBoundsException {}
{}

//-------------- java_util_List--------------//
sig java_util_List extends java_lang_Object {}
{}




//-------------- org_jmlspecs_models_JMLObjectSequence--------------//
abstract sig org_jmlspecs_models_JMLObjectSequence {}
{}




//-------------- SinglyLinkedListIntSortedInsert1Bug--------------//
sig SinglyLinkedListIntSortedInsert1Bug extends java_lang_Object {}
{}
pred SinglyLinkedListIntSortedInsert1BugCondition9[
  var_1_currentRef:univ
]{
   not (
     isEmptyOrNull[var_1_currentRef])

}
pred SinglyLinkedListIntSortedInsert1BugCondition19[
  t_7:univ
]{
   t_7=true

}
pred SinglyLinkedListIntSortedInsert1BugCondition14[
  exit_stmt_reached:univ,
  throw:univ,
  var_3_ws_1:univ
]{
   liftExpression[var_3_ws_1]
   and 
   (
     throw=null)
   and 
   (
     exit_stmt_reached=false)

}
pred SinglyLinkedListIntSortedInsert1BugCondition10[
  t_6:univ
]{
   t_6=true

}
pred SinglyLinkedListIntSortedInsert1BugCondition11[
  t_6:univ
]{
   not (
     t_6=true)

}
pred SinglyLinkedListIntSortedInsert1BugCondition12[
  t_5:univ
]{
   t_5=true

}
pred SinglyLinkedListIntSortedInsert1BugCondition8[
  var_1_currentRef:univ
]{
   isEmptyOrNull[var_1_currentRef]

}
pred SinglyLinkedListIntSortedInsert1BugCondition13[
  t_5:univ
]{
   not (
     t_5=true)

}
pred SinglyLinkedListIntSortedInsert1BugCondition5[
  t_3:univ
]{
   not (
     t_3=true)

}
pred SinglyLinkedListIntSortedInsert1BugCondition7[
  t_2:univ
]{
   not (
     t_2=true)

}
pred SinglyLinkedListIntSortedInsert1BugCondition4[
  t_3:univ
]{
   t_3=true

}
pred SinglyLinkedListIntSortedInsert1BugCondition6[
  t_2:univ
]{
   t_2=true

}
pred SinglyLinkedListIntSortedInsert1Bug_ensures[
  SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  SinglyLinkedListIntSortedInsert1Bug_header':univ->univ,
  SinglyLinkedListNodeInt_next:univ->univ,
  SinglyLinkedListNodeInt_next':univ->univ,
  SinglyLinkedListNodeInt_value:univ->univ,
  SinglyLinkedListNodeInt_value':univ->univ,
  newNode':univ,
  thiz:univ,
  thiz':univ,
  throw':univ
]{
   (
     instanceOf[throw',
               java_lang_Exception]
     implies 
             liftExpression[false]
   )
   and 
   (
     (
       throw'=null)
     implies 
             liftExpression[fun_set_contains[fun_reach[thiz'.SinglyLinkedListIntSortedInsert1Bug_header',SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next'],newNode']]
   )
   and 
   (
     (
       throw'=null)
     implies 
             (
               all n:SinglyLinkedListNodeInt+null | {
                 liftExpression[fun_set_contains[fun_reach[thiz.SinglyLinkedListIntSortedInsert1Bug_header,SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next],n]]
                 implies 
                         (
                           (
                             fun_set_contains[fun_reach[thiz'.SinglyLinkedListIntSortedInsert1Bug_header',SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next'],n]=true)
                           and 
                           equ[n.SinglyLinkedListNodeInt_value,
                              n.SinglyLinkedListNodeInt_value']
                         )
               
               }
             )
   )
   and 
   (
     (
       throw'=null)
     implies 
             (
               all n:SinglyLinkedListNodeInt+null | {
                 (
                   (
                     fun_set_contains[fun_reach[thiz'.SinglyLinkedListIntSortedInsert1Bug_header',SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next'],n]=true)
                   and 
                   neq[n.SinglyLinkedListNodeInt_next',
                      null]
                 )
                 implies 
                         lte[n.SinglyLinkedListNodeInt_value',
                            (n.SinglyLinkedListNodeInt_next').SinglyLinkedListNodeInt_value']
               
               }
             )
   )

}
pred postcondition_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  SinglyLinkedListIntSortedInsert1Bug_header':univ->univ,
  SinglyLinkedListNodeInt_next:univ->univ,
  SinglyLinkedListNodeInt_next':univ->univ,
  SinglyLinkedListNodeInt_value:univ->univ,
  SinglyLinkedListNodeInt_value':univ->univ,
  newNode':univ,
  thiz:univ,
  thiz':univ,
  throw':univ
]{
   SinglyLinkedListIntSortedInsert1Bug_ensures[SinglyLinkedListIntSortedInsert1Bug_header,
                                              SinglyLinkedListIntSortedInsert1Bug_header',
                                              SinglyLinkedListNodeInt_next,
                                              SinglyLinkedListNodeInt_next',
                                              SinglyLinkedListNodeInt_value,
                                              SinglyLinkedListNodeInt_value',
                                              newNode',
                                              thiz,
                                              thiz',
                                              throw']
   and 
   (
     not (
       throw'=AssertionFailureLit)
   )
   and 
   SinglyLinkedListIntSortedInsert1Bug_object_invariant[SinglyLinkedListIntSortedInsert1Bug_header',
                                                       SinglyLinkedListNodeInt_next',
                                                       thiz']

}
pred SinglyLinkedListIntSortedInsert1BugCondition1[
  exit_stmt_reached:univ,
  throw:univ
]{
   not (
     (
       throw=null)
     and 
     (
       exit_stmt_reached=false)
   )

}
pred SinglyLinkedListIntSortedInsert1BugCondition0[
  exit_stmt_reached:univ,
  throw:univ
]{
   (
     throw=null)
   and 
   (
     exit_stmt_reached=false)

}
pred precondition_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  SinglyLinkedListNodeInt_next:univ->univ,
  SinglyLinkedListNodeInt_value:univ->univ,
  newNode:univ,
  thiz:univ,
  throw:univ
]{
   SinglyLinkedListIntSortedInsert1Bug_requires[SinglyLinkedListIntSortedInsert1Bug_header,
                                               SinglyLinkedListNodeInt_next,
                                               SinglyLinkedListNodeInt_value,
                                               newNode,
                                               thiz]
   and 
   equ[throw,
      null]
   and 
   SinglyLinkedListIntSortedInsert1Bug_object_invariant[SinglyLinkedListIntSortedInsert1Bug_header,
                                                       SinglyLinkedListNodeInt_next,
                                                       thiz]

}
pred SinglyLinkedListIntSortedInsert1BugCondition20[
  t_7:univ
]{
   not (
     t_7=true)

}
pred SinglyLinkedListIntSortedInsert1Bug_object_invariant[
  SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  SinglyLinkedListNodeInt_next:univ->univ,
  thiz:univ
]{
   all n:SinglyLinkedListNodeInt+null | {
     liftExpression[fun_set_contains[fun_reach[thiz.SinglyLinkedListIntSortedInsert1Bug_header,SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next],n]]
     implies 
             equ[fun_set_contains[fun_reach[n.SinglyLinkedListNodeInt_next,SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next],n],
                false]
   
   }

}
pred SinglyLinkedListIntSortedInsert1BugCondition2[
  thiz:univ
]{
   isEmptyOrNull[thiz]

}
pred SinglyLinkedListIntSortedInsert1BugCondition3[
  thiz:univ
]{
   not (
     isEmptyOrNull[thiz])

}
pred SinglyLinkedListIntSortedInsert1BugCondition15[
  newNode:univ,
  var_1_currentRef:univ
]{
   isEmptyOrNull[newNode]
   or 
   isEmptyOrNull[var_1_currentRef]

}
pred SinglyLinkedListIntSortedInsert1Bug_requires[
  SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  SinglyLinkedListNodeInt_next:univ->univ,
  SinglyLinkedListNodeInt_value:univ->univ,
  newNode:univ,
  thiz:univ
]{
   neq[newNode,
      null]
   and 
   (
     all n:SinglyLinkedListNodeInt+null | {
       liftExpression[fun_set_contains[fun_reach[thiz.SinglyLinkedListIntSortedInsert1Bug_header,SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next],n]]
       implies 
               neq[n,
                  newNode]
     
     }
   )
   and 
   (
     all n:SinglyLinkedListNodeInt+null | {
       (
         (
           fun_set_contains[fun_reach[thiz.SinglyLinkedListIntSortedInsert1Bug_header,SinglyLinkedListNodeInt,SinglyLinkedListNodeInt_next],n]=true)
         and 
         neq[n.SinglyLinkedListNodeInt_next,
            null]
       )
       implies 
               lte[n.SinglyLinkedListNodeInt_value,
                  (n.SinglyLinkedListNodeInt_next).SinglyLinkedListNodeInt_value]
     
     }
   )

}
pred SinglyLinkedListIntSortedInsert1BugCondition17[
  var_2_prevRef:univ
]{
   isEmptyOrNull[var_2_prevRef]

}
pred SinglyLinkedListIntSortedInsert1BugCondition18[
  var_2_prevRef:univ
]{
   not (
     isEmptyOrNull[var_2_prevRef])

}
pred SinglyLinkedListIntSortedInsert1BugCondition16[
  newNode:univ,
  var_1_currentRef:univ
]{
   not (
     isEmptyOrNull[newNode]
     or 
     isEmptyOrNull[var_1_currentRef]
   )

}
//-------------- java_lang_ClassCastException--------------//
abstract one sig java_lang_ClassCastException extends java_lang_RuntimeException {}
{}



one
sig java_lang_ClassCastExceptionLit extends java_lang_ClassCastException {}
{}

//-------------- java_lang_Byte--------------//
sig java_lang_Byte extends java_lang_Object {}
{}




//-------------- java_util_ArrayList--------------//
sig java_util_ArrayList extends java_util_List {}
{}




//-------------- java_util_HashSet--------------//
sig java_util_HashSet extends java_util_Set {}
{}




//-------------- javax_xml_transform_sax_SAXSource--------------//
sig javax_xml_transform_sax_SAXSource extends javax_xml_transform_Source {}
{}




//-------------- java_lang_ObjectArray--------------//
sig java_lang_ObjectArray extends java_lang_Object {}
{}




//-------------- javax_xml_transform_Source--------------//
abstract sig javax_xml_transform_Source extends java_lang_Object {}
{}




//-------------- java_lang_System--------------//
abstract sig java_lang_System {}
{}




//-------------- java_lang_ArithmeticException--------------//
abstract one sig java_lang_ArithmeticException extends java_lang_RuntimeException {}
{}



one
sig java_lang_ArithmeticExceptionLit extends java_lang_ArithmeticException {}
{}

//-------------- java_util_SortedMap--------------//
abstract sig java_util_SortedMap extends java_util_Map {}
{}




//-------------- java_util_Map--------------//
abstract sig java_util_Map extends java_lang_Object {}
{}




//-------------- java_lang_String--------------//
sig java_lang_String extends java_lang_Object {}
{}




//-------------- ClassFields--------------//
one
sig ClassFields {}
{}




//-------------- java_lang_RuntimeException--------------//
abstract sig java_lang_RuntimeException extends java_lang_Exception {}
{}



one
sig java_lang_RuntimeExceptionLit extends java_lang_RuntimeException {}
{}

//-------------- java_util_TreeMap--------------//
sig java_util_TreeMap extends java_util_SortedMap {}
{}




//-------------- SinglyLinkedListNodeInt--------------//
sig SinglyLinkedListNodeInt extends java_lang_Object {}
{}




//-------------- java_lang_Boolean--------------//
sig java_lang_Boolean extends java_lang_Object {}
{}




//-------------- java_util_HashMap--------------//
sig java_util_HashMap extends java_util_Map {}
{}




//-------------- java_lang_Exception--------------//
abstract sig java_lang_Exception extends java_lang_Throwable {}
{}



one
sig java_lang_ExceptionLit extends java_lang_Exception {}
{}

//-------------- java_lang_IllegalArgumentException--------------//
abstract one sig java_lang_IllegalArgumentException extends java_lang_RuntimeException {}
{}



one
sig java_lang_IllegalArgumentExceptionLit extends java_lang_IllegalArgumentException {}
{}

//-------------- java_util_Date--------------//
sig java_util_Date extends java_lang_Object {}
{}




//-------------- org_jmlspecs_models_JMLObjectSet--------------//
abstract sig org_jmlspecs_models_JMLObjectSet {}
{}




//-------------- java_lang_NullPointerException--------------//
abstract one sig java_lang_NullPointerException extends java_lang_RuntimeException {}
{}



one
sig java_lang_NullPointerExceptionLit extends java_lang_NullPointerException {}
{}

//-------------- java_lang_Character--------------//
sig java_lang_Character extends java_lang_Object {}
{}




//-------------- java_util_Iterator--------------//
sig java_util_Iterator extends java_lang_Object {}
{}




//-------------- java_util_Set--------------//
sig java_util_Set extends java_lang_Object {}
{}
check repair_assert_0  for 0 but  exactly 0 java_lang_IntArray, exactly 0 java_lang_Integer, exactly 0 sos_koa_AuditLogXMLReader, exactly 6 java_lang_Object, exactly 0 java_util_List, exactly 0 org_jmlspecs_models_JMLObjectSequence, exactly 1 SinglyLinkedListIntSortedInsert1Bug, exactly 0 java_util_HashSet, exactly 0 java_lang_Byte, exactly 0 java_util_ArrayList, exactly 0 javax_xml_transform_sax_SAXSource, exactly 0 java_lang_System, exactly 0 java_lang_ObjectArray, exactly 0 javax_xml_transform_Source, exactly 0 java_util_SortedMap, exactly 0 java_util_Map, exactly 0 java_lang_String, exactly 0 java_util_TreeMap, exactly 3 SinglyLinkedListNodeInt, exactly 2 java_lang_Boolean, exactly 0 java_util_HashMap, exactly 0 java_util_Date, exactly 0 org_jmlspecs_models_JMLObjectSet, exactly 0 java_lang_Character, exactly 0 java_util_Iterator, exactly 0 java_util_Set,4 int

run repair_pred_0  for 0 but  exactly 0 java_lang_IntArray, exactly 0 java_lang_Integer, exactly 0 sos_koa_AuditLogXMLReader, exactly 6 java_lang_Object, exactly 0 java_util_List, exactly 0 org_jmlspecs_models_JMLObjectSequence, exactly 1 SinglyLinkedListIntSortedInsert1Bug, exactly 0 java_util_HashSet, exactly 0 java_lang_Byte, exactly 0 java_util_ArrayList, exactly 0 javax_xml_transform_sax_SAXSource, exactly 0 java_lang_System, exactly 0 java_lang_ObjectArray, exactly 0 javax_xml_transform_Source, exactly 0 java_util_SortedMap, exactly 0 java_util_Map, exactly 0 java_lang_String, exactly 0 java_util_TreeMap, exactly 3 SinglyLinkedListNodeInt, exactly 2 java_lang_Boolean, exactly 0 java_util_HashMap, exactly 0 java_util_Date, exactly 0 org_jmlspecs_models_JMLObjectSet, exactly 0 java_lang_Character, exactly 0 java_util_Iterator, exactly 0 java_util_Set,4 int


pred havocArrayContents[
  array_0: univ,
  domain_0: set univ,
  Array_0: univ -> ( Int set -> lone univ ),
  Array_1: univ -> ( Int set -> lone univ )
]{
  TruePred[]
  and 
  havocArrayContentsPost[array_0,
                        domain_0,
                        Array_0,
                        Array_1]
}


pred updateMap[
  Map_entries_0: java_util_Map -> univ -> univ,
  Map_entries_1: java_util_Map -> univ -> univ,
  map_0: java_util_Map,
  entries_0: univ -> univ
]{
  TruePred[]
  and 
  updateMapPost[Map_entries_1,
               Map_entries_0,
               map_0,
               entries_0]
}


pred updateVariable[
  l_1: univ,
  r_0: univ
]{
  TruePred[]
  and 
  equ[l_1,
     r_0]
}


pred getUnusedObject[
  n_1: java_lang_Object + null,
  usedObjects_0: set java_lang_Object,
  usedObjects_1: set java_lang_Object
]{
  TruePred[]
  and 
  getUnusedObjectPost[usedObjects_1,
                     usedObjects_0,
                     n_1]
}


pred havocVariable[
  v_1: univ
]{
  TruePred[]
  and 
  havocVarPost[v_1]
}


pred havocFieldContents[
  target_0: univ,
  field_0: univ -> univ,
  field_1: univ -> univ
]{
  TruePred[]
  and 
  havocFieldContentsPost[target_0,
                        field_0,
                        field_1]
}


pred havocVariable3[
  u_1: univ -> ( seq univ )
]{
  TruePred[]
  and 
  havocVariable3Post[u_1]
}


pred havocVariable2[
  u_1: univ -> univ
]{
  TruePred[]
  and 
  havocVariable2Post[u_1]
}


pred havocField[
  f_0: univ -> univ,
  f_1: univ -> univ,
  u_0: univ
]{
  TruePred[]
  and 
  havocFieldPost[f_0,
                f_1,
                u_0]
}


pred havocListSeq[
  target_0: univ,
  field_0: univ -> Int -> univ,
  field_1: univ -> Int -> univ
]{
  TruePred[]
  and 
  havocListSeqPost[target_0,
                  field_0,
                  field_1]
}


pred updateField[
  l_0: univ,
  f_0: univ -> univ,
  f_1: univ -> univ,
  r_0: univ
]{
  TruePred[]
  and 
  updateFieldPost[f_1,
                 f_0,
                 l_0,
                 r_0]
}


pred updateArray[
  Int_Array_0: java_lang_IntArray -> ( Int set -> lone Int ),
  Int_Array_1: java_lang_IntArray -> ( Int set -> lone Int ),
  array_0: java_lang_IntArray + null,
  index_0: Int,
  elem_0: Int
]{
  TruePred[]
  and 
  updateArrayPost[Int_Array_1,
                 Int_Array_0,
                 array_0,
                 index_0,
                 elem_0]
}


pred SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  thiz_0: SinglyLinkedListIntSortedInsert1Bug,
  throw_1: java_lang_Throwable + null,
  throw_2: java_lang_Throwable + null,
  throw_3: java_lang_Throwable + null,
  throw_4: java_lang_Throwable + null,
  throw_5: java_lang_Throwable + null,
  throw_6: java_lang_Throwable + null,
  throw_7: java_lang_Throwable + null,
  newNode_0: SinglyLinkedListNodeInt + null,
  SinglyLinkedListNodeInt_value_0: ( SinglyLinkedListNodeInt ) -> one ( Int ),
  SinglyLinkedListIntSortedInsert1Bug_header_0: ( SinglyLinkedListIntSortedInsert1Bug ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListIntSortedInsert1Bug_header_1: ( SinglyLinkedListIntSortedInsert1Bug ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_0: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_1: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_2: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  t_2_0: boolean,
  t_2_1: boolean,
  t_3_0: boolean,
  t_3_1: boolean,
  exit_stmt_reached_1: boolean,
  t_1_0: boolean,
  t_1_1: boolean,
  var_2_prevRef_0: SinglyLinkedListNodeInt + null,
  var_2_prevRef_1: SinglyLinkedListNodeInt + null,
  var_2_prevRef_2: SinglyLinkedListNodeInt + null,
  var_2_prevRef_3: SinglyLinkedListNodeInt + null,
  var_2_prevRef_4: SinglyLinkedListNodeInt + null,
  var_1_currentRef_0: SinglyLinkedListNodeInt + null,
  var_1_currentRef_1: SinglyLinkedListNodeInt + null,
  var_1_currentRef_2: SinglyLinkedListNodeInt + null,
  var_1_currentRef_3: SinglyLinkedListNodeInt + null,
  var_1_currentRef_4: SinglyLinkedListNodeInt + null,
  t_6_0: boolean,
  t_6_1: boolean,
  t_6_2: boolean,
  t_6_3: boolean,
  var_3_ws_1_0: boolean,
  var_3_ws_1_1: boolean,
  var_3_ws_1_2: boolean,
  var_3_ws_1_3: boolean,
  var_3_ws_1_4: boolean,
  t_7_0: boolean,
  t_7_1: boolean,
  t_4_0: boolean,
  t_4_1: boolean,
  t_4_2: boolean,
  t_4_3: boolean,
  param_newNode_0_0: SinglyLinkedListNodeInt + null,
  param_newNode_0_1: SinglyLinkedListNodeInt + null,
  t_5_0: boolean,
  t_5_1: boolean,
  t_5_2: boolean,
  t_5_3: boolean
]{
  TruePred[]
  and 
  (
    throw_1=null)
  and 
  TruePred[]
  and 
  (
    exit_stmt_reached_1=false)
  and 
  TruePred[]
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_1]
      and 
      (
        param_newNode_0_1=newNode_0)
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_1]
        )
      )
      and 
      TruePred[]
      and 
      (
        param_newNode_0_0=param_newNode_0_1)
    )
  )
  and 
  TruePred[]
  and 
  TruePred[]
  and 
  TruePred[]
  and 
  TruePred[]
  and 
  TruePred[]
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_1]
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0]
          and 
          (
            throw_2=java_lang_NullPointerExceptionLit)
          and 
          (
            var_1_currentRef_0=var_1_currentRef_1)
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0])
          )
          and 
          (
            var_1_currentRef_1=thiz_0.SinglyLinkedListIntSortedInsert1Bug_header_0)
          and 
          (
            throw_1=throw_2)
        )
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_1]
        )
      )
      and 
      TruePred[]
      and 
      (
        var_1_currentRef_0=var_1_currentRef_1)
      and 
      (
        throw_1=throw_2)
    )
  )
  and 
  TruePred[]
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_2]
      and 
      (
        var_2_prevRef_1=((SinglyLinkedListNodeInt+null) & (null)))
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
        )
      )
      and 
      TruePred[]
      and 
      (
        var_2_prevRef_0=var_2_prevRef_1)
    )
  )
  and 
  TruePred[]
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_2]
      and 
      (
        t_2_1=(neq[var_1_currentRef_1,
           null]=>(true)else(false))
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
        )
      )
      and 
      TruePred[]
      and 
      (
        t_2_0=t_2_1)
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_2]
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition6[t_2_1]
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_2]
              and 
              (
                t_3_1=(lt[var_1_currentRef_1.SinglyLinkedListNodeInt_value_0,
                  newNode_0.SinglyLinkedListNodeInt_value_0]=>(true)else(false))
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_2]
                )
              )
              and 
              TruePred[]
              and 
              (
                t_3_0=t_3_1)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_2]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition4[t_3_1]
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_2]
                      and 
                      (
                        t_1_1=true)
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_2]
                        )
                      )
                      and 
                      TruePred[]
                      and 
                      (
                        t_1_0=t_1_1)
                    )
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition4[t_3_1])
                  )
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_2]
                      and 
                      (
                        t_1_1=false)
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_2]
                        )
                      )
                      and 
                      TruePred[]
                      and 
                      (
                        t_1_0=t_1_1)
                    )
                  )
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_2]
                )
              )
              and 
              TruePred[]
              and 
              (
                t_1_0=t_1_1)
            )
          )
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition6[t_2_1])
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_2]
              and 
              (
                t_1_1=false)
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_2]
                )
              )
              and 
              TruePred[]
              and 
              (
                t_1_0=t_1_1)
            )
          )
          and 
          (
            t_3_0=t_3_1)
        )
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
        )
      )
      and 
      TruePred[]
      and 
      (
        t_1_0=t_1_1)
      and 
      (
        t_3_0=t_3_1)
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_2]
      and 
      (
        var_3_ws_1_1=t_1_1)
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
        )
      )
      and 
      TruePred[]
      and 
      (
        var_3_ws_1_0=var_3_ws_1_1)
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                    throw_2,
                                                    var_3_ws_1_1]
      and 
      TruePred[]
      and 
      TruePred[]
      and 
      TruePred[]
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
          and 
          (
            var_2_prevRef_2=var_1_currentRef_1)
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_2]
            )
          )
          and 
          TruePred[]
          and 
          (
            var_2_prevRef_1=var_2_prevRef_2)
        )
      )
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_2]
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_1]
              and 
              (
                throw_3=java_lang_NullPointerExceptionLit)
              and 
              (
                var_1_currentRef_1=var_1_currentRef_2)
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_1])
              )
              and 
              (
                var_1_currentRef_2=var_1_currentRef_1.SinglyLinkedListNodeInt_next_0)
              and 
              (
                throw_2=throw_3)
            )
          )
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_2]
            )
          )
          and 
          TruePred[]
          and 
          (
            var_1_currentRef_1=var_1_currentRef_2)
          and 
          (
            throw_2=throw_3)
        )
      )
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_3]
          and 
          (
            t_5_1=(neq[var_1_currentRef_2,
               null]=>(true)else(false))
          )
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_3]
            )
          )
          and 
          TruePred[]
          and 
          (
            t_5_0=t_5_1)
        )
      )
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_3]
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition12[t_5_1]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_3]
                  and 
                  (
                    t_6_1=(lt[var_1_currentRef_2.SinglyLinkedListNodeInt_value_0,
                      newNode_0.SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_3]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    t_6_0=t_6_1)
                )
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_3]
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition10[t_6_1]
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_3]
                          and 
                          (
                            t_4_1=true)
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_3]
                            )
                          )
                          and 
                          TruePred[]
                          and 
                          (
                            t_4_0=t_4_1)
                        )
                      )
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition10[t_6_1])
                      )
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_3]
                          and 
                          (
                            t_4_1=false)
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_3]
                            )
                          )
                          and 
                          TruePred[]
                          and 
                          (
                            t_4_0=t_4_1)
                        )
                      )
                    )
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_3]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    t_4_0=t_4_1)
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition12[t_5_1])
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_3]
                  and 
                  (
                    t_4_1=false)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_3]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    t_4_0=t_4_1)
                )
              )
              and 
              (
                t_6_0=t_6_1)
            )
          )
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_3]
            )
          )
          and 
          TruePred[]
          and 
          (
            t_6_0=t_6_1)
          and 
          (
            t_4_0=t_4_1)
        )
      )
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_3]
          and 
          (
            var_3_ws_1_2=t_4_1)
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_3]
            )
          )
          and 
          TruePred[]
          and 
          (
            var_3_ws_1_1=var_3_ws_1_2)
        )
      )
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                        throw_3,
                                                        var_3_ws_1_2]
          and 
          TruePred[]
          and 
          TruePred[]
          and 
          TruePred[]
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_3]
              and 
              (
                var_2_prevRef_3=var_1_currentRef_2)
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_3]
                )
              )
              and 
              TruePred[]
              and 
              (
                var_2_prevRef_2=var_2_prevRef_3)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_3]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_2]
                  and 
                  (
                    throw_4=java_lang_NullPointerExceptionLit)
                  and 
                  (
                    var_1_currentRef_2=var_1_currentRef_3)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_2])
                  )
                  and 
                  (
                    var_1_currentRef_3=var_1_currentRef_2.SinglyLinkedListNodeInt_next_0)
                  and 
                  (
                    throw_3=throw_4)
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_3]
                )
              )
              and 
              TruePred[]
              and 
              (
                var_1_currentRef_2=var_1_currentRef_3)
              and 
              (
                throw_3=throw_4)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_4]
              and 
              (
                t_5_2=(neq[var_1_currentRef_3,
                   null]=>(true)else(false))
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_4]
                )
              )
              and 
              TruePred[]
              and 
              (
                t_5_1=t_5_2)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_4]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition12[t_5_2]
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_4]
                      and 
                      (
                        t_6_2=(lt[var_1_currentRef_3.SinglyLinkedListNodeInt_value_0,
                          newNode_0.SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                      )
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_4]
                        )
                      )
                      and 
                      TruePred[]
                      and 
                      (
                        t_6_1=t_6_2)
                    )
                  )
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_4]
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition10[t_6_2]
                          and 
                          (
                            (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_4]
                              and 
                              (
                                t_4_2=true)
                            )
                            or 
                            (
                              (
                                not (
                                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                               throw_4]
                                )
                              )
                              and 
                              TruePred[]
                              and 
                              (
                                t_4_1=t_4_2)
                            )
                          )
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition10[t_6_2])
                          )
                          and 
                          (
                            (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_4]
                              and 
                              (
                                t_4_2=false)
                            )
                            or 
                            (
                              (
                                not (
                                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                               throw_4]
                                )
                              )
                              and 
                              TruePred[]
                              and 
                              (
                                t_4_1=t_4_2)
                            )
                          )
                        )
                      )
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_4]
                        )
                      )
                      and 
                      TruePred[]
                      and 
                      (
                        t_4_1=t_4_2)
                    )
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition12[t_5_2])
                  )
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_4]
                      and 
                      (
                        t_4_2=false)
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_4]
                        )
                      )
                      and 
                      TruePred[]
                      and 
                      (
                        t_4_1=t_4_2)
                    )
                  )
                  and 
                  (
                    t_6_1=t_6_2)
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_4]
                )
              )
              and 
              TruePred[]
              and 
              (
                t_6_1=t_6_2)
              and 
              (
                t_4_1=t_4_2)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_4]
              and 
              (
                var_3_ws_1_3=t_4_2)
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_4]
                )
              )
              and 
              TruePred[]
              and 
              (
                var_3_ws_1_2=var_3_ws_1_3)
            )
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                            throw_4,
                                                            var_3_ws_1_3]
              and 
              TruePred[]
              and 
              TruePred[]
              and 
              TruePred[]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_4]
                  and 
                  (
                    var_2_prevRef_4=var_1_currentRef_3)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_4]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    var_2_prevRef_3=var_2_prevRef_4)
                )
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_4]
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_3]
                      and 
                      (
                        throw_5=java_lang_NullPointerExceptionLit)
                      and 
                      (
                        var_1_currentRef_3=var_1_currentRef_4)
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_3])
                      )
                      and 
                      (
                        var_1_currentRef_4=var_1_currentRef_3.SinglyLinkedListNodeInt_next_0)
                      and 
                      (
                        throw_4=throw_5)
                    )
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_4]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    var_1_currentRef_3=var_1_currentRef_4)
                  and 
                  (
                    throw_4=throw_5)
                )
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_5]
                  and 
                  (
                    t_5_3=(neq[var_1_currentRef_4,
                       null]=>(true)else(false))
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_5]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    t_5_2=t_5_3)
                )
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_5]
                  and 
                  (
                    (
                      SinglyLinkedListIntSortedInsert1BugCondition12[t_5_3]
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_5]
                          and 
                          (
                            t_6_3=(lt[var_1_currentRef_4.SinglyLinkedListNodeInt_value_0,
                              newNode_0.SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                          )
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_5]
                            )
                          )
                          and 
                          TruePred[]
                          and 
                          (
                            t_6_2=t_6_3)
                        )
                      )
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_5]
                          and 
                          (
                            (
                              SinglyLinkedListIntSortedInsert1BugCondition10[t_6_3]
                              and 
                              (
                                (
                                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                               throw_5]
                                  and 
                                  (
                                    t_4_3=true)
                                )
                                or 
                                (
                                  (
                                    not (
                                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                   throw_5]
                                    )
                                  )
                                  and 
                                  TruePred[]
                                  and 
                                  (
                                    t_4_2=t_4_3)
                                )
                              )
                            )
                            or 
                            (
                              (
                                not (
                                  SinglyLinkedListIntSortedInsert1BugCondition10[t_6_3])
                              )
                              and 
                              (
                                (
                                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                               throw_5]
                                  and 
                                  (
                                    t_4_3=false)
                                )
                                or 
                                (
                                  (
                                    not (
                                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                   throw_5]
                                    )
                                  )
                                  and 
                                  TruePred[]
                                  and 
                                  (
                                    t_4_2=t_4_3)
                                )
                              )
                            )
                          )
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_5]
                            )
                          )
                          and 
                          TruePred[]
                          and 
                          (
                            t_4_2=t_4_3)
                        )
                      )
                    )
                    or 
                    (
                      (
                        not (
                          SinglyLinkedListIntSortedInsert1BugCondition12[t_5_3])
                      )
                      and 
                      (
                        (
                          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                       throw_5]
                          and 
                          (
                            t_4_3=false)
                        )
                        or 
                        (
                          (
                            not (
                              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                           throw_5]
                            )
                          )
                          and 
                          TruePred[]
                          and 
                          (
                            t_4_2=t_4_3)
                        )
                      )
                      and 
                      (
                        t_6_2=t_6_3)
                    )
                  )
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_5]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    t_6_2=t_6_3)
                  and 
                  (
                    t_4_2=t_4_3)
                )
              )
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_5]
                  and 
                  (
                    var_3_ws_1_4=t_4_3)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                   throw_5]
                    )
                  )
                  and 
                  TruePred[]
                  and 
                  (
                    var_3_ws_1_3=var_3_ws_1_4)
                )
              )
              and 
              TruePred[]
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                throw_4,
                                                                var_3_ws_1_3]
                )
              )
              and 
              TruePred[]
              and 
              (
                var_1_currentRef_3=var_1_currentRef_4)
              and 
              (
                var_2_prevRef_3=var_2_prevRef_4)
              and 
              (
                t_5_2=t_5_3)
              and 
              (
                t_6_2=t_6_3)
              and 
              (
                t_4_2=t_4_3)
              and 
              (
                throw_4=throw_5)
              and 
              (
                var_3_ws_1_3=var_3_ws_1_4)
            )
          )
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                            throw_3,
                                                            var_3_ws_1_2]
            )
          )
          and 
          TruePred[]
          and 
          (
            var_1_currentRef_2=var_1_currentRef_4)
          and 
          (
            var_2_prevRef_2=var_2_prevRef_4)
          and 
          (
            t_5_1=t_5_3)
          and 
          (
            t_6_1=t_6_3)
          and 
          (
            t_4_1=t_4_3)
          and 
          (
            throw_3=throw_5)
          and 
          (
            var_3_ws_1_2=var_3_ws_1_4)
        )
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                        throw_2,
                                                        var_3_ws_1_1]
        )
      )
      and 
      TruePred[]
      and 
      (
        var_1_currentRef_1=var_1_currentRef_4)
      and 
      (
        var_2_prevRef_1=var_2_prevRef_4)
      and 
      (
        t_5_0=t_5_3)
      and 
      (
        t_6_0=t_6_3)
      and 
      (
        t_4_0=t_4_3)
      and 
      (
        throw_2=throw_5)
      and 
      (
        var_3_ws_1_1=var_3_ws_1_4)
    )
  )
  and 
  (
    not (
      SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                    throw_5,
                                                    var_3_ws_1_4]
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_5]
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition15[newNode_0,
                                                        var_1_currentRef_4]
          and 
          (
            throw_6=java_lang_NullPointerExceptionLit)
          and 
          (
            SinglyLinkedListNodeInt_next_0=SinglyLinkedListNodeInt_next_1)
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition15[newNode_0,
                                                            var_1_currentRef_4]
            )
          )
          and 
          (
            SinglyLinkedListNodeInt_next_1=(SinglyLinkedListNodeInt_next_0)++((newNode_0)->(var_1_currentRef_4.SinglyLinkedListNodeInt_next_0))) // buggy line
          and 
          (
            throw_5=throw_6)
        )
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_5]
        )
      )
      and 
      TruePred[]
      and 
      (
        SinglyLinkedListNodeInt_next_0=SinglyLinkedListNodeInt_next_1)
      and 
      (
        throw_5=throw_6)
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_6]
      and 
      (
        t_7_1=(equ[var_2_prevRef_4,
           null]=>(true)else(false))
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_6]
        )
      )
      and 
      TruePred[]
      and 
      (
        t_7_0=t_7_1)
    )
  )
  and 
  (
    (
      SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                   throw_6]
      and 
      (
        (
          SinglyLinkedListIntSortedInsert1BugCondition19[t_7_1]
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_6]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0]
                  and 
                  (
                    throw_7=java_lang_NullPointerExceptionLit)
                  and 
                  (
                    SinglyLinkedListIntSortedInsert1Bug_header_0=SinglyLinkedListIntSortedInsert1Bug_header_1)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0])
                  )
                  and 
                  (
                    SinglyLinkedListIntSortedInsert1Bug_header_1=(SinglyLinkedListIntSortedInsert1Bug_header_0)++((thiz_0)->(param_newNode_0_1)))
                  and 
                  (
                    throw_6=throw_7)
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_6]
                )
              )
              and 
              TruePred[]
              and 
              (
                SinglyLinkedListIntSortedInsert1Bug_header_0=SinglyLinkedListIntSortedInsert1Bug_header_1)
              and 
              (
                throw_6=throw_7)
            )
          )
          and 
          (
            SinglyLinkedListNodeInt_next_1=SinglyLinkedListNodeInt_next_2)
        )
        or 
        (
          (
            not (
              SinglyLinkedListIntSortedInsert1BugCondition19[t_7_1])
          )
          and 
          (
            (
              SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                           throw_6]
              and 
              (
                (
                  SinglyLinkedListIntSortedInsert1BugCondition17[var_2_prevRef_4]
                  and 
                  (
                    throw_7=java_lang_NullPointerExceptionLit)
                  and 
                  (
                    SinglyLinkedListNodeInt_next_1=SinglyLinkedListNodeInt_next_2)
                )
                or 
                (
                  (
                    not (
                      SinglyLinkedListIntSortedInsert1BugCondition17[var_2_prevRef_4])
                  )
                  and 
                  (
                    SinglyLinkedListNodeInt_next_2=(SinglyLinkedListNodeInt_next_1)++((var_2_prevRef_4)->(param_newNode_0_1)))
                  and 
                  (
                    throw_6=throw_7)
                )
              )
            )
            or 
            (
              (
                not (
                  SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                               throw_6]
                )
              )
              and 
              TruePred[]
              and 
              (
                SinglyLinkedListNodeInt_next_1=SinglyLinkedListNodeInt_next_2)
              and 
              (
                throw_6=throw_7)
            )
          )
          and 
          (
            SinglyLinkedListIntSortedInsert1Bug_header_0=SinglyLinkedListIntSortedInsert1Bug_header_1)
        )
      )
    )
    or 
    (
      (
        not (
          SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                       throw_6]
        )
      )
      and 
      TruePred[]
      and 
      (
        SinglyLinkedListNodeInt_next_1=SinglyLinkedListNodeInt_next_2)
      and 
      (
        SinglyLinkedListIntSortedInsert1Bug_header_0=SinglyLinkedListIntSortedInsert1Bug_header_1)
      and 
      (
        throw_6=throw_7)
    )
  )
  and 
  TruePred[]

}

one sig QF {
  SinglyLinkedListIntSortedInsert1Bug_header_0: ( SinglyLinkedListIntSortedInsert1Bug ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListIntSortedInsert1Bug_header_1: ( SinglyLinkedListIntSortedInsert1Bug ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_0: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_1: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_next_2: ( SinglyLinkedListNodeInt ) -> one ( SinglyLinkedListNodeInt + null ),
  SinglyLinkedListNodeInt_value_0: ( SinglyLinkedListNodeInt ) -> one ( Int ),
  l0_exit_stmt_reached_1: boolean,
  l0_param_newNode_0_0: SinglyLinkedListNodeInt + null,
  l0_param_newNode_0_1: SinglyLinkedListNodeInt + null,
  l0_t_1_0: boolean,
  l0_t_1_1: boolean,
  l0_t_2_0: boolean,
  l0_t_2_1: boolean,
  l0_t_3_0: boolean,
  l0_t_3_1: boolean,
  l0_t_4_0: boolean,
  l0_t_4_1: boolean,
  l0_t_4_2: boolean,
  l0_t_4_3: boolean,
  l0_t_5_0: boolean,
  l0_t_5_1: boolean,
  l0_t_5_2: boolean,
  l0_t_5_3: boolean,
  l0_t_6_0: boolean,
  l0_t_6_1: boolean,
  l0_t_6_2: boolean,
  l0_t_6_3: boolean,
  l0_t_7_0: boolean,
  l0_t_7_1: boolean,
  l0_var_1_currentRef_0: SinglyLinkedListNodeInt + null,
  l0_var_1_currentRef_1: SinglyLinkedListNodeInt + null,
  l0_var_1_currentRef_2: SinglyLinkedListNodeInt + null,
  l0_var_1_currentRef_3: SinglyLinkedListNodeInt + null,
  l0_var_1_currentRef_4: SinglyLinkedListNodeInt + null,
  l0_var_2_prevRef_0: SinglyLinkedListNodeInt + null,
  l0_var_2_prevRef_1: SinglyLinkedListNodeInt + null,
  l0_var_2_prevRef_2: SinglyLinkedListNodeInt + null,
  l0_var_2_prevRef_3: SinglyLinkedListNodeInt + null,
  l0_var_2_prevRef_4: SinglyLinkedListNodeInt + null,
  l0_var_3_ws_1_0: boolean,
  l0_var_3_ws_1_1: boolean,
  l0_var_3_ws_1_2: boolean,
  l0_var_3_ws_1_3: boolean,
  l0_var_3_ws_1_4: boolean,
  newNode_0: SinglyLinkedListNodeInt + null,
  thiz_0: SinglyLinkedListIntSortedInsert1Bug,
  throw_0: java_lang_Throwable + null,
  throw_1: java_lang_Throwable + null,
  throw_2: java_lang_Throwable + null,
  throw_3: java_lang_Throwable + null,
  throw_4: java_lang_Throwable + null,
  throw_5: java_lang_Throwable + null,
  throw_6: java_lang_Throwable + null,
  throw_7: java_lang_Throwable + null
}


fact {
  precondition_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                 QF.SinglyLinkedListNodeInt_next_0,
                                                                 QF.SinglyLinkedListNodeInt_value_0,
                                                                 QF.newNode_0,
                                                                 QF.thiz_0,
                                                                 QF.throw_0]

}

fact {
  SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.thiz_0,
                                                    QF.throw_1,
                                                    QF.throw_2,
                                                    QF.throw_3,
                                                    QF.throw_4,
                                                    QF.throw_5,
                                                    QF.throw_6,
                                                    QF.throw_7,
                                                    QF.newNode_0,
                                                    QF.SinglyLinkedListNodeInt_value_0,
                                                    QF.SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                    QF.SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                    QF.SinglyLinkedListNodeInt_next_0,
                                                    QF.SinglyLinkedListNodeInt_next_1,
                                                    QF.SinglyLinkedListNodeInt_next_2,
                                                    QF.l0_t_2_0,
                                                    QF.l0_t_2_1,
                                                    QF.l0_t_3_0,
                                                    QF.l0_t_3_1,
                                                    QF.l0_exit_stmt_reached_1,
                                                    QF.l0_t_1_0,
                                                    QF.l0_t_1_1,
                                                    QF.l0_var_2_prevRef_0,
                                                    QF.l0_var_2_prevRef_1,
                                                    QF.l0_var_2_prevRef_2,
                                                    QF.l0_var_2_prevRef_3,
                                                    QF.l0_var_2_prevRef_4,
                                                    QF.l0_var_1_currentRef_0,
                                                    QF.l0_var_1_currentRef_1,
                                                    QF.l0_var_1_currentRef_2,
                                                    QF.l0_var_1_currentRef_3,
                                                    QF.l0_var_1_currentRef_4,
                                                    QF.l0_t_6_0,
                                                    QF.l0_t_6_1,
                                                    QF.l0_t_6_2,
                                                    QF.l0_t_6_3,
                                                    QF.l0_var_3_ws_1_0,
                                                    QF.l0_var_3_ws_1_1,
                                                    QF.l0_var_3_ws_1_2,
                                                    QF.l0_var_3_ws_1_3,
                                                    QF.l0_var_3_ws_1_4,
                                                    QF.l0_t_7_0,
                                                    QF.l0_t_7_1,
                                                    QF.l0_t_4_0,
                                                    QF.l0_t_4_1,
                                                    QF.l0_t_4_2,
                                                    QF.l0_t_4_3,
                                                    QF.l0_param_newNode_0_0,
                                                    QF.l0_param_newNode_0_1,
                                                    QF.l0_t_5_0,
                                                    QF.l0_t_5_1,
                                                    QF.l0_t_5_2,
                                                    QF.l0_t_5_3]

}

assert repair_assert_0{
  postcondition_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                  QF.SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                                  QF.SinglyLinkedListNodeInt_next_0,
                                                                  QF.SinglyLinkedListNodeInt_next_2,
                                                                  QF.SinglyLinkedListNodeInt_value_0,
                                                                  QF.SinglyLinkedListNodeInt_value_0,
                                                                  QF.newNode_0,
                                                                  QF.thiz_0,
                                                                  QF.thiz_0,
                                                                  QF.throw_7]
}

pred repair_pred_0{
  postcondition_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                  QF.SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                                  QF.SinglyLinkedListNodeInt_next_0,
                                                                  QF.SinglyLinkedListNodeInt_next_2,
                                                                  QF.SinglyLinkedListNodeInt_value_0,
                                                                  QF.SinglyLinkedListNodeInt_value_0,
                                                                  QF.newNode_0,
                                                                  QF.thiz_0,
                                                                  QF.thiz_0,
                                                                  QF.throw_7]
}