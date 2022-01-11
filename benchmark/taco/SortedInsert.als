/*
 * DynAlloy translator options
 * ---------------------------
 * assertionId= check_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0
 * loopUnroll= 4
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

//-------------- java_lang_Exception--------------//
abstract sig java_lang_Exception extends java_lang_Throwable {}
{}



one
sig java_lang_ExceptionLit extends java_lang_Exception {}
{}

//-------------- java_lang_Throwable--------------//
abstract sig java_lang_Throwable extends java_lang_Object {}
{}



one
sig java_lang_ThrowableLit extends java_lang_Throwable {}
{}

//-------------- java_lang_Object--------------//
abstract sig java_lang_Object {}
{}




//-------------- realbugs_SinglyLinkedListNodeInt--------------//
sig realbugs_SinglyLinkedListNodeInt extends java_lang_Object {}
{}




//-------------- java_lang_NullPointerException--------------//
abstract one sig java_lang_NullPointerException extends java_lang_RuntimeException {}
{}



one
sig java_lang_NullPointerExceptionLit extends java_lang_NullPointerException {}
{}

//-------------- java_io_PrintStream--------------//
sig java_io_PrintStream extends java_lang_Object {}
{}




//-------------- java_lang_Boolean--------------//
sig java_lang_Boolean extends java_lang_Object {}
{}




//-------------- realbugs_SinglyLinkedListIntSortedInsert1Bug--------------//
sig realbugs_SinglyLinkedListIntSortedInsert1Bug extends java_lang_Object {}
{}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition17[
  var_2_prevRef:univ
]{
   isEmptyOrNull[var_2_prevRef]

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition18[
  var_2_prevRef:univ
]{
   not (
     isEmptyOrNull[var_2_prevRef])

}
pred realbugs_SinglyLinkedListIntSortedInsert1Bug_object_invariant[
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  realbugs_SinglyLinkedListNodeInt_next:univ->univ,
  thiz:univ
]{
   all n:null+realbugs_SinglyLinkedListNodeInt | {
     liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListIntSortedInsert1Bug_header,realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next],n]]
     implies
             equ[fun_set_contains[fun_reach[n.realbugs_SinglyLinkedListNodeInt_next,realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next],n],
                false]

   }

}
pred realbugs_SinglyLinkedListIntSortedInsert1Bug_requires[
  newNode:univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  realbugs_SinglyLinkedListNodeInt_next:univ->univ,
  realbugs_SinglyLinkedListNodeInt_value:univ->univ,
  thiz:univ
]{
   neq[newNode,
      null]
   and
   (
     all n:null+realbugs_SinglyLinkedListNodeInt | {
       liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListIntSortedInsert1Bug_header,realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next],n]]
       implies
               neq[n,
                  newNode]

     }
   )
   and
   (
     all n:null+realbugs_SinglyLinkedListNodeInt | {
       (
         (
           fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListIntSortedInsert1Bug_header,realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next],n]=true)
         and
         neq[n.realbugs_SinglyLinkedListNodeInt_next,
            null]
       )
       implies
               lte[n.realbugs_SinglyLinkedListNodeInt_value,
                  (n.realbugs_SinglyLinkedListNodeInt_next).realbugs_SinglyLinkedListNodeInt_value]

     }
   )

}
pred precondition_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  newNode:univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  realbugs_SinglyLinkedListNodeInt_next:univ->univ,
  realbugs_SinglyLinkedListNodeInt_value:univ->univ,
  thiz:univ,
  throw:univ
]{
   equ[throw,
      null]
   and
   realbugs_SinglyLinkedListIntSortedInsert1Bug_requires[newNode,
                                                        realbugs_SinglyLinkedListIntSortedInsert1Bug_header,
                                                        realbugs_SinglyLinkedListNodeInt_next,
                                                        realbugs_SinglyLinkedListNodeInt_value,
                                                        thiz]
   and
   realbugs_SinglyLinkedListIntSortedInsert1Bug_object_invariant[realbugs_SinglyLinkedListIntSortedInsert1Bug_header,
                                                                realbugs_SinglyLinkedListNodeInt_next,
                                                                thiz]

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition7[
  t_2:univ
]{
   not (
     t_2=true)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition4[
  t_3:univ
]{
   t_3=true

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[
  t_6:univ
]{
   t_6=true

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition6[
  t_2:univ
]{
   t_2=true

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[
  exit_stmt_reached:univ,
  throw:univ
]{
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition5[
  t_3:univ
]{
   not (
     t_3=true)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition11[
  t_6:univ
]{
   not (
     t_6=true)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition13[
  t_5:univ
]{
   not (
     t_5=true)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[
  t_5:univ
]{
   t_5=true

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition19[
  t_7:univ
]{
   t_7=true

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition1[
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
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition16[
  newNode:univ,
  var_1_currentRef:univ
]{
   not (
     isEmptyOrNull[newNode]
     or
     isEmptyOrNull[var_1_currentRef]
   )

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition15[
  newNode:univ,
  var_1_currentRef:univ
]{
   isEmptyOrNull[newNode]
   or
   isEmptyOrNull[var_1_currentRef]

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition9[
  var_1_currentRef:univ
]{
   not (
     isEmptyOrNull[var_1_currentRef])

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[
  var_1_currentRef:univ
]{
   isEmptyOrNull[var_1_currentRef]

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition20[
  t_7:univ
]{
   not (
     t_7=true)

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition3[
  thiz:univ
]{
   not (
     isEmptyOrNull[thiz])

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition2[
  thiz:univ
]{
   isEmptyOrNull[thiz]

}
pred realbugs_SinglyLinkedListIntSortedInsert1Bug_ensures[
  newNode':univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header':univ->univ,
  realbugs_SinglyLinkedListNodeInt_next:univ->univ,
  realbugs_SinglyLinkedListNodeInt_next':univ->univ,
  realbugs_SinglyLinkedListNodeInt_value:univ->univ,
  realbugs_SinglyLinkedListNodeInt_value':univ->univ,
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
             liftExpression[fun_set_contains[fun_reach[thiz'.realbugs_SinglyLinkedListIntSortedInsert1Bug_header',realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next'],newNode']]
   )
   and
   (
     (
       throw'=null)
     implies
             (
               all n:null+realbugs_SinglyLinkedListNodeInt | {
                 liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListIntSortedInsert1Bug_header,realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next],n]]
                 implies
                         (
                           (
                             fun_set_contains[fun_reach[thiz'.realbugs_SinglyLinkedListIntSortedInsert1Bug_header',realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next'],n]=true)
                           and
                           equ[n.realbugs_SinglyLinkedListNodeInt_value,
                              n.realbugs_SinglyLinkedListNodeInt_value']
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
               all n:null+realbugs_SinglyLinkedListNodeInt | {
                 (
                   (
                     fun_set_contains[fun_reach[thiz'.realbugs_SinglyLinkedListIntSortedInsert1Bug_header',realbugs_SinglyLinkedListNodeInt,realbugs_SinglyLinkedListNodeInt_next'],n]=true)
                   and
                   neq[n.realbugs_SinglyLinkedListNodeInt_next',
                      null]
                 )
                 implies
                         lte[n.realbugs_SinglyLinkedListNodeInt_value',
                            (n.realbugs_SinglyLinkedListNodeInt_next').realbugs_SinglyLinkedListNodeInt_value']

               }
             )
   )

}
pred postcondition_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  newNode':univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header:univ->univ,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header':univ->univ,
  realbugs_SinglyLinkedListNodeInt_next:univ->univ,
  realbugs_SinglyLinkedListNodeInt_next':univ->univ,
  realbugs_SinglyLinkedListNodeInt_value:univ->univ,
  realbugs_SinglyLinkedListNodeInt_value':univ->univ,
  thiz:univ,
  thiz':univ,
  throw':univ
]{
   realbugs_SinglyLinkedListIntSortedInsert1Bug_ensures[newNode',
                                                       realbugs_SinglyLinkedListIntSortedInsert1Bug_header,
                                                       realbugs_SinglyLinkedListIntSortedInsert1Bug_header',
                                                       realbugs_SinglyLinkedListNodeInt_next,
                                                       realbugs_SinglyLinkedListNodeInt_next',
                                                       realbugs_SinglyLinkedListNodeInt_value,
                                                       realbugs_SinglyLinkedListNodeInt_value',
                                                       thiz,
                                                       thiz',
                                                       throw']
   and
   (
     not (
       throw'=AssertionFailureLit)
   )
   and
   realbugs_SinglyLinkedListIntSortedInsert1Bug_object_invariant[realbugs_SinglyLinkedListIntSortedInsert1Bug_header',
                                                                realbugs_SinglyLinkedListNodeInt_next',
                                                                thiz']

}
pred realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[
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



pred havocVariable2[
  u_1:univ -> univ
]{
  TruePred[]
  and
  havocVariable2Post[u_1]
}


pred updateField[
  l_0:univ,
  f_0:univ -> univ,
  f_1:univ -> univ,
  r_0:univ
]{
  TruePred[]
  and
  updateFieldPost[f_1,
                 f_0,
                 l_0,
                 r_0]
}


pred havocVariable3[
  u_1:univ -> ( seq univ )
]{
  TruePred[]
  and
  havocVariable3Post[u_1]
}


pred havocListSeq[
  target_0:univ,
  field_0:univ -> Int -> univ,
  field_1:univ -> Int -> univ
]{
  TruePred[]
  and
  havocListSeqPost[target_0,
                  field_0,
                  field_1]
}


pred getUnusedObject[
  n_1:java_lang_Object + null,
  usedObjects_0:set java_lang_Object,
  usedObjects_1:set java_lang_Object
]{
  TruePred[]
  and
  getUnusedObjectPost[usedObjects_1,
                     usedObjects_0,
                     n_1]
}


pred updateVariable[
  l_1:univ,
  r_0:univ
]{
  TruePred[]
  and
  equ[l_1,
     r_0]
}


pred havocFieldContents[
  target_0:univ,
  field_0:univ -> univ,
  field_1:univ -> univ
]{
  TruePred[]
  and
  havocFieldContentsPost[target_0,
                        field_0,
                        field_1]
}


pred havocVariable[
  v_1:univ
]{
  TruePred[]
  and
  havocVarPost[v_1]
}


pred havocField[
  f_0:univ -> univ,
  f_1:univ -> univ,
  u_0:univ
]{
  TruePred[]
  and
  havocFieldPost[f_0,
                f_1,
                u_0]
}


pred realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[
  thiz_0:realbugs_SinglyLinkedListIntSortedInsert1Bug,
  throw_1:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  throw_3:java_lang_Throwable + null,
  throw_4:java_lang_Throwable + null,
  throw_5:java_lang_Throwable + null,
  throw_6:java_lang_Throwable + null,
  throw_7:java_lang_Throwable + null,
  throw_8:java_lang_Throwable + null,
  newNode_0:null + realbugs_SinglyLinkedListNodeInt,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0:( realbugs_SinglyLinkedListIntSortedInsert1Bug ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1:( realbugs_SinglyLinkedListIntSortedInsert1Bug ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_next_0:( realbugs_SinglyLinkedListNodeInt ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_next_1:( realbugs_SinglyLinkedListNodeInt ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_next_2:( realbugs_SinglyLinkedListNodeInt ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_value_0:( realbugs_SinglyLinkedListNodeInt ) -> one ( Int ),
  t_2_0:boolean,
  t_2_1:boolean,
  t_3_0:boolean,
  t_3_1:boolean,
  exit_stmt_reached_1:boolean,
  t_1_0:boolean,
  t_1_1:boolean,
  var_2_prevRef_0:null + realbugs_SinglyLinkedListNodeInt,
  var_2_prevRef_1:null + realbugs_SinglyLinkedListNodeInt,
  var_2_prevRef_2:null + realbugs_SinglyLinkedListNodeInt,
  var_2_prevRef_3:null + realbugs_SinglyLinkedListNodeInt,
  var_2_prevRef_4:null + realbugs_SinglyLinkedListNodeInt,
  var_2_prevRef_5:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_0:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_1:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_2:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_3:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_4:null + realbugs_SinglyLinkedListNodeInt,
  var_1_currentRef_5:null + realbugs_SinglyLinkedListNodeInt,
  t_6_0:boolean,
  t_6_1:boolean,
  t_6_2:boolean,
  t_6_3:boolean,
  t_6_4:boolean,
  var_3_ws_1_0:boolean,
  var_3_ws_1_1:boolean,
  var_3_ws_1_2:boolean,
  var_3_ws_1_3:boolean,
  var_3_ws_1_4:boolean,
  var_3_ws_1_5:boolean,
  t_7_0:boolean,
  t_7_1:boolean,
  t_4_0:boolean,
  t_4_1:boolean,
  t_4_2:boolean,
  t_4_3:boolean,
  t_4_4:boolean,
  param_newNode_0_0:null + realbugs_SinglyLinkedListNodeInt,
  param_newNode_0_1:null + realbugs_SinglyLinkedListNodeInt,
  t_5_0:boolean,
  t_5_1:boolean,
  t_5_2:boolean,
  t_5_3:boolean,
  t_5_4:boolean
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_1]
      and
      (
        param_newNode_0_1=newNode_0)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_1]
      and
      (
        (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0]
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0])
          )
          and
          (
            var_1_currentRef_1=thiz_0.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0)
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_2]
      and
      (
        var_2_prevRef_1=((null+realbugs_SinglyLinkedListNodeInt) & (null)))
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_2]
      and
      (
        (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition6[t_2_1]
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_2]
              and
              (
                t_3_1=(lt[var_1_currentRef_1.realbugs_SinglyLinkedListNodeInt_value_0,
                  newNode_0.realbugs_SinglyLinkedListNodeInt_value_0]=>(true)else(false))
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_2]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition4[t_3_1]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_2]
                      and
                      (
                        t_1_1=true)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition4[t_3_1])
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_2]
                      and
                      (
                        t_1_1=false)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition6[t_2_1])
          )
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_2]
              and
              (
                t_1_1=false)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_2]
      and
      (
        var_3_ws_1_1=t_1_1)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_2]
          and
          (
            var_2_prevRef_2=var_1_currentRef_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_2]
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_1]
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_1])
              )
              and
              (
                var_1_currentRef_2=var_1_currentRef_1.realbugs_SinglyLinkedListNodeInt_next_0)
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_3]
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_1]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_3]
                  and
                  (
                    t_6_1=(lt[var_1_currentRef_2.realbugs_SinglyLinkedListNodeInt_value_0,
                      newNode_0.realbugs_SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_3]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_1]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_3]
                          and
                          (
                            t_4_1=true)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_1])
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_3]
                          and
                          (
                            t_4_1=false)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_1])
              )
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_3]
                  and
                  (
                    t_4_1=false)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_3]
          and
          (
            var_3_ws_1_2=t_4_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_3]
              and
              (
                var_2_prevRef_3=var_1_currentRef_2)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_3]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_2]
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_2])
                  )
                  and
                  (
                    var_1_currentRef_3=var_1_currentRef_2.realbugs_SinglyLinkedListNodeInt_next_0)
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_4]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_2]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_4]
                      and
                      (
                        t_6_2=(lt[var_1_currentRef_3.realbugs_SinglyLinkedListNodeInt_value_0,
                          newNode_0.realbugs_SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_4]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_2]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                    throw_4]
                              and
                              (
                                t_4_2=true)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_2])
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                    throw_4]
                              and
                              (
                                t_4_2=false)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_2])
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_4]
                      and
                      (
                        t_4_2=false)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_4]
              and
              (
                var_3_ws_1_3=t_4_2)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_4]
                  and
                  (
                    var_2_prevRef_4=var_1_currentRef_3)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_4]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_3]
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_3])
                      )
                      and
                      (
                        var_1_currentRef_4=var_1_currentRef_3.realbugs_SinglyLinkedListNodeInt_next_0)
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_5]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_3]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_5]
                          and
                          (
                            t_6_3=(lt[var_1_currentRef_4.realbugs_SinglyLinkedListNodeInt_value_0,
                              newNode_0.realbugs_SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_5]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_3]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                        throw_5]
                                  and
                                  (
                                    t_4_3=true)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_3])
                              )
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                        throw_5]
                                  and
                                  (
                                    t_4_3=false)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_3])
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_5]
                          and
                          (
                            t_4_3=false)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_5]
                  and
                  (
                    var_3_ws_1_4=t_4_3)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
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
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                         throw_5,
                                                                         var_3_ws_1_4]
                  and
                  TruePred[]
                  and
                  TruePred[]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_5]
                      and
                      (
                        var_2_prevRef_5=var_1_currentRef_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_5]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_2_prevRef_4=var_2_prevRef_5)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_5]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_4]
                          and
                          (
                            throw_6=java_lang_NullPointerExceptionLit)
                          and
                          (
                            var_1_currentRef_4=var_1_currentRef_5)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition8[var_1_currentRef_4])
                          )
                          and
                          (
                            var_1_currentRef_5=var_1_currentRef_4.realbugs_SinglyLinkedListNodeInt_next_0)
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
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_5]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_1_currentRef_4=var_1_currentRef_5)
                      and
                      (
                        throw_5=throw_6)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_6]
                      and
                      (
                        t_5_4=(neq[var_1_currentRef_5,
                           null]=>(true)else(false))
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_6]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_5_3=t_5_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_6]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_4]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                    throw_6]
                              and
                              (
                                t_6_4=(lt[var_1_currentRef_5.realbugs_SinglyLinkedListNodeInt_value_0,
                                  newNode_0.realbugs_SinglyLinkedListNodeInt_value_0]=>(true)else(false))
                              )
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                        throw_6]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                t_6_3=t_6_4)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                    throw_6]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_4]
                                  and
                                  (
                                    (
                                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                            throw_6]
                                      and
                                      (
                                        t_4_4=true)
                                    )
                                    or
                                    (
                                      (
                                        not (
                                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                                throw_6]
                                        )
                                      )
                                      and
                                      TruePred[]
                                      and
                                      (
                                        t_4_3=t_4_4)
                                    )
                                  )
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition10[t_6_4])
                                  )
                                  and
                                  (
                                    (
                                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                            throw_6]
                                      and
                                      (
                                        t_4_4=false)
                                    )
                                    or
                                    (
                                      (
                                        not (
                                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                                throw_6]
                                        )
                                      )
                                      and
                                      TruePred[]
                                      and
                                      (
                                        t_4_3=t_4_4)
                                    )
                                  )
                                )
                              )
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                        throw_6]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                t_4_3=t_4_4)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition12[t_5_4])
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                    throw_6]
                              and
                              (
                                t_4_4=false)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                        throw_6]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                t_4_3=t_4_4)
                            )
                          )
                          and
                          (
                            t_6_3=t_6_4)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_6]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_6_3=t_6_4)
                      and
                      (
                        t_4_3=t_4_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                            throw_6]
                      and
                      (
                        var_3_ws_1_5=t_4_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                                throw_6]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_3_ws_1_4=var_3_ws_1_5)
                    )
                  )
                  and
                  TruePred[]
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                             throw_5,
                                                                             var_3_ws_1_4]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_1_currentRef_4=var_1_currentRef_5)
                  and
                  (
                    var_2_prevRef_4=var_2_prevRef_5)
                  and
                  (
                    t_5_3=t_5_4)
                  and
                  (
                    t_6_3=t_6_4)
                  and
                  (
                    t_4_3=t_4_4)
                  and
                  (
                    throw_5=throw_6)
                  and
                  (
                    var_3_ws_1_4=var_3_ws_1_5)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                         throw_4,
                                                                         var_3_ws_1_3]
                )
              )
              and
              TruePred[]
              and
              (
                var_1_currentRef_3=var_1_currentRef_5)
              and
              (
                var_2_prevRef_3=var_2_prevRef_5)
              and
              (
                t_5_2=t_5_4)
              and
              (
                t_6_2=t_6_4)
              and
              (
                t_4_2=t_4_4)
              and
              (
                throw_4=throw_6)
              and
              (
                var_3_ws_1_3=var_3_ws_1_5)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                     throw_3,
                                                                     var_3_ws_1_2]
            )
          )
          and
          TruePred[]
          and
          (
            var_1_currentRef_2=var_1_currentRef_5)
          and
          (
            var_2_prevRef_2=var_2_prevRef_5)
          and
          (
            t_5_1=t_5_4)
          and
          (
            t_6_1=t_6_4)
          and
          (
            t_4_1=t_4_4)
          and
          (
            throw_3=throw_6)
          and
          (
            var_3_ws_1_2=var_3_ws_1_5)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                                 throw_2,
                                                                 var_3_ws_1_1]
        )
      )
      and
      TruePred[]
      and
      (
        var_1_currentRef_1=var_1_currentRef_5)
      and
      (
        var_2_prevRef_1=var_2_prevRef_5)
      and
      (
        t_5_0=t_5_4)
      and
      (
        t_6_0=t_6_4)
      and
      (
        t_4_0=t_4_4)
      and
      (
        throw_2=throw_6)
      and
      (
        var_3_ws_1_1=var_3_ws_1_5)
    )
  )
  and
  (
    not (
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition14[exit_stmt_reached_1,
                                                             throw_6,
                                                             var_3_ws_1_5]
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_6]
      and
      (
        (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition15[newNode_0,
                                                                 var_1_currentRef_5]
          and
          (
            throw_7=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNodeInt_next_0=realbugs_SinglyLinkedListNodeInt_next_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition15[newNode_0,
                                                                     var_1_currentRef_5]
            )
          )
          and
          (
            realbugs_SinglyLinkedListNodeInt_next_1=(realbugs_SinglyLinkedListNodeInt_next_0)++((newNode_0)->(var_1_currentRef_5.realbugs_SinglyLinkedListNodeInt_next_0))) // Bug is here
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
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_6]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNodeInt_next_0=realbugs_SinglyLinkedListNodeInt_next_1)
      and
      (
        throw_6=throw_7)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_7]
      and
      (
        t_7_1=(equ[var_2_prevRef_5,
           null]=>(true)else(false))
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_7]
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
      realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                            throw_7]
      and
      (
        (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition19[t_7_1]
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_7]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0]
                  and
                  (
                    throw_8=java_lang_NullPointerExceptionLit)
                  and
                  (
                    realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0=realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition2[thiz_0])
                  )
                  and
                  (
                    realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1=(realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0)++((thiz_0)->(param_newNode_0_1)))
                  and
                  (
                    throw_7=throw_8)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_7]
                )
              )
              and
              TruePred[]
              and
              (
                realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0=realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1)
              and
              (
                throw_7=throw_8)
            )
          )
          and
          (
            realbugs_SinglyLinkedListNodeInt_next_1=realbugs_SinglyLinkedListNodeInt_next_2)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition19[t_7_1])
          )
          and
          (
            (
              realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                    throw_7]
              and
              (
                (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition17[var_2_prevRef_5]
                  and
                  (
                    throw_8=java_lang_NullPointerExceptionLit)
                  and
                  (
                    realbugs_SinglyLinkedListNodeInt_next_1=realbugs_SinglyLinkedListNodeInt_next_2)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListIntSortedInsert1BugCondition17[var_2_prevRef_5])
                  )
                  and
                  (
                    realbugs_SinglyLinkedListNodeInt_next_2=(realbugs_SinglyLinkedListNodeInt_next_1)++((var_2_prevRef_5)->(param_newNode_0_1)))
                  and
                  (
                    throw_7=throw_8)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                        throw_7]
                )
              )
              and
              TruePred[]
              and
              (
                realbugs_SinglyLinkedListNodeInt_next_1=realbugs_SinglyLinkedListNodeInt_next_2)
              and
              (
                throw_7=throw_8)
            )
          )
          and
          (
            realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0=realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListIntSortedInsert1BugCondition0[exit_stmt_reached_1,
                                                                throw_7]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0=realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1)
      and
      (
        realbugs_SinglyLinkedListNodeInt_next_1=realbugs_SinglyLinkedListNodeInt_next_2)
      and
      (
        throw_7=throw_8)
    )
  )
  and
  TruePred[]

}

//-------------SMB sigs-------------//
one sig realbugs_SinglyLinkedListIntSortedInsert1Bug_0 extends realbugs_SinglyLinkedListIntSortedInsert1Bug {}

one sig realbugs_SinglyLinkedListNodeInt_0, realbugs_SinglyLinkedListNodeInt_1, realbugs_SinglyLinkedListNodeInt_2, realbugs_SinglyLinkedListNodeInt_3 extends realbugs_SinglyLinkedListNodeInt {}

fact {
  no ( QF.frealbugs_SinglyLinkedListNodeInt_next_0.univ & QF.brealbugs_SinglyLinkedListNodeInt_next_0.univ ) and
  realbugs_SinglyLinkedListNodeInt = QF.frealbugs_SinglyLinkedListNodeInt_next_0.univ + QF.brealbugs_SinglyLinkedListNodeInt_next_0.univ
}
//-----SMB: local_ordering()-----//
fun next_realbugs_SinglyLinkedListIntSortedInsert1Bug [] : realbugs_SinglyLinkedListIntSortedInsert1Bug -> lone realbugs_SinglyLinkedListIntSortedInsert1Bug {
none -> none
}
fun min_realbugs_SinglyLinkedListIntSortedInsert1Bug [os: set realbugs_SinglyLinkedListIntSortedInsert1Bug] : lone realbugs_SinglyLinkedListIntSortedInsert1Bug {
  os - os.^(next_realbugs_SinglyLinkedListIntSortedInsert1Bug[])
}
fun prevs_realbugs_SinglyLinkedListIntSortedInsert1Bug[o : realbugs_SinglyLinkedListIntSortedInsert1Bug] : set realbugs_SinglyLinkedListIntSortedInsert1Bug {
  o.^(~next_realbugs_SinglyLinkedListIntSortedInsert1Bug[])
}
fun next_realbugs_SinglyLinkedListNodeInt [] : realbugs_SinglyLinkedListNodeInt -> lone realbugs_SinglyLinkedListNodeInt {
  realbugs_SinglyLinkedListNodeInt_0 -> realbugs_SinglyLinkedListNodeInt_1 +
  realbugs_SinglyLinkedListNodeInt_1 -> realbugs_SinglyLinkedListNodeInt_2 +
  realbugs_SinglyLinkedListNodeInt_2 -> realbugs_SinglyLinkedListNodeInt_3
}
fun min_realbugs_SinglyLinkedListNodeInt [os: set realbugs_SinglyLinkedListNodeInt] : lone realbugs_SinglyLinkedListNodeInt {
  os - os.^(next_realbugs_SinglyLinkedListNodeInt[])
}
fun prevs_realbugs_SinglyLinkedListNodeInt[o : realbugs_SinglyLinkedListNodeInt] : set realbugs_SinglyLinkedListNodeInt {
  o.^(~next_realbugs_SinglyLinkedListNodeInt[])
}
//-----SMB: global_ordering()-----//
fun globalNext[]: java_lang_Object -> lone java_lang_Object {
realbugs_SinglyLinkedListIntSortedInsert1Bug_0 -> realbugs_SinglyLinkedListNodeInt_0  +  realbugs_SinglyLinkedListNodeInt_0 -> realbugs_SinglyLinkedListNodeInt_1  +  realbugs_SinglyLinkedListNodeInt_1 -> realbugs_SinglyLinkedListNodeInt_2  +  realbugs_SinglyLinkedListNodeInt_2 -> realbugs_SinglyLinkedListNodeInt_3
}
fun globalMin[s : set java_lang_Object] : lone java_lang_Object {
s - s.^globalNext[]
}
//-----SMB: define_min_parent()-----//
fun minP_realbugs_SinglyLinkedListNodeInt [o : realbugs_SinglyLinkedListNodeInt] : java_lang_Object {
  globalMin[(QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0 + QF.frealbugs_SinglyLinkedListNodeInt_next_0).o]
}
//-----SMB: define_freach()-----//
fun FReach[] : set java_lang_Object {
(QF.thiz_0 + QF.newNode_0).*(QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0 + QF.realbugs_SinglyLinkedListNodeInt_value_0 + QF.frealbugs_SinglyLinkedListNodeInt_next_0) - null
}
//-----SMB: order_root_nodes()-----//
//-----SMB: root_is_minimum()-----//
fact {
((QF.thiz_0 != null) implies QF.thiz_0 = realbugs_SinglyLinkedListIntSortedInsert1Bug_0 )
}
//-----SMB: order_same_min_parent()-----//
//-----SMB: order_same_min_parent_type()-----//
fact {
 all disj o1, o2:realbugs_SinglyLinkedListNodeInt |
  let p1=minP_realbugs_SinglyLinkedListNodeInt[o1]|
  let p2=minP_realbugs_SinglyLinkedListNodeInt[o2]|
  (o1 + o2 in FReach[] and
  some p1 and some p2 and
  p1!=p2 and p1+p2 in realbugs_SinglyLinkedListNodeInt and p1 in prevs_realbugs_SinglyLinkedListNodeInt[p2] )
  implies o1 in prevs_realbugs_SinglyLinkedListNodeInt[o2]
}
//-----SMB: order_diff_min_parent_type()-----//
fact {
 all disj o1, o2:realbugs_SinglyLinkedListNodeInt |
  let p1=minP_realbugs_SinglyLinkedListNodeInt[o1]|
  let p2=minP_realbugs_SinglyLinkedListNodeInt[o2]|
  ( o1+o2 in FReach[] and
 some p1 and some p2 and
p1 in realbugs_SinglyLinkedListIntSortedInsert1Bug and p2 in realbugs_SinglyLinkedListNodeInt )
implies o1 in prevs_realbugs_SinglyLinkedListNodeInt[o2]
}
//-----SMB: avoid_holes()-----//
fact {
 all o : realbugs_SinglyLinkedListIntSortedInsert1Bug |
  o in FReach[] implies
   prevs_realbugs_SinglyLinkedListIntSortedInsert1Bug[o] in FReach[]
}
fact {
 all o : realbugs_SinglyLinkedListNodeInt |
  o in FReach[] implies
   prevs_realbugs_SinglyLinkedListNodeInt[o] in FReach[]
}
/*
holeType ordering:
==============
1) realbugs_SinglyLinkedListIntSortedInsert1Bug
2) realbugs_SinglyLinkedListNodeInt

root nodes ordering:
====================
1) thiz:realbugs_SinglyLinkedListIntSortedInsert1Bug
2) newNode:null+realbugs_SinglyLinkedListNodeInt

recursive field ordering:
=========================
1) realbugs_SinglyLinkedListNodeInt_next:(realbugs_SinglyLinkedListNodeInt)->one(null+realbugs_SinglyLinkedListNodeInt)

non-recursive field ordering:
=============================
1) realbugs_SinglyLinkedListIntSortedInsert1Bug_header:(realbugs_SinglyLinkedListIntSortedInsert1Bug)->one(null+realbugs_SinglyLinkedListNodeInt)
2) realbugs_SinglyLinkedListNodeInt_value:(realbugs_SinglyLinkedListNodeInt)->one(Int)
*/
one sig QF {
  brealbugs_SinglyLinkedListNodeInt_next_0:(realbugs_SinglyLinkedListNodeInt) -> lone((realbugs_SinglyLinkedListNodeInt)),
  frealbugs_SinglyLinkedListNodeInt_next_0:(realbugs_SinglyLinkedListNodeInt) -> lone((realbugs_SinglyLinkedListNodeInt + null)),
  l0_exit_stmt_reached_1:boolean,
  l0_param_newNode_0_0:null + realbugs_SinglyLinkedListNodeInt,
  l0_param_newNode_0_1:null + realbugs_SinglyLinkedListNodeInt,
  l0_t_1_0:boolean,
  l0_t_1_1:boolean,
  l0_t_2_0:boolean,
  l0_t_2_1:boolean,
  l0_t_3_0:boolean,
  l0_t_3_1:boolean,
  l0_t_4_0:boolean,
  l0_t_4_1:boolean,
  l0_t_4_2:boolean,
  l0_t_4_3:boolean,
  l0_t_4_4:boolean,
  l0_t_5_0:boolean,
  l0_t_5_1:boolean,
  l0_t_5_2:boolean,
  l0_t_5_3:boolean,
  l0_t_5_4:boolean,
  l0_t_6_0:boolean,
  l0_t_6_1:boolean,
  l0_t_6_2:boolean,
  l0_t_6_3:boolean,
  l0_t_6_4:boolean,
  l0_t_7_0:boolean,
  l0_t_7_1:boolean,
  l0_var_1_currentRef_0:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_1_currentRef_1:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_1_currentRef_2:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_1_currentRef_3:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_1_currentRef_4:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_1_currentRef_5:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_0:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_1:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_2:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_3:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_4:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_2_prevRef_5:null + realbugs_SinglyLinkedListNodeInt,
  l0_var_3_ws_1_0:boolean,
  l0_var_3_ws_1_1:boolean,
  l0_var_3_ws_1_2:boolean,
  l0_var_3_ws_1_3:boolean,
  l0_var_3_ws_1_4:boolean,
  l0_var_3_ws_1_5:boolean,
  newNode_0:null + realbugs_SinglyLinkedListNodeInt,
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0:( realbugs_SinglyLinkedListIntSortedInsert1Bug ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1:( realbugs_SinglyLinkedListIntSortedInsert1Bug ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_next_1:( realbugs_SinglyLinkedListNodeInt ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_next_2:( realbugs_SinglyLinkedListNodeInt ) -> one ( null + realbugs_SinglyLinkedListNodeInt ),
  realbugs_SinglyLinkedListNodeInt_value_0:( realbugs_SinglyLinkedListNodeInt ) -> one ( Int ),
  thiz_0:realbugs_SinglyLinkedListIntSortedInsert1Bug,
  throw_0:java_lang_Throwable + null,
  throw_1:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  throw_3:java_lang_Throwable + null,
  throw_4:java_lang_Throwable + null,
  throw_5:java_lang_Throwable + null,
  throw_6:java_lang_Throwable + null,
  throw_7:java_lang_Throwable + null,
  throw_8:java_lang_Throwable + null
}


fact {
  precondition_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.newNode_0,
                                                                          QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                          (QF.brealbugs_SinglyLinkedListNodeInt_next_0)+(QF.frealbugs_SinglyLinkedListNodeInt_next_0),
                                                                          QF.realbugs_SinglyLinkedListNodeInt_value_0,
                                                                          QF.thiz_0,
                                                                          QF.throw_0]

}

fact {
  realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.thiz_0,
                                                             QF.throw_1,
                                                             QF.throw_2,
                                                             QF.throw_3,
                                                             QF.throw_4,
                                                             QF.throw_5,
                                                             QF.throw_6,
                                                             QF.throw_7,
                                                             QF.throw_8,
                                                             QF.newNode_0,
                                                             QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                             QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                             (QF.brealbugs_SinglyLinkedListNodeInt_next_0)+(QF.frealbugs_SinglyLinkedListNodeInt_next_0),
                                                             QF.realbugs_SinglyLinkedListNodeInt_next_1,
                                                             QF.realbugs_SinglyLinkedListNodeInt_next_2,
                                                             QF.realbugs_SinglyLinkedListNodeInt_value_0,
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
                                                             QF.l0_var_2_prevRef_5,
                                                             QF.l0_var_1_currentRef_0,
                                                             QF.l0_var_1_currentRef_1,
                                                             QF.l0_var_1_currentRef_2,
                                                             QF.l0_var_1_currentRef_3,
                                                             QF.l0_var_1_currentRef_4,
                                                             QF.l0_var_1_currentRef_5,
                                                             QF.l0_t_6_0,
                                                             QF.l0_t_6_1,
                                                             QF.l0_t_6_2,
                                                             QF.l0_t_6_3,
                                                             QF.l0_t_6_4,
                                                             QF.l0_var_3_ws_1_0,
                                                             QF.l0_var_3_ws_1_1,
                                                             QF.l0_var_3_ws_1_2,
                                                             QF.l0_var_3_ws_1_3,
                                                             QF.l0_var_3_ws_1_4,
                                                             QF.l0_var_3_ws_1_5,
                                                             QF.l0_t_7_0,
                                                             QF.l0_t_7_1,
                                                             QF.l0_t_4_0,
                                                             QF.l0_t_4_1,
                                                             QF.l0_t_4_2,
                                                             QF.l0_t_4_3,
                                                             QF.l0_t_4_4,
                                                             QF.l0_param_newNode_0_0,
                                                             QF.l0_param_newNode_0_1,
                                                             QF.l0_t_5_0,
                                                             QF.l0_t_5_1,
                                                             QF.l0_t_5_2,
                                                             QF.l0_t_5_3,
                                                             QF.l0_t_5_4]

}

assert repair_assert_0{
  postcondition_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.newNode_0,
                                                                           QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                           QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                                           (QF.brealbugs_SinglyLinkedListNodeInt_next_0)+(QF.frealbugs_SinglyLinkedListNodeInt_next_0),
                                                                           QF.realbugs_SinglyLinkedListNodeInt_next_2,
                                                                           QF.realbugs_SinglyLinkedListNodeInt_value_0,
                                                                           QF.realbugs_SinglyLinkedListNodeInt_value_0,
                                                                           QF.thiz_0,
                                                                           QF.thiz_0,
                                                                           QF.throw_8]
}

