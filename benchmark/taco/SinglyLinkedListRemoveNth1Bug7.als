/*
 * DynAlloy translator options
 * ---------------------------
 * assertionId= check_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0
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




//-------------- realbugs_SinglyLinkedListNode--------------//
sig realbugs_SinglyLinkedListNode extends java_lang_Object {}
{}
pred realbugs_SinglyLinkedListNodeCondition0[
  thiz:univ
]{
   isEmptyOrNull[thiz]

}
pred realbugs_SinglyLinkedListNodeCondition3[
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
pred realbugs_SinglyLinkedListNodeCondition1[
  thiz:univ
]{
   not (
     isEmptyOrNull[thiz])

}
pred realbugs_SinglyLinkedListNodeCondition2[
  exit_stmt_reached:univ,
  throw:univ
]{
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
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




//-------------- realbugs_SinglyLinkedListRemoveNth1Bug7--------------//
sig realbugs_SinglyLinkedListRemoveNth1Bug7 extends java_lang_Object {}
{}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition2[
  t_27:univ
]{
   isEmptyOrNull[t_27]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition25[
]{
   not (
     true=true)

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[
  var_17_fast:univ
]{
   isEmptyOrNull[var_17_fast]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition24[
]{
   true=true

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition11[
  var_17_fast:univ
]{
   not (
     isEmptyOrNull[var_17_fast])

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition3[
  t_27:univ
]{
   not (
     isEmptyOrNull[t_27])

}
pred postcondition_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[
  n':univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_next':univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header:univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header':univ->univ,
  return':univ,
  thiz:univ,
  thiz':univ,
  throw':univ
]{
   realbugs_SinglyLinkedListRemoveNth1Bug7_ensures[realbugs_SinglyLinkedListNode_next,
                                                  realbugs_SinglyLinkedListNode_next',
                                                  realbugs_SinglyLinkedListRemoveNth1Bug7_header,
                                                  realbugs_SinglyLinkedListRemoveNth1Bug7_header',
                                                  return',
                                                  thiz,
                                                  thiz',
                                                  throw']
   and
   (
     not (
       throw'=AssertionFailureLit)
   )
   and
   realbugs_SinglyLinkedListRemoveNth1Bug7_object_invariant[n',
                                                           realbugs_SinglyLinkedListNode_next',
                                                           realbugs_SinglyLinkedListRemoveNth1Bug7_header',
                                                           thiz']

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[
  exit_stmt_reached:univ,
  throw:univ,
  var_19_ws_5:univ
]{
   liftExpression[var_19_ws_5]
   and
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred precondition_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[
  booleanValue:univ->univ,
  java_lang_Boolean_FALSE:univ->univ,
  java_lang_Boolean_TRUE:univ->univ,
  java_lang_System_out:univ->univ,
  n:univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_value:univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header:univ->univ,
  return:univ,
  thiz:univ,
  throw:univ,
  usedObjects:univ
]{
   realbugs_SinglyLinkedListRemoveNth1Bug7_requires[booleanValue,
                                                   java_lang_Boolean_FALSE,
                                                   java_lang_Boolean_TRUE,
                                                   java_lang_System_out,
                                                   n,
                                                   realbugs_SinglyLinkedListNode_next,
                                                   realbugs_SinglyLinkedListNode_value,
                                                   realbugs_SinglyLinkedListRemoveNth1Bug7_header,
                                                   return,
                                                   thiz,
                                                   usedObjects]
   and
   equ[throw,
      null]
   and
   realbugs_SinglyLinkedListRemoveNth1Bug7_object_invariant[n,
                                                           realbugs_SinglyLinkedListNode_next,
                                                           realbugs_SinglyLinkedListRemoveNth1Bug7_header,
                                                           thiz]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[
  exit_stmt_reached:univ,
  throw:univ,
  var_20_ws_6:univ
]{
   liftExpression[var_20_ws_6]
   and
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7_ensures[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_next':univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header:univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header':univ->univ,
  return':univ,
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
             liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListRemoveNth1Bug7_header,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next],return']]
   )
   and
   (
     (
       throw'=null)
     implies
             liftExpression[Not[fun_set_contains[fun_reach[thiz'.realbugs_SinglyLinkedListRemoveNth1Bug7_header',realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next'],return']]]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition13[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ,
  variant_4:univ
]{
   not (
   // changed
     gte[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
       variant_4]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7_object_invariant[
  n:univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header:univ->univ,
  thiz:univ
]{
   all n:null+realbugs_SinglyLinkedListNode | {
     liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListRemoveNth1Bug7_header,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next],n]]
     implies
             equ[fun_set_contains[fun_reach[n.realbugs_SinglyLinkedListNode_next,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next],n],
                false]

   }

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ,
  variant_4:univ
]{
   gte[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
      variant_4]
  //   fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]] >= variant_4

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition4[
  thiz:univ,
  var_16_slow:univ
]{
   isEmptyOrNull[var_16_slow]
   or
   isEmptyOrNull[thiz]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition18[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ,
  variant_5:univ
]{
   not (
     gte[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
        variant_5]
    //  fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]] >=
     //         variant_5
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition5[
  thiz:univ,
  var_16_slow:univ
]{
   not (
     isEmptyOrNull[var_16_slow]
     or
     isEmptyOrNull[thiz]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition23[
  thiz:univ,
  var_15_start:univ
]{
   not (
     isEmptyOrNull[thiz]
     or
     isEmptyOrNull[var_15_start]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition22[
  thiz:univ,
  var_15_start:univ
]{
   isEmptyOrNull[thiz]
   or
   isEmptyOrNull[var_15_start]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7_requires[
  booleanValue:univ->univ,
  java_lang_Boolean_FALSE:univ->univ,
  java_lang_Boolean_TRUE:univ->univ,
  java_lang_System_out:univ->univ,
  n:univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_value:univ->univ,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header:univ->univ,
  return:univ,
  thiz:univ,
  usedObjects:univ
]{
   gte[n,
     1]
   // n >= 1
   and
   lte[n,
      fun_set_size[fun_reach[thiz.realbugs_SinglyLinkedListRemoveNth1Bug7_header,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]]]
  // n <= fun_set_size[fun_reach[thiz.realbugs_SinglyLinkedListRemoveNth1Bug7_header,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]]
   and
   (
     usedObjects=fun_weak_reach[none+thiz+return+n+(ClassFields.java_lang_System_out)+(ClassFields.java_lang_Boolean_TRUE)+(ClassFields.java_lang_Boolean_FALSE),java_lang_Object,(none)->(none)+realbugs_SinglyLinkedListRemoveNth1Bug7_header+realbugs_SinglyLinkedListNode_next+realbugs_SinglyLinkedListNode_value+booleanValue])

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition20[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_16_slow:univ
]{
   isEmptyOrNull[var_16_slow]
   or
   isEmptyOrNull[var_16_slow.realbugs_SinglyLinkedListNode_next]

   or
   isEmptyOrNull[var_16_slow]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition9[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ
]{
   not (
     lt[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
       0]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[
  exit_stmt_reached:univ,
  throw:univ
]{
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ
]{
   lt[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
     0]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition21[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_16_slow:univ
]{
   not (
     isEmptyOrNull[var_16_slow]
     or
     isEmptyOrNull[var_16_slow.realbugs_SinglyLinkedListNode_next]

     or
     isEmptyOrNull[var_16_slow]
   )

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[
  throw:univ
]{
   isEmptyOrNull[throw]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition7[
  throw:univ
]{
   not (
     isEmptyOrNull[throw])

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition16[
  var_16_slow:univ
]{
   not (
     isEmptyOrNull[var_16_slow])

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_17_fast:univ,
  variant_5:univ
]{
   gte[fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
      variant_5]
   // fun_set_size[fun_reach[var_17_fast,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]] >=
   //       variant_5

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[
  var_16_slow:univ
]{
   isEmptyOrNull[var_16_slow]

}
pred realbugs_SinglyLinkedListRemoveNth1Bug7Condition1[
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


pred realbugs_SinglyLinkedListNode_SinglyLinkedListNode_0[
  thiz_0:realbugs_SinglyLinkedListNode,
  throw_1:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  throw_3:java_lang_Throwable + null,
  realbugs_SinglyLinkedListNode_value_0:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListNode_value_1:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListNode_next_0:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_1:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  exit_stmt_reached_1:boolean
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
  (
    (
      realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_1,
                                             throw_1]
      and
      (
        (
          realbugs_SinglyLinkedListNodeCondition0[thiz_0]
          and
          (
            throw_2=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNode_next_0=realbugs_SinglyLinkedListNode_next_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListNodeCondition0[thiz_0])
          )
          and
          (
            realbugs_SinglyLinkedListNode_next_1=(realbugs_SinglyLinkedListNode_next_0)++((thiz_0)->(((null+realbugs_SinglyLinkedListNode) & (null)))))
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
          realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_1,
                                                 throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNode_next_0=realbugs_SinglyLinkedListNode_next_1)
      and
      (
        throw_1=throw_2)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_1,
                                             throw_2]
      and
      (
        (
          realbugs_SinglyLinkedListNodeCondition0[thiz_0]
          and
          (
            throw_3=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNode_value_0=realbugs_SinglyLinkedListNode_value_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListNodeCondition0[thiz_0])
          )
          and
          (
            realbugs_SinglyLinkedListNode_value_1=(realbugs_SinglyLinkedListNode_value_0)++((thiz_0)->(((java_lang_Object+null) & (null)))))
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
          realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_1,
                                                 throw_2]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNode_value_0=realbugs_SinglyLinkedListNode_value_1)
      and
      (
        throw_2=throw_3)
    )
  )
  and
  TruePred[]

}



pred realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[
  thiz_0:realbugs_SinglyLinkedListRemoveNth1Bug7,
  throw_1:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  throw_3:java_lang_Throwable + null,
  throw_4:java_lang_Throwable + null,
  throw_5:java_lang_Throwable + null,
  throw_6:java_lang_Throwable + null,
  throw_7:java_lang_Throwable + null,
  throw_8:java_lang_Throwable + null,
  throw_9:java_lang_Throwable + null,
  throw_10:java_lang_Throwable + null,
  throw_11:java_lang_Throwable + null,
  throw_12:java_lang_Throwable + null,
  throw_13:java_lang_Throwable + null,
  throw_14:java_lang_Throwable + null,
  throw_15:java_lang_Throwable + null,
  throw_16:java_lang_Throwable + null,
  throw_17:java_lang_Throwable + null,
  throw_18:java_lang_Throwable + null,
  throw_19:java_lang_Throwable + null,
  throw_20:java_lang_Throwable + null,
  throw_21:java_lang_Throwable + null,
  throw_22:java_lang_Throwable + null,
  throw_23:java_lang_Throwable + null,
  throw_24:java_lang_Throwable + null,
  throw_25:java_lang_Throwable + null,
  throw_26:java_lang_Throwable + null,
  throw_27:java_lang_Throwable + null,
  throw_28:java_lang_Throwable + null,
  throw_29:java_lang_Throwable + null,
  throw_30:java_lang_Throwable + null,
  throw_31:java_lang_Throwable + null,
  throw_32:java_lang_Throwable + null,
  throw_33:java_lang_Throwable + null,
  throw_34:java_lang_Throwable + null,
  throw_35:java_lang_Throwable + null,
  throw_36:java_lang_Throwable + null,
  throw_37:java_lang_Throwable + null,
  throw_38:java_lang_Throwable + null,
  throw_39:java_lang_Throwable + null,
  throw_40:java_lang_Throwable + null,
  throw_41:java_lang_Throwable + null,
  throw_42:java_lang_Throwable + null,
  throw_43:java_lang_Throwable + null,
  throw_44:java_lang_Throwable + null,
  throw_45:java_lang_Throwable + null,
  throw_46:java_lang_Throwable + null,
  throw_47:java_lang_Throwable + null,
  throw_48:java_lang_Throwable + null,
  throw_49:java_lang_Throwable + null,
  throw_50:java_lang_Throwable + null,
  throw_51:java_lang_Throwable + null,
  throw_52:java_lang_Throwable + null,
  return_0:null + realbugs_SinglyLinkedListNode,
  return_1:null + realbugs_SinglyLinkedListNode,
  return_2:null + realbugs_SinglyLinkedListNode,
  n_0:Int,
  realbugs_SinglyLinkedListRemoveNth1Bug7_header_0:( realbugs_SinglyLinkedListRemoveNth1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListRemoveNth1Bug7_header_1:( realbugs_SinglyLinkedListRemoveNth1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_value_0:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListNode_value_1:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListNode_next_0:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_1:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_2:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_3:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  usedObjects_0:set ( java_lang_Object ),
  usedObjects_1:set ( java_lang_Object ),
  usedObjects_2:set ( java_lang_Object ),
  usedObjects_3:set ( java_lang_Object ),
  usedObjects_4:set ( java_lang_Object ),
  usedObjects_5:set ( java_lang_Object ),
  usedObjects_6:set ( java_lang_Object ),
  usedObjects_7:set ( java_lang_Object ),
  usedObjects_8:set ( java_lang_Object ),
  usedObjects_9:set ( java_lang_Object ),
  usedObjects_10:set ( java_lang_Object ),
  usedObjects_11:set ( java_lang_Object ),
  usedObjects_12:set ( java_lang_Object ),
  usedObjects_13:set ( java_lang_Object ),
  usedObjects_14:set ( java_lang_Object ),
  usedObjects_15:set ( java_lang_Object ),
  usedObjects_16:set ( java_lang_Object ),
  usedObjects_17:set ( java_lang_Object ),
  var_18_i_0:Int,
  var_18_i_1:Int,
  var_18_i_2:Int,
  var_18_i_3:Int,
  var_18_i_4:Int,
  var_18_i_5:Int,
  param_n_3_0:Int,
  param_n_3_1:Int,
  t_27_0:null + realbugs_SinglyLinkedListNode,
  t_27_1:null + realbugs_SinglyLinkedListNode,
  var_17_fast_0:null + realbugs_SinglyLinkedListNode,
  var_17_fast_1:null + realbugs_SinglyLinkedListNode,
  var_17_fast_2:null + realbugs_SinglyLinkedListNode,
  var_17_fast_3:null + realbugs_SinglyLinkedListNode,
  var_17_fast_4:null + realbugs_SinglyLinkedListNode,
  var_17_fast_5:null + realbugs_SinglyLinkedListNode,
  var_17_fast_6:null + realbugs_SinglyLinkedListNode,
  var_17_fast_7:null + realbugs_SinglyLinkedListNode,
  var_17_fast_8:null + realbugs_SinglyLinkedListNode,
  var_17_fast_9:null + realbugs_SinglyLinkedListNode,
  exit_stmt_reached_1:boolean,
  exit_stmt_reached_2:boolean,
  exit_stmt_reached_3:boolean,
  var_19_ws_5_0:boolean,
  var_19_ws_5_1:boolean,
  var_19_ws_5_2:boolean,
  var_19_ws_5_3:boolean,
  var_19_ws_5_4:boolean,
  var_19_ws_5_5:boolean,
  t_29_0:Int,
  t_29_1:Int,
  t_29_2:Int,
  t_29_3:Int,
  t_29_4:Int,
  variant_5_0:Int,
  variant_5_1:Int,
  variant_5_2:Int,
  variant_5_3:Int,
  variant_5_4:Int,
  t_28_0:Int,
  t_28_1:Int,
  variant_4_0:Int,
  variant_4_1:Int,
  variant_4_2:Int,
  variant_4_3:Int,
  variant_4_4:Int,
  var_15_start_0:null + realbugs_SinglyLinkedListNode,
  var_15_start_1:null + realbugs_SinglyLinkedListNode,
  var_16_slow_0:null + realbugs_SinglyLinkedListNode,
  var_16_slow_1:null + realbugs_SinglyLinkedListNode,
  var_16_slow_2:null + realbugs_SinglyLinkedListNode,
  var_16_slow_3:null + realbugs_SinglyLinkedListNode,
  var_16_slow_4:null + realbugs_SinglyLinkedListNode,
  var_16_slow_5:null + realbugs_SinglyLinkedListNode,
  t_30_0:Int,
  t_30_1:Int,
  t_30_2:Int,
  t_30_3:Int,
  t_30_4:Int,
  var_20_ws_6_0:boolean,
  var_20_ws_6_1:boolean,
  var_20_ws_6_2:boolean,
  var_20_ws_6_3:boolean,
  var_20_ws_6_4:boolean,
  var_20_ws_6_5:boolean,
  var_21_result_0:null + realbugs_SinglyLinkedListNode,
  var_21_result_1:null + realbugs_SinglyLinkedListNode,
  l0_exit_stmt_reached_0:boolean,
  l0_exit_stmt_reached_1:boolean
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
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_1]
      and
      (
        param_n_3_1=n_0)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        param_n_3_0=param_n_3_1)
    )
  )
  and
  TruePred[]
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_1]
      and
      getUnusedObject[t_27_1,
                     usedObjects_0,
                     usedObjects_1]
      and
      instanceOf[t_27_1,
                realbugs_SinglyLinkedListNode]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition2[t_27_1]
          and
          (
            throw_4=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNode_value_0=realbugs_SinglyLinkedListNode_value_1)
          and
          (
            l0_exit_stmt_reached_0=l0_exit_stmt_reached_1)
          and
          (
            realbugs_SinglyLinkedListNode_next_0=realbugs_SinglyLinkedListNode_next_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition2[t_27_1])
          )
          and
          realbugs_SinglyLinkedListNode_SinglyLinkedListNode_0[t_27_1,
                                                              throw_2,
                                                              throw_3,
                                                              throw_4,
                                                              realbugs_SinglyLinkedListNode_value_0,
                                                              realbugs_SinglyLinkedListNode_value_1,
                                                              realbugs_SinglyLinkedListNode_next_0,
                                                              realbugs_SinglyLinkedListNode_next_1,
                                                              l0_exit_stmt_reached_1]
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNode_value_0=realbugs_SinglyLinkedListNode_value_1)
      and
      (
        t_27_0=t_27_1)
      and
      (
        l0_exit_stmt_reached_0=l0_exit_stmt_reached_1)
      and
      (
        realbugs_SinglyLinkedListNode_next_0=realbugs_SinglyLinkedListNode_next_1)
      and
      (
        usedObjects_0=usedObjects_1)
      and
      (
        throw_1=throw_4)
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_4]
      and
      (
        var_15_start_1=t_27_1)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_4]
        )
      )
      and
      TruePred[]
      and
      (
        var_15_start_0=var_15_start_1)
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_4]
      and
      (
        var_16_slow_1=var_15_start_1)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_4]
        )
      )
      and
      TruePred[]
      and
      (
        var_16_slow_0=var_16_slow_1)
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_4]
      and
      (
        var_17_fast_1=var_15_start_1)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_4]
        )
      )
      and
      TruePred[]
      and
      (
        var_17_fast_0=var_17_fast_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_4]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition4[thiz_0,
                                                           var_16_slow_1]
          and
          (
            throw_5=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNode_next_1=realbugs_SinglyLinkedListNode_next_2)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition4[thiz_0,
                                                               var_16_slow_1]
            )
          )
          and
          (
            realbugs_SinglyLinkedListNode_next_2=(realbugs_SinglyLinkedListNode_next_1)++((var_16_slow_1)->(thiz_0.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0)))
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
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_4]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNode_next_1=realbugs_SinglyLinkedListNode_next_2)
      and
      (
        throw_4=throw_5)
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_5]
      and
      (
        var_18_i_1=1)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_5]
        )
      )
      and
      TruePred[]
      and
      (
        var_18_i_0=var_18_i_1)
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_5]
      and
      (
        t_28_1=add[param_n_3_1,1])
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_5]
        )
      )
      and
      TruePred[]
      and
      (
        t_28_0=t_28_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_5]
      and
      (
        var_19_ws_5_1=(lt[var_18_i_1,
          t_28_1]=>(true)else(false)) // Bug is here (condition of while)
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_5]
        )
      )
      and
      TruePred[]
      and
      (
        var_19_ws_5_0=var_19_ws_5_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                        throw_5,
                                                        var_19_ws_5_1]
      and
      TruePred[]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_5]
          and
          (
            variant_4_1=fun_set_size[fun_reach[var_17_fast_1,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_5]
            )
          )
          and
          TruePred[]
          and
          (
            variant_4_0=variant_4_1)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_5]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                               var_17_fast_1]
              and
              getUnusedObject[throw_6,
                             usedObjects_1,
                             usedObjects_2]
              and
              instanceOf[throw_6,
                        java_lang_Object]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_6]
                  and
                  (
                    throw_7=java_lang_NullPointerExceptionLit)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_6])
                  )
                  and
                  java_lang_Throwable_Constructor_0[]
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
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                   var_17_fast_1]
                )
              )
              and
              TruePred[]
              and
              (
                throw_5=throw_7)
              and
              (
                usedObjects_1=usedObjects_2)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_5]
            )
          )
          and
          TruePred[]
          and
          (
            usedObjects_1=usedObjects_2)
          and
          (
            throw_5=throw_7)
        )
      )
      and
      TruePred[]
      and
      TruePred[]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_7]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_1]
              and
              (
                throw_8=java_lang_NullPointerExceptionLit)
              and
              (
                var_17_fast_1=var_17_fast_2)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_1])
              )
              and
              (
                var_17_fast_2=var_17_fast_1.realbugs_SinglyLinkedListNode_next_2)
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
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_7]
            )
          )
          and
          TruePred[]
          and
          (
            var_17_fast_1=var_17_fast_2)
          and
          (
            throw_7=throw_8)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_8]
          and
          (
            t_29_1=var_18_i_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_8]
            )
          )
          and
          TruePred[]
          and
          (
            t_29_0=t_29_1)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_8]
          and
          (
            var_18_i_2=add[var_18_i_1,1])
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_8]
            )
          )
          and
          TruePred[]
          and
          (
            var_18_i_1=var_18_i_2)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_8]
          and
          (
            t_30_1=add[n_0,1])
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_8]
            )
          )
          and
          TruePred[]
          and
          (
            t_30_0=t_30_1)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_8]
          and
          (
            var_19_ws_5_2=(lt[var_18_i_2,
              t_30_1]=>(true)else(false)) // Bug is here (condition of while)
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_8]
            )
          )
          and
          TruePred[]
          and
          (
            var_19_ws_5_1=var_19_ws_5_2)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_8]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                var_17_fast_2,
                                                                variant_4_1]
              and
              getUnusedObject[throw_9,
                             usedObjects_2,
                             usedObjects_3]
              and
              instanceOf[throw_9,
                        java_lang_Object]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_9]
                  and
                  (
                    throw_10=java_lang_NullPointerExceptionLit)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_9])
                  )
                  and
                  java_lang_Throwable_Constructor_0[]
                  and
                  (
                    throw_9=throw_10)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                    var_17_fast_2,
                                                                    variant_4_1]
                )
              )
              and
              TruePred[]
              and
              (
                throw_8=throw_10)
              and
              (
                usedObjects_2=usedObjects_3)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_8]
            )
          )
          and
          TruePred[]
          and
          (
            usedObjects_2=usedObjects_3)
          and
          (
            throw_8=throw_10)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                            throw_10,
                                                            var_19_ws_5_2]
          and
          TruePred[]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_10]
              and
              (
                variant_4_2=fun_set_size[fun_reach[var_17_fast_2,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_10]
                )
              )
              and
              TruePred[]
              and
              (
                variant_4_1=variant_4_2)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_10]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                   var_17_fast_2]
                  and
                  getUnusedObject[throw_11,
                                 usedObjects_3,
                                 usedObjects_4]
                  and
                  instanceOf[throw_11,
                            java_lang_Object]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_11]
                      and
                      (
                        throw_12=java_lang_NullPointerExceptionLit)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_11])
                      )
                      and
                      java_lang_Throwable_Constructor_0[]
                      and
                      (
                        throw_11=throw_12)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                       var_17_fast_2]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    throw_10=throw_12)
                  and
                  (
                    usedObjects_3=usedObjects_4)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_10]
                )
              )
              and
              TruePred[]
              and
              (
                usedObjects_3=usedObjects_4)
              and
              (
                throw_10=throw_12)
            )
          )
          and
          TruePred[]
          and
          TruePred[]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_12]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_2]
                  and
                  (
                    throw_13=java_lang_NullPointerExceptionLit)
                  and
                  (
                    var_17_fast_2=var_17_fast_3)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_2])
                  )
                  and
                  (
                    var_17_fast_3=var_17_fast_2.realbugs_SinglyLinkedListNode_next_2)
                  and
                  (
                    throw_12=throw_13)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_12]
                )
              )
              and
              TruePred[]
              and
              (
                var_17_fast_2=var_17_fast_3)
              and
              (
                throw_12=throw_13)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_13]
              and
              (
                t_29_2=var_18_i_2)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_13]
                )
              )
              and
              TruePred[]
              and
              (
                t_29_1=t_29_2)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_13]
              and
              (
                var_18_i_3=add[var_18_i_2,1])
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_13]
                )
              )
              and
              TruePred[]
              and
              (
                var_18_i_2=var_18_i_3)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_13]
              and
              (
                t_30_2=add[n_0,1])
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_13]
                )
              )
              and
              TruePred[]
              and
              (
                t_30_1=t_30_2)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_13]
              and
              (
                var_19_ws_5_3=(lt[var_18_i_3,
                  t_30_2]=>(true)else(false)) // Bug is here (condition of while)
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_13]
                )
              )
              and
              TruePred[]
              and
              (
                var_19_ws_5_2=var_19_ws_5_3)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_13]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                    var_17_fast_3,
                                                                    variant_4_2]
                  and
                  getUnusedObject[throw_14,
                                 usedObjects_4,
                                 usedObjects_5]
                  and
                  instanceOf[throw_14,
                            java_lang_Object]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_14]
                      and
                      (
                        throw_15=java_lang_NullPointerExceptionLit)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_14])
                      )
                      and
                      java_lang_Throwable_Constructor_0[]
                      and
                      (
                        throw_14=throw_15)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                        var_17_fast_3,
                                                                        variant_4_2]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    throw_13=throw_15)
                  and
                  (
                    usedObjects_4=usedObjects_5)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_13]
                )
              )
              and
              TruePred[]
              and
              (
                usedObjects_4=usedObjects_5)
              and
              (
                throw_13=throw_15)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                                throw_15,
                                                                var_19_ws_5_3]
              and
              TruePred[]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_15]
                  and
                  (
                    variant_4_3=fun_set_size[fun_reach[var_17_fast_3,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_15]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    variant_4_2=variant_4_3)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_15]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                       var_17_fast_3]
                      and
                      getUnusedObject[throw_16,
                                     usedObjects_5,
                                     usedObjects_6]
                      and
                      instanceOf[throw_16,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_16]
                          and
                          (
                            throw_17=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_16])
                          )
                          and
                          java_lang_Throwable_Constructor_0[]
                          and
                          (
                            throw_16=throw_17)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                           var_17_fast_3]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_15=throw_17)
                      and
                      (
                        usedObjects_5=usedObjects_6)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_15]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_5=usedObjects_6)
                  and
                  (
                    throw_15=throw_17)
                )
              )
              and
              TruePred[]
              and
              TruePred[]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_17]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_3]
                      and
                      (
                        throw_18=java_lang_NullPointerExceptionLit)
                      and
                      (
                        var_17_fast_3=var_17_fast_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_3])
                      )
                      and
                      (
                        var_17_fast_4=var_17_fast_3.realbugs_SinglyLinkedListNode_next_2)
                      and
                      (
                        throw_17=throw_18)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_17]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_17_fast_3=var_17_fast_4)
                  and
                  (
                    throw_17=throw_18)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_18]
                  and
                  (
                    t_29_3=var_18_i_3)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_18]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    t_29_2=t_29_3)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_18]
                  and
                  (
                    var_18_i_4=add[var_18_i_3,1])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_18]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_18_i_3=var_18_i_4)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_18]
                  and
                  (
                    t_30_3=add[n_0,1])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_18]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    t_30_2=t_30_3)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_18]
                  and
                  (
                    var_19_ws_5_4=(lt[var_18_i_4,
                      t_30_3]=>(true)else(false)) // Bug is here (condition of while)
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_18]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_19_ws_5_3=var_19_ws_5_4)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_18]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                        var_17_fast_4,
                                                                        variant_4_3]
                      and
                      getUnusedObject[throw_19,
                                     usedObjects_6,
                                     usedObjects_7]
                      and
                      instanceOf[throw_19,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_19]
                          and
                          (
                            throw_20=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_19])
                          )
                          and
                          java_lang_Throwable_Constructor_0[]
                          and
                          (
                            throw_19=throw_20)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                            var_17_fast_4,
                                                                            variant_4_3]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_18=throw_20)
                      and
                      (
                        usedObjects_6=usedObjects_7)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_18]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_6=usedObjects_7)
                  and
                  (
                    throw_18=throw_20)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                                    throw_20,
                                                                    var_19_ws_5_4]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_20]
                      and
                      (
                        variant_4_4=fun_set_size[fun_reach[var_17_fast_4,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_20]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        variant_4_3=variant_4_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_20]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                           var_17_fast_4]
                          and
                          getUnusedObject[throw_21,
                                         usedObjects_7,
                                         usedObjects_8]
                          and
                          instanceOf[throw_21,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_21]
                              and
                              (
                                throw_22=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_21])
                              )
                              and
                              java_lang_Throwable_Constructor_0[]
                              and
                              (
                                throw_21=throw_22)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                               var_17_fast_4]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_20=throw_22)
                          and
                          (
                            usedObjects_7=usedObjects_8)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_20]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_7=usedObjects_8)
                      and
                      (
                        throw_20=throw_22)
                    )
                  )
                  and
                  TruePred[]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_22]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_4]
                          and
                          (
                            throw_23=java_lang_NullPointerExceptionLit)
                          and
                          (
                            var_17_fast_4=var_17_fast_5)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_4])
                          )
                          and
                          (
                            var_17_fast_5=var_17_fast_4.realbugs_SinglyLinkedListNode_next_2)
                          and
                          (
                            throw_22=throw_23)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_22]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_17_fast_4=var_17_fast_5)
                      and
                      (
                        throw_22=throw_23)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_23]
                      and
                      (
                        t_29_4=var_18_i_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_23]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_29_3=t_29_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_23]
                      and
                      (
                        var_18_i_5=add[var_18_i_4,1])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_23]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_18_i_4=var_18_i_5)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_23]
                      and
                      (
                        t_30_4=add[n_0,1])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_23]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_30_3=t_30_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_23]
                      and
                      (
                        var_19_ws_5_5=(lt[var_18_i_5,
                          t_30_4]=>(true)else(false)) // Bug is here (condition of while)
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_23]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_19_ws_5_4=var_19_ws_5_5)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_23]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                            var_17_fast_5,
                                                                            variant_4_4]
                          and
                          getUnusedObject[throw_24,
                                         usedObjects_8,
                                         usedObjects_9]
                          and
                          instanceOf[throw_24,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_24]
                              and
                              (
                                throw_25=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_24])
                              )
                              and
                              java_lang_Throwable_Constructor_0[]
                              and
                              (
                                throw_24=throw_25)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition12[realbugs_SinglyLinkedListNode_next_2,
                                                                                var_17_fast_5,
                                                                                variant_4_4]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_23=throw_25)
                          and
                          (
                            usedObjects_8=usedObjects_9)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_23]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_8=usedObjects_9)
                      and
                      (
                        throw_23=throw_25)
                    )
                  )
                  and
                  TruePred[]
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                                        throw_20,
                                                                        var_19_ws_5_4]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_17_fast_4=var_17_fast_5)
                  and
                  (
                    var_18_i_4=var_18_i_5)
                  and
                  (
                    t_30_3=t_30_4)
                  and
                  (
                    variant_4_3=variant_4_4)
                  and
                  (
                    t_29_3=t_29_4)
                  and
                  (
                    usedObjects_7=usedObjects_9)
                  and
                  (
                    throw_20=throw_25)
                  and
                  (
                    var_19_ws_5_4=var_19_ws_5_5)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                                    throw_15,
                                                                    var_19_ws_5_3]
                )
              )
              and
              TruePred[]
              and
              (
                var_17_fast_3=var_17_fast_5)
              and
              (
                variant_4_2=variant_4_4)
              and
              (
                var_18_i_3=var_18_i_5)
              and
              (
                t_30_2=t_30_4)
              and
              (
                t_29_2=t_29_4)
              and
              (
                usedObjects_5=usedObjects_9)
              and
              (
                throw_15=throw_25)
              and
              (
                var_19_ws_5_3=var_19_ws_5_5)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                                throw_10,
                                                                var_19_ws_5_2]
            )
          )
          and
          TruePred[]
          and
          (
            var_17_fast_2=var_17_fast_5)
          and
          (
            variant_4_1=variant_4_4)
          and
          (
            var_18_i_2=var_18_i_5)
          and
          (
            t_30_1=t_30_4)
          and
          (
            t_29_1=t_29_4)
          and
          (
            usedObjects_3=usedObjects_9)
          and
          (
            throw_10=throw_25)
          and
          (
            var_19_ws_5_2=var_19_ws_5_5)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                            throw_5,
                                                            var_19_ws_5_1]
        )
      )
      and
      TruePred[]
      and
      (
        var_17_fast_1=var_17_fast_5)
      and
      (
        variant_4_0=variant_4_4)
      and
      (
        var_18_i_1=var_18_i_5)
      and
      (
        t_30_0=t_30_4)
      and
      (
        t_29_0=t_29_4)
      and
      (
        usedObjects_1=usedObjects_9)
      and
      (
        throw_5=throw_25)
      and
      (
        var_19_ws_5_1=var_19_ws_5_5)
    )
  )
  and
  (
    not (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition14[exit_stmt_reached_1,
                                                        throw_25,
                                                        var_19_ws_5_5]
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_25]
      and
      (
        var_20_ws_6_1=(neq[var_17_fast_5,
           null]=>(true)else(false))
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_25]
        )
      )
      and
      TruePred[]
      and
      (
        var_20_ws_6_0=var_20_ws_6_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                        throw_25,
                                                        var_20_ws_6_1]
      and
      TruePred[]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_25]
          and
          (
            variant_5_1=fun_set_size[fun_reach[var_17_fast_5,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_25]
            )
          )
          and
          TruePred[]
          and
          (
            variant_5_0=variant_5_1)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_25]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                               var_17_fast_5]
              and
              getUnusedObject[throw_26,
                             usedObjects_9,
                             usedObjects_10]
              and
              instanceOf[throw_26,
                        java_lang_Object]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_26]
                  and
                  (
                    throw_27=java_lang_NullPointerExceptionLit)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_26])
                  )
                  and
                  java_lang_Throwable_Constructor_0[]
                  and
                  (
                    throw_26=throw_27)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                   var_17_fast_5]
                )
              )
              and
              TruePred[]
              and
              (
                throw_25=throw_27)
              and
              (
                usedObjects_9=usedObjects_10)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_25]
            )
          )
          and
          TruePred[]
          and
          (
            usedObjects_9=usedObjects_10)
          and
          (
            throw_25=throw_27)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_27]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_1]
              and
              (
                throw_28=java_lang_NullPointerExceptionLit)
              and
              (
                var_16_slow_1=var_16_slow_2)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_1])
              )
              and
              (
                var_16_slow_2=var_16_slow_1.realbugs_SinglyLinkedListNode_next_2)
              and
              (
                throw_27=throw_28)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_27]
            )
          )
          and
          TruePred[]
          and
          (
            var_16_slow_1=var_16_slow_2)
          and
          (
            throw_27=throw_28)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_28]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_5]
              and
              (
                throw_29=java_lang_NullPointerExceptionLit)
              and
              (
                var_17_fast_5=var_17_fast_6)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_5])
              )
              and
              (
                var_17_fast_6=var_17_fast_5.realbugs_SinglyLinkedListNode_next_2)
              and
              (
                throw_28=throw_29)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_28]
            )
          )
          and
          TruePred[]
          and
          (
            var_17_fast_5=var_17_fast_6)
          and
          (
            throw_28=throw_29)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_29]
          and
          (
            var_20_ws_6_2=(neq[var_17_fast_6,
               null]=>(true)else(false))
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_29]
            )
          )
          and
          TruePred[]
          and
          (
            var_20_ws_6_1=var_20_ws_6_2)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_29]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                var_17_fast_6,
                                                                variant_5_1]
              and
              getUnusedObject[throw_30,
                             usedObjects_10,
                             usedObjects_11]
              and
              instanceOf[throw_30,
                        java_lang_Object]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_30]
                  and
                  (
                    throw_31=java_lang_NullPointerExceptionLit)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_30])
                  )
                  and
                  java_lang_Throwable_Constructor_0[]
                  and
                  (
                    throw_30=throw_31)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                    var_17_fast_6,
                                                                    variant_5_1]
                )
              )
              and
              TruePred[]
              and
              (
                throw_29=throw_31)
              and
              (
                usedObjects_10=usedObjects_11)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_29]
            )
          )
          and
          TruePred[]
          and
          (
            usedObjects_10=usedObjects_11)
          and
          (
            throw_29=throw_31)
        )
      )
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                            throw_31,
                                                            var_20_ws_6_2]
          and
          TruePred[]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_31]
              and
              (
                variant_5_2=fun_set_size[fun_reach[var_17_fast_6,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_31]
                )
              )
              and
              TruePred[]
              and
              (
                variant_5_1=variant_5_2)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_31]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                   var_17_fast_6]
                  and
                  getUnusedObject[throw_32,
                                 usedObjects_11,
                                 usedObjects_12]
                  and
                  instanceOf[throw_32,
                            java_lang_Object]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_32]
                      and
                      (
                        throw_33=java_lang_NullPointerExceptionLit)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_32])
                      )
                      and
                      java_lang_Throwable_Constructor_0[]
                      and
                      (
                        throw_32=throw_33)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                       var_17_fast_6]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    throw_31=throw_33)
                  and
                  (
                    usedObjects_11=usedObjects_12)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_31]
                )
              )
              and
              TruePred[]
              and
              (
                usedObjects_11=usedObjects_12)
              and
              (
                throw_31=throw_33)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_33]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_2]
                  and
                  (
                    throw_34=java_lang_NullPointerExceptionLit)
                  and
                  (
                    var_16_slow_2=var_16_slow_3)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_2])
                  )
                  and
                  (
                    var_16_slow_3=var_16_slow_2.realbugs_SinglyLinkedListNode_next_2)
                  and
                  (
                    throw_33=throw_34)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_33]
                )
              )
              and
              TruePred[]
              and
              (
                var_16_slow_2=var_16_slow_3)
              and
              (
                throw_33=throw_34)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_34]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_6]
                  and
                  (
                    throw_35=java_lang_NullPointerExceptionLit)
                  and
                  (
                    var_17_fast_6=var_17_fast_7)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_6])
                  )
                  and
                  (
                    var_17_fast_7=var_17_fast_6.realbugs_SinglyLinkedListNode_next_2)
                  and
                  (
                    throw_34=throw_35)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_34]
                )
              )
              and
              TruePred[]
              and
              (
                var_17_fast_6=var_17_fast_7)
              and
              (
                throw_34=throw_35)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_35]
              and
              (
                var_20_ws_6_3=(neq[var_17_fast_7,
                   null]=>(true)else(false))
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_35]
                )
              )
              and
              TruePred[]
              and
              (
                var_20_ws_6_2=var_20_ws_6_3)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_35]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                    var_17_fast_7,
                                                                    variant_5_2]
                  and
                  getUnusedObject[throw_36,
                                 usedObjects_12,
                                 usedObjects_13]
                  and
                  instanceOf[throw_36,
                            java_lang_Object]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_36]
                      and
                      (
                        throw_37=java_lang_NullPointerExceptionLit)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_36])
                      )
                      and
                      java_lang_Throwable_Constructor_0[]
                      and
                      (
                        throw_36=throw_37)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                        var_17_fast_7,
                                                                        variant_5_2]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    throw_35=throw_37)
                  and
                  (
                    usedObjects_12=usedObjects_13)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_35]
                )
              )
              and
              TruePred[]
              and
              (
                usedObjects_12=usedObjects_13)
              and
              (
                throw_35=throw_37)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                                throw_37,
                                                                var_20_ws_6_3]
              and
              TruePred[]
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_37]
                  and
                  (
                    variant_5_3=fun_set_size[fun_reach[var_17_fast_7,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_37]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    variant_5_2=variant_5_3)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_37]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                       var_17_fast_7]
                      and
                      getUnusedObject[throw_38,
                                     usedObjects_13,
                                     usedObjects_14]
                      and
                      instanceOf[throw_38,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_38]
                          and
                          (
                            throw_39=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_38])
                          )
                          and
                          java_lang_Throwable_Constructor_0[]
                          and
                          (
                            throw_38=throw_39)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                           var_17_fast_7]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_37=throw_39)
                      and
                      (
                        usedObjects_13=usedObjects_14)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_37]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_13=usedObjects_14)
                  and
                  (
                    throw_37=throw_39)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_39]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_3]
                      and
                      (
                        throw_40=java_lang_NullPointerExceptionLit)
                      and
                      (
                        var_16_slow_3=var_16_slow_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_3])
                      )
                      and
                      (
                        var_16_slow_4=var_16_slow_3.realbugs_SinglyLinkedListNode_next_2)
                      and
                      (
                        throw_39=throw_40)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_39]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_16_slow_3=var_16_slow_4)
                  and
                  (
                    throw_39=throw_40)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_40]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_7]
                      and
                      (
                        throw_41=java_lang_NullPointerExceptionLit)
                      and
                      (
                        var_17_fast_7=var_17_fast_8)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_7])
                      )
                      and
                      (
                        var_17_fast_8=var_17_fast_7.realbugs_SinglyLinkedListNode_next_2)
                      and
                      (
                        throw_40=throw_41)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_40]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_17_fast_7=var_17_fast_8)
                  and
                  (
                    throw_40=throw_41)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_41]
                  and
                  (
                    var_20_ws_6_4=(neq[var_17_fast_8,
                       null]=>(true)else(false))
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_41]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_20_ws_6_3=var_20_ws_6_4)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_41]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                        var_17_fast_8,
                                                                        variant_5_3]
                      and
                      getUnusedObject[throw_42,
                                     usedObjects_14,
                                     usedObjects_15]
                      and
                      instanceOf[throw_42,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_42]
                          and
                          (
                            throw_43=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_42])
                          )
                          and
                          java_lang_Throwable_Constructor_0[]
                          and
                          (
                            throw_42=throw_43)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                            var_17_fast_8,
                                                                            variant_5_3]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_41=throw_43)
                      and
                      (
                        usedObjects_14=usedObjects_15)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_41]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_14=usedObjects_15)
                  and
                  (
                    throw_41=throw_43)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                                    throw_43,
                                                                    var_20_ws_6_4]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_43]
                      and
                      (
                        variant_5_4=fun_set_size[fun_reach[var_17_fast_8,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_2]])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_43]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        variant_5_3=variant_5_4)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_43]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                           var_17_fast_8]
                          and
                          getUnusedObject[throw_44,
                                         usedObjects_15,
                                         usedObjects_16]
                          and
                          instanceOf[throw_44,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_44]
                              and
                              (
                                throw_45=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_44])
                              )
                              and
                              java_lang_Throwable_Constructor_0[]
                              and
                              (
                                throw_44=throw_45)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition8[realbugs_SinglyLinkedListNode_next_2,
                                                                               var_17_fast_8]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_43=throw_45)
                          and
                          (
                            usedObjects_15=usedObjects_16)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_43]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_15=usedObjects_16)
                      and
                      (
                        throw_43=throw_45)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_45]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_4]
                          and
                          (
                            throw_46=java_lang_NullPointerExceptionLit)
                          and
                          (
                            var_16_slow_4=var_16_slow_5)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_4])
                          )
                          and
                          (
                            var_16_slow_5=var_16_slow_4.realbugs_SinglyLinkedListNode_next_2)
                          and
                          (
                            throw_45=throw_46)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_45]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_16_slow_4=var_16_slow_5)
                      and
                      (
                        throw_45=throw_46)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_46]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_8]
                          and
                          (
                            throw_47=java_lang_NullPointerExceptionLit)
                          and
                          (
                            var_17_fast_8=var_17_fast_9)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition10[var_17_fast_8])
                          )
                          and
                          (
                            var_17_fast_9=var_17_fast_8.realbugs_SinglyLinkedListNode_next_2)
                          and
                          (
                            throw_46=throw_47)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_46]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_17_fast_8=var_17_fast_9)
                      and
                      (
                        throw_46=throw_47)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_47]
                      and
                      (
                        var_20_ws_6_5=(neq[var_17_fast_9,
                           null]=>(true)else(false))
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_47]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_20_ws_6_4=var_20_ws_6_5)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                       throw_47]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                            var_17_fast_9,
                                                                            variant_5_4]
                          and
                          getUnusedObject[throw_48,
                                         usedObjects_16,
                                         usedObjects_17]
                          and
                          instanceOf[throw_48,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_48]
                              and
                              (
                                throw_49=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition6[throw_48])
                              )
                              and
                              java_lang_Throwable_Constructor_0[]
                              and
                              (
                                throw_48=throw_49)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListRemoveNth1Bug7Condition17[realbugs_SinglyLinkedListNode_next_2,
                                                                                var_17_fast_9,
                                                                                variant_5_4]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_47=throw_49)
                          and
                          (
                            usedObjects_16=usedObjects_17)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                           throw_47]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_16=usedObjects_17)
                      and
                      (
                        throw_47=throw_49)
                    )
                  )
                  and
                  TruePred[]
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                                        throw_43,
                                                                        var_20_ws_6_4]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_17_fast_8=var_17_fast_9)
                  and
                  (
                    variant_5_3=variant_5_4)
                  and
                  (
                    var_16_slow_4=var_16_slow_5)
                  and
                  (
                    usedObjects_15=usedObjects_17)
                  and
                  (
                    throw_43=throw_49)
                  and
                  (
                    var_20_ws_6_4=var_20_ws_6_5)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                                    throw_37,
                                                                    var_20_ws_6_3]
                )
              )
              and
              TruePred[]
              and
              (
                var_17_fast_7=var_17_fast_9)
              and
              (
                variant_5_2=variant_5_4)
              and
              (
                var_16_slow_3=var_16_slow_5)
              and
              (
                usedObjects_13=usedObjects_17)
              and
              (
                throw_37=throw_49)
              and
              (
                var_20_ws_6_3=var_20_ws_6_5)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                                throw_31,
                                                                var_20_ws_6_2]
            )
          )
          and
          TruePred[]
          and
          (
            var_17_fast_6=var_17_fast_9)
          and
          (
            variant_5_1=variant_5_4)
          and
          (
            var_16_slow_2=var_16_slow_5)
          and
          (
            usedObjects_11=usedObjects_17)
          and
          (
            throw_31=throw_49)
          and
          (
            var_20_ws_6_2=var_20_ws_6_5)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                            throw_25,
                                                            var_20_ws_6_1]
        )
      )
      and
      TruePred[]
      and
      (
        var_17_fast_5=var_17_fast_9)
      and
      (
        variant_5_0=variant_5_4)
      and
      (
        var_16_slow_1=var_16_slow_5)
      and
      (
        usedObjects_9=usedObjects_17)
      and
      (
        throw_25=throw_49)
      and
      (
        var_20_ws_6_1=var_20_ws_6_5)
    )
  )
  and
  (
    not (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition19[exit_stmt_reached_1,
                                                        throw_49,
                                                        var_20_ws_6_5]
    )
  )
  and
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_49]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_5]
          and
          (
            throw_50=java_lang_NullPointerExceptionLit)
          and
          (
            var_21_result_0=var_21_result_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition15[var_16_slow_5])
          )
          and
          (
            var_21_result_1=var_16_slow_5.realbugs_SinglyLinkedListNode_next_2)
          and
          (
            throw_49=throw_50)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_49]
        )
      )
      and
      TruePred[]
      and
      (
        var_21_result_0=var_21_result_1)
      and
      (
        throw_49=throw_50)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_50]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition20[realbugs_SinglyLinkedListNode_next_2,
                                                            var_16_slow_5]
          and
          (
            throw_51=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListNode_next_2=realbugs_SinglyLinkedListNode_next_3)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition20[realbugs_SinglyLinkedListNode_next_2,
                                                                var_16_slow_5]
            )
          )
          and
          (
            realbugs_SinglyLinkedListNode_next_3=(realbugs_SinglyLinkedListNode_next_2)++((var_16_slow_5)->((var_16_slow_5.realbugs_SinglyLinkedListNode_next_2).realbugs_SinglyLinkedListNode_next_2)))
          and
          (
            throw_50=throw_51)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_50]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListNode_next_2=realbugs_SinglyLinkedListNode_next_3)
      and
      (
        throw_50=throw_51)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_51]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition22[thiz_0,
                                                            var_15_start_1]
          and
          (
            throw_52=java_lang_NullPointerExceptionLit)
          and
          (
            realbugs_SinglyLinkedListRemoveNth1Bug7_header_0=realbugs_SinglyLinkedListRemoveNth1Bug7_header_1)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition22[thiz_0,
                                                                var_15_start_1]
            )
          )
          and
          (
            realbugs_SinglyLinkedListRemoveNth1Bug7_header_1=(realbugs_SinglyLinkedListRemoveNth1Bug7_header_0)++((thiz_0)->(var_15_start_1.realbugs_SinglyLinkedListNode_next_3)))
          and
          (
            throw_51=throw_52)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_51]
        )
      )
      and
      TruePred[]
      and
      (
        realbugs_SinglyLinkedListRemoveNth1Bug7_header_0=realbugs_SinglyLinkedListRemoveNth1Bug7_header_1)
      and
      (
        throw_51=throw_52)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                       throw_52]
      and
      (
        (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition24[]
          and
          (
            (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                               throw_52]
              and
              (
                return_1=var_21_result_1)
              and
              (
                exit_stmt_reached_2=true)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                                   throw_52]
                )
              )
              and
              TruePred[]
              and
              (
                return_0=return_1)
              and
              (
                exit_stmt_reached_1=exit_stmt_reached_2)
            )
          )
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListRemoveNth1Bug7Condition24[])
          )
          and
          TruePred[]
          and
          (
            exit_stmt_reached_1=exit_stmt_reached_2)
          and
          (
            return_0=return_1)
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_1,
                                                           throw_52]
        )
      )
      and
      TruePred[]
      and
      (
        return_0=return_1)
      and
      (
        exit_stmt_reached_1=exit_stmt_reached_2)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_2,
                                                       throw_52]
      and
      (
        return_2=null)
      and
      (
        exit_stmt_reached_3=true)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListRemoveNth1Bug7Condition0[exit_stmt_reached_2,
                                                           throw_52]
        )
      )
      and
      TruePred[]
      and
      (
        return_1=return_2)
      and
      (
        exit_stmt_reached_2=exit_stmt_reached_3)
    )
  )
  and
  TruePred[]

}



pred java_lang_Throwable_Constructor_0[
]{
  TruePred[]
}

//-------------SMB sigs-------------//
one sig realbugs_SinglyLinkedListRemoveNth1Bug7_0 extends realbugs_SinglyLinkedListRemoveNth1Bug7 {}

one sig realbugs_SinglyLinkedListNode_0, realbugs_SinglyLinkedListNode_1, realbugs_SinglyLinkedListNode_2 extends realbugs_SinglyLinkedListNode {}

one sig java_lang_Object_0, java_lang_Object_1, java_lang_Object_2, java_lang_Object_3, java_lang_Object_4, java_lang_Object_5, java_lang_Object_6, java_lang_Object_7, java_lang_Object_8, java_lang_Object_9, java_lang_Object_10, java_lang_Object_11, java_lang_Object_12, java_lang_Object_13, java_lang_Object_14, java_lang_Object_15 extends java_lang_Object {}

one sig java_lang_Boolean_0, java_lang_Boolean_1 extends java_lang_Boolean {}

one sig java_io_PrintStream_0 extends java_io_PrintStream {}

fact {
  no ( QF.frealbugs_SinglyLinkedListNode_next_0.univ & QF.brealbugs_SinglyLinkedListNode_next_0.univ ) and
  realbugs_SinglyLinkedListNode = QF.frealbugs_SinglyLinkedListNode_next_0.univ + QF.brealbugs_SinglyLinkedListNode_next_0.univ
}
//-----SMB: local_ordering()-----//
fun next_realbugs_SinglyLinkedListRemoveNth1Bug7 [] : realbugs_SinglyLinkedListRemoveNth1Bug7 -> lone realbugs_SinglyLinkedListRemoveNth1Bug7 {
none -> none
}
fun min_realbugs_SinglyLinkedListRemoveNth1Bug7 [os: set realbugs_SinglyLinkedListRemoveNth1Bug7] : lone realbugs_SinglyLinkedListRemoveNth1Bug7 {
  os - os.^(next_realbugs_SinglyLinkedListRemoveNth1Bug7[])
}
fun prevs_realbugs_SinglyLinkedListRemoveNth1Bug7[o : realbugs_SinglyLinkedListRemoveNth1Bug7] : set realbugs_SinglyLinkedListRemoveNth1Bug7 {
  o.^(~next_realbugs_SinglyLinkedListRemoveNth1Bug7[])
}
fun next_realbugs_SinglyLinkedListNode [] : realbugs_SinglyLinkedListNode -> lone realbugs_SinglyLinkedListNode {
  realbugs_SinglyLinkedListNode_0 -> realbugs_SinglyLinkedListNode_1 +
  realbugs_SinglyLinkedListNode_1 -> realbugs_SinglyLinkedListNode_2
}
fun min_realbugs_SinglyLinkedListNode [os: set realbugs_SinglyLinkedListNode] : lone realbugs_SinglyLinkedListNode {
  os - os.^(next_realbugs_SinglyLinkedListNode[])
}
fun prevs_realbugs_SinglyLinkedListNode[o : realbugs_SinglyLinkedListNode] : set realbugs_SinglyLinkedListNode {
  o.^(~next_realbugs_SinglyLinkedListNode[])
}
fun next_java_lang_Object [] : java_lang_Object -> lone java_lang_Object {
  java_lang_Object_0 -> java_lang_Object_1 +
  java_lang_Object_1 -> java_lang_Object_2 +
  java_lang_Object_2 -> java_lang_Object_3 +
  java_lang_Object_3 -> java_lang_Object_4 +
  java_lang_Object_4 -> java_lang_Object_5 +
  java_lang_Object_5 -> java_lang_Object_6 +
  java_lang_Object_6 -> java_lang_Object_7 +
  java_lang_Object_7 -> java_lang_Object_8 +
  java_lang_Object_8 -> java_lang_Object_9 +
  java_lang_Object_9 -> java_lang_Object_10 +
  java_lang_Object_10 -> java_lang_Object_11 +
  java_lang_Object_11 -> java_lang_Object_12 +
  java_lang_Object_12 -> java_lang_Object_13 +
  java_lang_Object_13 -> java_lang_Object_14 +
  java_lang_Object_14 -> java_lang_Object_15
}
fun min_java_lang_Object [os: set java_lang_Object] : lone java_lang_Object {
  os - os.^(next_java_lang_Object[])
}
fun prevs_java_lang_Object[o : java_lang_Object] : set java_lang_Object {
  o.^(~next_java_lang_Object[])
}
fun next_java_lang_Boolean [] : java_lang_Boolean -> lone java_lang_Boolean {
  java_lang_Boolean_0 -> java_lang_Boolean_1
}
fun min_java_lang_Boolean [os: set java_lang_Boolean] : lone java_lang_Boolean {
  os - os.^(next_java_lang_Boolean[])
}
fun prevs_java_lang_Boolean[o : java_lang_Boolean] : set java_lang_Boolean {
  o.^(~next_java_lang_Boolean[])
}
fun next_java_io_PrintStream [] : java_io_PrintStream -> lone java_io_PrintStream {
none -> none
}
fun min_java_io_PrintStream [os: set java_io_PrintStream] : lone java_io_PrintStream {
  os - os.^(next_java_io_PrintStream[])
}
fun prevs_java_io_PrintStream[o : java_io_PrintStream] : set java_io_PrintStream {
  o.^(~next_java_io_PrintStream[])
}
//-----SMB: global_ordering()-----//
fun globalNext[]: java_lang_Object -> lone java_lang_Object {
realbugs_SinglyLinkedListRemoveNth1Bug7_0 -> realbugs_SinglyLinkedListNode_0  +  realbugs_SinglyLinkedListNode_0 -> realbugs_SinglyLinkedListNode_1  +  realbugs_SinglyLinkedListNode_1 -> realbugs_SinglyLinkedListNode_2  +  realbugs_SinglyLinkedListNode_2 -> java_lang_Object_0  +  java_lang_Object_0 -> java_lang_Object_1  +  java_lang_Object_1 -> java_lang_Object_2  +  java_lang_Object_2 -> java_lang_Object_3  +  java_lang_Object_3 -> java_lang_Object_4  +  java_lang_Object_4 -> java_lang_Object_5  +  java_lang_Object_5 -> java_lang_Object_6  +  java_lang_Object_6 -> java_lang_Object_7  +  java_lang_Object_7 -> java_lang_Object_8  +  java_lang_Object_8 -> java_lang_Object_9  +  java_lang_Object_9 -> java_lang_Object_10  +  java_lang_Object_10 -> java_lang_Object_11  +  java_lang_Object_11 -> java_lang_Object_12  +  java_lang_Object_12 -> java_lang_Object_13  +  java_lang_Object_13 -> java_lang_Object_14  +  java_lang_Object_14 -> java_lang_Object_15  +  java_lang_Object_15 -> java_lang_Boolean_0  +  java_lang_Boolean_0 -> java_lang_Boolean_1  +  java_lang_Boolean_1 -> java_io_PrintStream_0
}
fun globalMin[s : set java_lang_Object] : lone java_lang_Object {
s - s.^globalNext[]
}
//-----SMB: define_min_parent()-----//
fun minP_realbugs_SinglyLinkedListNode [o : realbugs_SinglyLinkedListNode] : java_lang_Object {
  globalMin[(QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0 + QF.frealbugs_SinglyLinkedListNode_next_0).o]
}
fun minP_java_lang_Object [o : java_lang_Object] : java_lang_Object {
  globalMin[(QF.realbugs_SinglyLinkedListNode_value_0).o]
}
//-----SMB: define_freach()-----//
fun FReach[] : set java_lang_Object {
(QF.n_0 + QF.thiz_0).*(QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0 + QF.realbugs_SinglyLinkedListNode_value_0 + QF.booleanValue_0 + QF.frealbugs_SinglyLinkedListNode_next_0) - null
}
//-----SMB: order_root_nodes()-----//
//-----SMB: root_is_minimum()-----//
fact {
((QF.thiz_0 != null) implies QF.thiz_0 = realbugs_SinglyLinkedListRemoveNth1Bug7_0 )
}
//-----SMB: order_same_min_parent()-----//
//-----SMB: order_same_min_parent_type()-----//
fact {
 all disj o1, o2:realbugs_SinglyLinkedListNode |
  let p1=minP_realbugs_SinglyLinkedListNode[o1]|
  let p2=minP_realbugs_SinglyLinkedListNode[o2]|
  (o1 + o2 in FReach[] and
  some p1 and some p2 and
  p1!=p2 and p1+p2 in realbugs_SinglyLinkedListNode and p1 in prevs_realbugs_SinglyLinkedListNode[p2] )
  implies o1 in prevs_realbugs_SinglyLinkedListNode[o2]
}
fact {
 all disj o1, o2:realbugs_SinglyLinkedListNode |
  let p1=minP_realbugs_SinglyLinkedListNode[o1]|
  let p2=minP_realbugs_SinglyLinkedListNode[o2]|
  (o1 + o2 in FReach[] and
  some p1 and some p2 and
  p1!=p2 and p1+p2 in java_lang_Object and p1 in prevs_java_lang_Object[p2] )
  implies o1 in prevs_realbugs_SinglyLinkedListNode[o2]
}
//-----SMB: order_diff_min_parent_type()-----//
fact {
 all disj o1, o2:realbugs_SinglyLinkedListNode |
  let p1=minP_realbugs_SinglyLinkedListNode[o1]|
  let p2=minP_realbugs_SinglyLinkedListNode[o2]|
  ( o1+o2 in FReach[] and
 some p1 and some p2 and
p1 in realbugs_SinglyLinkedListRemoveNth1Bug7 and p2 in realbugs_SinglyLinkedListNode )
implies o1 in prevs_realbugs_SinglyLinkedListNode[o2]
}
//-----SMB: avoid_holes()-----//
fact {
 all o : realbugs_SinglyLinkedListRemoveNth1Bug7 |
  o in FReach[] implies
   prevs_realbugs_SinglyLinkedListRemoveNth1Bug7[o] in FReach[]
}
fact {
 all o : realbugs_SinglyLinkedListNode |
  o in FReach[] implies
   prevs_realbugs_SinglyLinkedListNode[o] in FReach[]
}
fact {
 all o : java_lang_Object |
  o in FReach[] implies
   prevs_java_lang_Object[o] in FReach[]
}
fact {
 all o : java_lang_Boolean |
  o in FReach[] implies
   prevs_java_lang_Boolean[o] in FReach[]
}
fact {
 all o : java_io_PrintStream |
  o in FReach[] implies
   prevs_java_io_PrintStream[o] in FReach[]
}
/*
holeType ordering:
==============
1) realbugs_SinglyLinkedListRemoveNth1Bug7
2) realbugs_SinglyLinkedListNode
3) java_lang_Object
4) java_lang_Boolean
5) java_io_PrintStream

root nodes ordering:
====================
1) thiz:realbugs_SinglyLinkedListRemoveNth1Bug7
2) n:Int

recursive field ordering:
=========================
1) realbugs_SinglyLinkedListNode_next:(realbugs_SinglyLinkedListNode)->one(null+realbugs_SinglyLinkedListNode)

non-recursive field ordering:
=============================
1) realbugs_SinglyLinkedListRemoveNth1Bug7_header:(realbugs_SinglyLinkedListRemoveNth1Bug7)->one(null+realbugs_SinglyLinkedListNode)
2) realbugs_SinglyLinkedListNode_value:(realbugs_SinglyLinkedListNode)->one(java_lang_Object+null)
3) booleanValue:(java_lang_Boolean)->one(boolean)
*/
one sig QF {
  booleanValue_0:( java_lang_Boolean ) -> one ( boolean ),
  brealbugs_SinglyLinkedListNode_next_0:(realbugs_SinglyLinkedListNode) -> lone((realbugs_SinglyLinkedListNode)),
  frealbugs_SinglyLinkedListNode_next_0:(realbugs_SinglyLinkedListNode) -> lone((realbugs_SinglyLinkedListNode + null)),
  java_lang_Boolean_FALSE_0:( ClassFields ) -> one ( java_lang_Boolean ),
  java_lang_Boolean_TRUE_0:( ClassFields ) -> one ( java_lang_Boolean ),
  java_lang_System_out_0:( ClassFields ) -> ( java_io_PrintStream ),
  l17_exit_stmt_reached_1:boolean,
  l17_exit_stmt_reached_2:boolean,
  l17_exit_stmt_reached_3:boolean,
  l17_l0_exit_stmt_reached_0:boolean,
  l17_l0_exit_stmt_reached_1:boolean,
  l17_param_n_3_0:Int,
  l17_param_n_3_1:Int,
  l17_t_27_0:null + realbugs_SinglyLinkedListNode,
  l17_t_27_1:null + realbugs_SinglyLinkedListNode,
  l17_t_28_0:Int,
  l17_t_28_1:Int,
  l17_t_29_0:Int,
  l17_t_29_1:Int,
  l17_t_29_2:Int,
  l17_t_29_3:Int,
  l17_t_29_4:Int,
  l17_t_30_0:Int,
  l17_t_30_1:Int,
  l17_t_30_2:Int,
  l17_t_30_3:Int,
  l17_t_30_4:Int,
  l17_var_15_start_0:null + realbugs_SinglyLinkedListNode,
  l17_var_15_start_1:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_0:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_1:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_2:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_3:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_4:null + realbugs_SinglyLinkedListNode,
  l17_var_16_slow_5:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_0:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_1:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_2:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_3:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_4:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_5:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_6:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_7:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_8:null + realbugs_SinglyLinkedListNode,
  l17_var_17_fast_9:null + realbugs_SinglyLinkedListNode,
  l17_var_18_i_0:Int,
  l17_var_18_i_1:Int,
  l17_var_18_i_2:Int,
  l17_var_18_i_3:Int,
  l17_var_18_i_4:Int,
  l17_var_18_i_5:Int,
  l17_var_19_ws_5_0:boolean,
  l17_var_19_ws_5_1:boolean,
  l17_var_19_ws_5_2:boolean,
  l17_var_19_ws_5_3:boolean,
  l17_var_19_ws_5_4:boolean,
  l17_var_19_ws_5_5:boolean,
  l17_var_20_ws_6_0:boolean,
  l17_var_20_ws_6_1:boolean,
  l17_var_20_ws_6_2:boolean,
  l17_var_20_ws_6_3:boolean,
  l17_var_20_ws_6_4:boolean,
  l17_var_20_ws_6_5:boolean,
  l17_var_21_result_0:null + realbugs_SinglyLinkedListNode,
  l17_var_21_result_1:null + realbugs_SinglyLinkedListNode,
  l17_variant_4_0:Int,
  l17_variant_4_1:Int,
  l17_variant_4_2:Int,
  l17_variant_4_3:Int,
  l17_variant_4_4:Int,
  l17_variant_5_0:Int,
  l17_variant_5_1:Int,
  l17_variant_5_2:Int,
  l17_variant_5_3:Int,
  l17_variant_5_4:Int,
  n_0:Int,
  realbugs_SinglyLinkedListNode_next_1:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_2:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_next_3:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_value_0:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListNode_value_1:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  realbugs_SinglyLinkedListRemoveNth1Bug7_header_0:( realbugs_SinglyLinkedListRemoveNth1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListRemoveNth1Bug7_header_1:( realbugs_SinglyLinkedListRemoveNth1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  return_0:null + realbugs_SinglyLinkedListNode,
  return_1:null + realbugs_SinglyLinkedListNode,
  return_2:null + realbugs_SinglyLinkedListNode,
  thiz_0:realbugs_SinglyLinkedListRemoveNth1Bug7,
  throw_0:java_lang_Throwable + null,
  throw_1:java_lang_Throwable + null,
  throw_10:java_lang_Throwable + null,
  throw_11:java_lang_Throwable + null,
  throw_12:java_lang_Throwable + null,
  throw_13:java_lang_Throwable + null,
  throw_14:java_lang_Throwable + null,
  throw_15:java_lang_Throwable + null,
  throw_16:java_lang_Throwable + null,
  throw_17:java_lang_Throwable + null,
  throw_18:java_lang_Throwable + null,
  throw_19:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  throw_20:java_lang_Throwable + null,
  throw_21:java_lang_Throwable + null,
  throw_22:java_lang_Throwable + null,
  throw_23:java_lang_Throwable + null,
  throw_24:java_lang_Throwable + null,
  throw_25:java_lang_Throwable + null,
  throw_26:java_lang_Throwable + null,
  throw_27:java_lang_Throwable + null,
  throw_28:java_lang_Throwable + null,
  throw_29:java_lang_Throwable + null,
  throw_3:java_lang_Throwable + null,
  throw_30:java_lang_Throwable + null,
  throw_31:java_lang_Throwable + null,
  throw_32:java_lang_Throwable + null,
  throw_33:java_lang_Throwable + null,
  throw_34:java_lang_Throwable + null,
  throw_35:java_lang_Throwable + null,
  throw_36:java_lang_Throwable + null,
  throw_37:java_lang_Throwable + null,
  throw_38:java_lang_Throwable + null,
  throw_39:java_lang_Throwable + null,
  throw_4:java_lang_Throwable + null,
  throw_40:java_lang_Throwable + null,
  throw_41:java_lang_Throwable + null,
  throw_42:java_lang_Throwable + null,
  throw_43:java_lang_Throwable + null,
  throw_44:java_lang_Throwable + null,
  throw_45:java_lang_Throwable + null,
  throw_46:java_lang_Throwable + null,
  throw_47:java_lang_Throwable + null,
  throw_48:java_lang_Throwable + null,
  throw_49:java_lang_Throwable + null,
  throw_5:java_lang_Throwable + null,
  throw_50:java_lang_Throwable + null,
  throw_51:java_lang_Throwable + null,
  throw_52:java_lang_Throwable + null,
  throw_6:java_lang_Throwable + null,
  throw_7:java_lang_Throwable + null,
  throw_8:java_lang_Throwable + null,
  throw_9:java_lang_Throwable + null,
  usedObjects_0:set ( java_lang_Object ),
  usedObjects_1:set ( java_lang_Object ),
  usedObjects_10:set ( java_lang_Object ),
  usedObjects_11:set ( java_lang_Object ),
  usedObjects_12:set ( java_lang_Object ),
  usedObjects_13:set ( java_lang_Object ),
  usedObjects_14:set ( java_lang_Object ),
  usedObjects_15:set ( java_lang_Object ),
  usedObjects_16:set ( java_lang_Object ),
  usedObjects_17:set ( java_lang_Object ),
  usedObjects_2:set ( java_lang_Object ),
  usedObjects_3:set ( java_lang_Object ),
  usedObjects_4:set ( java_lang_Object ),
  usedObjects_5:set ( java_lang_Object ),
  usedObjects_6:set ( java_lang_Object ),
  usedObjects_7:set ( java_lang_Object ),
  usedObjects_8:set ( java_lang_Object ),
  usedObjects_9:set ( java_lang_Object )
}


fact {
  precondition_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[QF.booleanValue_0,
                                                                         QF.java_lang_Boolean_FALSE_0,
                                                                         QF.java_lang_Boolean_TRUE_0,
                                                                         QF.java_lang_System_out_0,
                                                                         QF.n_0,
                                                                         (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                         QF.realbugs_SinglyLinkedListNode_value_0,
                                                                         QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0,
                                                                         QF.return_0,
                                                                         QF.thiz_0,
                                                                         QF.throw_0,
                                                                         QF.usedObjects_0]

}

fact {
  realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[QF.thiz_0,
                                                            QF.throw_1,
                                                            QF.throw_2,
                                                            QF.throw_3,
                                                            QF.throw_4,
                                                            QF.throw_5,
                                                            QF.throw_6,
                                                            QF.throw_7,
                                                            QF.throw_8,
                                                            QF.throw_9,
                                                            QF.throw_10,
                                                            QF.throw_11,
                                                            QF.throw_12,
                                                            QF.throw_13,
                                                            QF.throw_14,
                                                            QF.throw_15,
                                                            QF.throw_16,
                                                            QF.throw_17,
                                                            QF.throw_18,
                                                            QF.throw_19,
                                                            QF.throw_20,
                                                            QF.throw_21,
                                                            QF.throw_22,
                                                            QF.throw_23,
                                                            QF.throw_24,
                                                            QF.throw_25,
                                                            QF.throw_26,
                                                            QF.throw_27,
                                                            QF.throw_28,
                                                            QF.throw_29,
                                                            QF.throw_30,
                                                            QF.throw_31,
                                                            QF.throw_32,
                                                            QF.throw_33,
                                                            QF.throw_34,
                                                            QF.throw_35,
                                                            QF.throw_36,
                                                            QF.throw_37,
                                                            QF.throw_38,
                                                            QF.throw_39,
                                                            QF.throw_40,
                                                            QF.throw_41,
                                                            QF.throw_42,
                                                            QF.throw_43,
                                                            QF.throw_44,
                                                            QF.throw_45,
                                                            QF.throw_46,
                                                            QF.throw_47,
                                                            QF.throw_48,
                                                            QF.throw_49,
                                                            QF.throw_50,
                                                            QF.throw_51,
                                                            QF.throw_52,
                                                            QF.return_0,
                                                            QF.return_1,
                                                            QF.return_2,
                                                            QF.n_0,
                                                            QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0,
                                                            QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_1,
                                                            QF.realbugs_SinglyLinkedListNode_value_0,
                                                            QF.realbugs_SinglyLinkedListNode_value_1,
                                                            (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                            QF.realbugs_SinglyLinkedListNode_next_1,
                                                            QF.realbugs_SinglyLinkedListNode_next_2,
                                                            QF.realbugs_SinglyLinkedListNode_next_3,
                                                            QF.usedObjects_0,
                                                            QF.usedObjects_1,
                                                            QF.usedObjects_2,
                                                            QF.usedObjects_3,
                                                            QF.usedObjects_4,
                                                            QF.usedObjects_5,
                                                            QF.usedObjects_6,
                                                            QF.usedObjects_7,
                                                            QF.usedObjects_8,
                                                            QF.usedObjects_9,
                                                            QF.usedObjects_10,
                                                            QF.usedObjects_11,
                                                            QF.usedObjects_12,
                                                            QF.usedObjects_13,
                                                            QF.usedObjects_14,
                                                            QF.usedObjects_15,
                                                            QF.usedObjects_16,
                                                            QF.usedObjects_17,
                                                            QF.l17_var_18_i_0,
                                                            QF.l17_var_18_i_1,
                                                            QF.l17_var_18_i_2,
                                                            QF.l17_var_18_i_3,
                                                            QF.l17_var_18_i_4,
                                                            QF.l17_var_18_i_5,
                                                            QF.l17_param_n_3_0,
                                                            QF.l17_param_n_3_1,
                                                            QF.l17_t_27_0,
                                                            QF.l17_t_27_1,
                                                            QF.l17_var_17_fast_0,
                                                            QF.l17_var_17_fast_1,
                                                            QF.l17_var_17_fast_2,
                                                            QF.l17_var_17_fast_3,
                                                            QF.l17_var_17_fast_4,
                                                            QF.l17_var_17_fast_5,
                                                            QF.l17_var_17_fast_6,
                                                            QF.l17_var_17_fast_7,
                                                            QF.l17_var_17_fast_8,
                                                            QF.l17_var_17_fast_9,
                                                            QF.l17_exit_stmt_reached_1,
                                                            QF.l17_exit_stmt_reached_2,
                                                            QF.l17_exit_stmt_reached_3,
                                                            QF.l17_var_19_ws_5_0,
                                                            QF.l17_var_19_ws_5_1,
                                                            QF.l17_var_19_ws_5_2,
                                                            QF.l17_var_19_ws_5_3,
                                                            QF.l17_var_19_ws_5_4,
                                                            QF.l17_var_19_ws_5_5,
                                                            QF.l17_t_29_0,
                                                            QF.l17_t_29_1,
                                                            QF.l17_t_29_2,
                                                            QF.l17_t_29_3,
                                                            QF.l17_t_29_4,
                                                            QF.l17_variant_5_0,
                                                            QF.l17_variant_5_1,
                                                            QF.l17_variant_5_2,
                                                            QF.l17_variant_5_3,
                                                            QF.l17_variant_5_4,
                                                            QF.l17_t_28_0,
                                                            QF.l17_t_28_1,
                                                            QF.l17_variant_4_0,
                                                            QF.l17_variant_4_1,
                                                            QF.l17_variant_4_2,
                                                            QF.l17_variant_4_3,
                                                            QF.l17_variant_4_4,
                                                            QF.l17_var_15_start_0,
                                                            QF.l17_var_15_start_1,
                                                            QF.l17_var_16_slow_0,
                                                            QF.l17_var_16_slow_1,
                                                            QF.l17_var_16_slow_2,
                                                            QF.l17_var_16_slow_3,
                                                            QF.l17_var_16_slow_4,
                                                            QF.l17_var_16_slow_5,
                                                            QF.l17_t_30_0,
                                                            QF.l17_t_30_1,
                                                            QF.l17_t_30_2,
                                                            QF.l17_t_30_3,
                                                            QF.l17_t_30_4,
                                                            QF.l17_var_20_ws_6_0,
                                                            QF.l17_var_20_ws_6_1,
                                                            QF.l17_var_20_ws_6_2,
                                                            QF.l17_var_20_ws_6_3,
                                                            QF.l17_var_20_ws_6_4,
                                                            QF.l17_var_20_ws_6_5,
                                                            QF.l17_var_21_result_0,
                                                            QF.l17_var_21_result_1,
                                                            QF.l17_l0_exit_stmt_reached_0,
                                                            QF.l17_l0_exit_stmt_reached_1]

}

assert  repair_assert_1{
  postcondition_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[QF.n_0,
                                                                          (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                          QF.realbugs_SinglyLinkedListNode_next_3,
                                                                          QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0,
                                                                          QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_1,
                                                                          QF.return_2,
                                                                          QF.thiz_0,
                                                                          QF.thiz_0,
                                                                          QF.throw_52]
}
check repair_assert_1 for 0 but  exactly 3 realbugs_SinglyLinkedListNode, 23 java_lang_Object, exactly 1 realbugs_SinglyLinkedListRemoveNth1Bug7, exactly 1 java_io_PrintStream, exactly 2 java_lang_Boolean,4 int

pred repair_pred_1{
  postcondition_realbugs_SinglyLinkedListRemoveNth1Bug7_removeNthFromEnd_0[QF.n_0,
                                                                          (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                          QF.realbugs_SinglyLinkedListNode_next_3,
                                                                          QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_0,
                                                                          QF.realbugs_SinglyLinkedListRemoveNth1Bug7_header_1,
                                                                          QF.return_2,
                                                                          QF.thiz_0,
                                                                          QF.thiz_0,
                                                                          QF.throw_52]
}
run repair_pred_1 for 0 but  exactly 3 realbugs_SinglyLinkedListNode, 23 java_lang_Object, exactly 1 realbugs_SinglyLinkedListRemoveNth1Bug7, exactly 1 java_io_PrintStream, exactly 2 java_lang_Boolean,4 int