check repair_assert_0  for 0 but  8 java_lang_Object, exactly 4 realbugs_SinglyLinkedListNodeInt, exactly 1 java_io_PrintStream, exactly 1 realbugs_SinglyLinkedListIntSortedInsert1Bug, exactly 2 java_lang_Boolean,4 int

pred repair_pred_0{
  postcondition_realbugs_SinglyLinkedListIntSortedInsert1Bug_sortedInsert_0[QF.newNode_0,
                                                                           QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_0,
                                                                           QF.realbugs_SinglyLinkedListIntSortedInsert1Bug_header_1,
                                                                           (QF.brealbugs_SinglyLinkedListNodeInt_next_0)+(QF.frealbugs_SinglyLinkedListNodeInt_next_0),
                                                                           QF.realbugs_SinglyLinkedListNodeInt_next_2,
                                                                           QF.realbugs_SinglyLinkedListNodeInt_value_0,
                                                                           QF.realbugs_SinglyLinkedListNodeInt_value_0,
                                                                           QF.thiz_0,
                                                                           QF.thiz_0,
                                                                           QF.throw_8]
}
run repair_pred_0  for 0 but  8 java_lang_Object, exactly 4 realbugs_SinglyLinkedListNodeInt, exactly 1 java_io_PrintStream, exactly 1 realbugs_SinglyLinkedListIntSortedInsert1Bug, exactly 2 java_lang_Boolean,4 int
