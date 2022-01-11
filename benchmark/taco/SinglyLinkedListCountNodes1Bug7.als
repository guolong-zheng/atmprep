/*
 * DynAlloy translator options
 * ---------------------------
 * assertionId= check_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0
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
pred realbugs_SinglyLinkedListNodeCondition5[
]{
   not (
     true=true)

}
pred realbugs_SinglyLinkedListNodeCondition4[
]{
   true=true

}
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




//-------------- realbugs_SinglyLinkedListCountNodes1Bug7--------------//
sig realbugs_SinglyLinkedListCountNodes1Bug7 extends java_lang_Object {}
{}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition8[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_13_temp:univ
]{
   lt[fun_set_size[fun_reach[var_13_temp,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
     0]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition9[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_13_temp:univ
]{
   not (
     lt[fun_set_size[fun_reach[var_13_temp,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
       0]
   )

}
pred postcondition_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[
  realbugs_SinglyLinkedListCountNodes1Bug7_header':univ->univ,
  realbugs_SinglyLinkedListNode_next':univ->univ,
  return':univ,
  thiz':univ,
  throw':univ
]{
   realbugs_SinglyLinkedListCountNodes1Bug7_ensures[realbugs_SinglyLinkedListCountNodes1Bug7_header',
                                                   realbugs_SinglyLinkedListNode_next',
                                                   return',
                                                   thiz',
                                                   throw']
   and
   (
     not (
       throw'=AssertionFailureLit)
   )

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition12[
  exit_stmt_reached:univ,
  throw:univ,
  var_14_ws_4:univ
]{
   liftExpression[var_14_ws_4]
   and
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred realbugs_SinglyLinkedListCountNodes1Bug7_ensures[
  realbugs_SinglyLinkedListCountNodes1Bug7_header':univ->univ,
  realbugs_SinglyLinkedListNode_next':univ->univ,
  return':univ,
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
             equ[return',
                fun_set_size[fun_reach[thiz'.realbugs_SinglyLinkedListCountNodes1Bug7_header',realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next']]]
   )

}
pred realbugs_SinglyLinkedListCountNodes1Bug7_requires[
  booleanValue:univ->univ,
  java_lang_Boolean_FALSE:univ->univ,
  java_lang_Boolean_TRUE:univ->univ,
  java_lang_System_out:univ->univ,
  realbugs_SinglyLinkedListCountNodes1Bug7_header:univ->univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_value:univ->univ,
  return:univ,
  thiz:univ,
  usedObjects:univ
]{
   (
     true=true)
   and
   (
     usedObjects=fun_weak_reach[none+thiz+return+(ClassFields.java_lang_System_out)+(ClassFields.java_lang_Boolean_TRUE)+(ClassFields.java_lang_Boolean_FALSE),java_lang_Object,(none)->(none)+realbugs_SinglyLinkedListCountNodes1Bug7_header+realbugs_SinglyLinkedListNode_next+realbugs_SinglyLinkedListNode_value+booleanValue])

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition1[
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
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition15[
]{
   true=true

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition0[
  exit_stmt_reached:univ,
  throw:univ
]{
   (
     throw=null)
   and
   (
     exit_stmt_reached=false)

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition16[
]{
   not (
     true=true)

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition3[
  thiz:univ
]{
   not (
     isEmptyOrNull[thiz])

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition2[
  thiz:univ
]{
   isEmptyOrNull[thiz]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition14[
  t_26:univ
]{
   not (
     t_26=true)

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition6[
  throw:univ
]{
   isEmptyOrNull[throw]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition13[
  t_26:univ
]{
   t_26=true

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition4[
  var_13_temp:univ
]{
   isEmptyOrNull[var_13_temp]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition5[
  var_13_temp:univ
]{
   not (
     isEmptyOrNull[var_13_temp])

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition7[
  throw:univ
]{
   not (
     isEmptyOrNull[throw])

}
pred realbugs_SinglyLinkedListCountNodes1Bug7_object_invariant[
  realbugs_SinglyLinkedListCountNodes1Bug7_header:univ->univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  thiz:univ
]{
   all n:null+realbugs_SinglyLinkedListNode | {
     liftExpression[fun_set_contains[fun_reach[thiz.realbugs_SinglyLinkedListCountNodes1Bug7_header,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next],n]]
     implies
             equ[fun_set_contains[fun_reach[n.realbugs_SinglyLinkedListNode_next,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next],n],
                false]

   }

}
pred precondition_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[
  booleanValue:univ->univ,
  java_lang_Boolean_FALSE:univ->univ,
  java_lang_Boolean_TRUE:univ->univ,
  java_lang_System_out:univ->univ,
  realbugs_SinglyLinkedListCountNodes1Bug7_header:univ->univ,
  realbugs_SinglyLinkedListNode_next:univ->univ,
  realbugs_SinglyLinkedListNode_value:univ->univ,
  return:univ,
  thiz:univ,
  throw:univ,
  usedObjects:univ
]{
   realbugs_SinglyLinkedListCountNodes1Bug7_object_invariant[realbugs_SinglyLinkedListCountNodes1Bug7_header,
                                                            realbugs_SinglyLinkedListNode_next,
                                                            thiz]
   and
   equ[throw,
      null]
   and
   realbugs_SinglyLinkedListCountNodes1Bug7_requires[booleanValue,
                                                    java_lang_Boolean_FALSE,
                                                    java_lang_Boolean_TRUE,
                                                    java_lang_System_out,
                                                    realbugs_SinglyLinkedListCountNodes1Bug7_header,
                                                    realbugs_SinglyLinkedListNode_next,
                                                    realbugs_SinglyLinkedListNode_value,
                                                    return,
                                                    thiz,
                                                    usedObjects]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition10[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_13_temp:univ,
  variant_3:univ
]{
   gte[fun_set_size[fun_reach[var_13_temp,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
      variant_3]

}
pred realbugs_SinglyLinkedListCountNodes1Bug7Condition11[
  realbugs_SinglyLinkedListNode_next:univ->univ,
  var_13_temp:univ,
  variant_3:univ
]{
   not (
     gte[fun_set_size[fun_reach[var_13_temp,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next]],
        variant_3]
   )

}
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


pred realbugs_SinglyLinkedListNode_getNext_0[
  thiz_0:realbugs_SinglyLinkedListNode,
  throw_1:java_lang_Throwable + null,
  throw_2:java_lang_Throwable + null,
  return_0:null + realbugs_SinglyLinkedListNode,
  return_1:null + realbugs_SinglyLinkedListNode,
  return_2:null + realbugs_SinglyLinkedListNode,
  realbugs_SinglyLinkedListNode_next_0:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  exit_stmt_reached_1:boolean,
  exit_stmt_reached_2:boolean,
  exit_stmt_reached_3:boolean
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
          realbugs_SinglyLinkedListNodeCondition4[]
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
                    return_0=return_1)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListNodeCondition0[thiz_0])
                  )
                  and
                  (
                    return_1=thiz_0.realbugs_SinglyLinkedListNode_next_0)
                  and
                  (
                    throw_1=throw_2)
                )
              )
              and
              (
                exit_stmt_reached_2=true)
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
                return_0=return_1)
              and
              (
                throw_1=throw_2)
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
              realbugs_SinglyLinkedListNodeCondition4[])
          )
          and
          TruePred[]
          and
          (
            throw_1=throw_2)
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
          realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_1,
                                                 throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        return_0=return_1)
      and
      (
        throw_1=throw_2)
      and
      (
        exit_stmt_reached_1=exit_stmt_reached_2)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_2,
                                             throw_2]
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
          realbugs_SinglyLinkedListNodeCondition2[exit_stmt_reached_2,
                                                 throw_2]
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



pred realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[
  thiz_0:realbugs_SinglyLinkedListCountNodes1Bug7,
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
  return_0:Int,
  return_1:Int,
  return_2:Int,
  realbugs_SinglyLinkedListNode_next_0:( realbugs_SinglyLinkedListNode ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListCountNodes1Bug7_header_0:( realbugs_SinglyLinkedListCountNodes1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  usedObjects_0:set ( java_lang_Object ),
  usedObjects_1:set ( java_lang_Object ),
  usedObjects_2:set ( java_lang_Object ),
  usedObjects_3:set ( java_lang_Object ),
  usedObjects_4:set ( java_lang_Object ),
  usedObjects_5:set ( java_lang_Object ),
  usedObjects_6:set ( java_lang_Object ),
  usedObjects_7:set ( java_lang_Object ),
  usedObjects_8:set ( java_lang_Object ),
  exit_stmt_reached_1:boolean,
  exit_stmt_reached_2:boolean,
  exit_stmt_reached_3:boolean,
  var_13_temp_0:null + realbugs_SinglyLinkedListNode,
  var_13_temp_1:null + realbugs_SinglyLinkedListNode,
  var_13_temp_2:null + realbugs_SinglyLinkedListNode,
  var_13_temp_3:null + realbugs_SinglyLinkedListNode,
  var_13_temp_4:null + realbugs_SinglyLinkedListNode,
  var_13_temp_5:null + realbugs_SinglyLinkedListNode,
  var_14_ws_4_0:boolean,
  var_14_ws_4_1:boolean,
  var_14_ws_4_2:boolean,
  var_14_ws_4_3:boolean,
  var_14_ws_4_4:boolean,
  var_14_ws_4_5:boolean,
  var_12_count_0:Int,
  var_12_count_1:Int,
  var_12_count_2:Int,
  var_12_count_3:Int,
  var_12_count_4:Int,
  var_12_count_5:Int,
  variant_3_0:Int,
  variant_3_1:Int,
  variant_3_2:Int,
  variant_3_3:Int,
  variant_3_4:Int,
  t_24_0:null + realbugs_SinglyLinkedListNode,
  t_24_1:null + realbugs_SinglyLinkedListNode,
  t_24_2:null + realbugs_SinglyLinkedListNode,
  t_24_3:null + realbugs_SinglyLinkedListNode,
  t_24_4:null + realbugs_SinglyLinkedListNode,
  t_24_5:null + realbugs_SinglyLinkedListNode,
  t_24_6:null + realbugs_SinglyLinkedListNode,
  t_24_7:null + realbugs_SinglyLinkedListNode,
  t_24_8:null + realbugs_SinglyLinkedListNode,
  t_25_0:null + realbugs_SinglyLinkedListNode,
  t_25_1:null + realbugs_SinglyLinkedListNode,
  t_25_2:null + realbugs_SinglyLinkedListNode,
  t_25_3:null + realbugs_SinglyLinkedListNode,
  t_25_4:null + realbugs_SinglyLinkedListNode,
  t_25_5:null + realbugs_SinglyLinkedListNode,
  t_25_6:null + realbugs_SinglyLinkedListNode,
  t_25_7:null + realbugs_SinglyLinkedListNode,
  t_25_8:null + realbugs_SinglyLinkedListNode,
  t_26_0:boolean,
  t_26_1:boolean,
  t_22_0:null + realbugs_SinglyLinkedListNode,
  t_22_1:null + realbugs_SinglyLinkedListNode,
  t_22_2:null + realbugs_SinglyLinkedListNode,
  t_23_0:Int,
  t_23_1:Int,
  t_23_2:Int,
  t_23_3:Int,
  t_23_4:Int,
  l15_exit_stmt_reached_0:boolean,
  l15_exit_stmt_reached_1:boolean,
  l15_exit_stmt_reached_2:boolean,
  l15_exit_stmt_reached_3:boolean,
  l0_exit_stmt_reached_0:boolean,
  l0_exit_stmt_reached_1:boolean,
  l0_exit_stmt_reached_2:boolean,
  l0_exit_stmt_reached_3:boolean,
  l6_exit_stmt_reached_0:boolean,
  l6_exit_stmt_reached_1:boolean,
  l6_exit_stmt_reached_2:boolean,
  l6_exit_stmt_reached_3:boolean,
  l2_exit_stmt_reached_0:boolean,
  l2_exit_stmt_reached_1:boolean,
  l2_exit_stmt_reached_2:boolean,
  l2_exit_stmt_reached_3:boolean,
  l3_exit_stmt_reached_0:boolean,
  l3_exit_stmt_reached_1:boolean,
  l3_exit_stmt_reached_2:boolean,
  l3_exit_stmt_reached_3:boolean,
  l14_exit_stmt_reached_0:boolean,
  l14_exit_stmt_reached_1:boolean,
  l14_exit_stmt_reached_2:boolean,
  l14_exit_stmt_reached_3:boolean,
  l11_exit_stmt_reached_0:boolean,
  l11_exit_stmt_reached_1:boolean,
  l11_exit_stmt_reached_2:boolean,
  l11_exit_stmt_reached_3:boolean,
  l7_exit_stmt_reached_0:boolean,
  l7_exit_stmt_reached_1:boolean,
  l7_exit_stmt_reached_2:boolean,
  l7_exit_stmt_reached_3:boolean,
  l10_exit_stmt_reached_0:boolean,
  l10_exit_stmt_reached_1:boolean,
  l10_exit_stmt_reached_2:boolean,
  l10_exit_stmt_reached_3:boolean
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
  TruePred[]
  and
  (
    (
      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                        throw_1]
      and
      (
        var_12_count_1=0)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                            throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        var_12_count_0=var_12_count_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                        throw_1]
      and
      (
        t_26_1=(equ[thiz_0.realbugs_SinglyLinkedListCountNodes1Bug7_header_0,
           null]=>(true)else(false))
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                            throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        t_26_0=t_26_1)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                        throw_1]
      and
      (
        (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition13[t_26_1]
          and
          (
            (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                throw_1]
              and
              (
                var_12_count_5=0)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_1]
                )
              )
              and
              TruePred[]
              and
              (
                var_12_count_1=var_12_count_5)
            )
          )
          and
          (
            l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
          and
          (
            l0_exit_stmt_reached_0=l0_exit_stmt_reached_3)
          and
          (
            l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
          and
          (
            l2_exit_stmt_reached_0=l2_exit_stmt_reached_3)
          and
          (
            l3_exit_stmt_reached_0=l3_exit_stmt_reached_3)
          and
          (
            l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
          and
          (
            var_14_ws_4_0=var_14_ws_4_5)
          and
          (
            variant_3_0=variant_3_4)
          and
          (
            l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
          and
          (
            usedObjects_0=usedObjects_8)
          and
          (
            t_23_0=t_23_4)
          and
          (
            t_24_0=t_24_8)
          and
          (
            t_25_0=t_25_8)
          and
          (
            l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
          and
          (
            t_22_0=t_22_2)
          and
          (
            l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
          and
          (
            var_13_temp_0=var_13_temp_5)
          and
          (
            throw_1=throw_36)
        )
        or
        (
          (
            not (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition13[t_26_1])
          )
          and
          TruePred[]
          and
          TruePred[]
          and
          (
            (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                throw_1]
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition2[thiz_0]
                  and
                  (
                    throw_2=java_lang_NullPointerExceptionLit)
                  and
                  (
                    var_13_temp_0=var_13_temp_1)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition2[thiz_0])
                  )
                  and
                  (
                    var_13_temp_1=thiz_0.realbugs_SinglyLinkedListCountNodes1Bug7_header_0)
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
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_1]
                )
              )
              and
              TruePred[]
              and
              (
                var_13_temp_0=var_13_temp_1)
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
              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                throw_2]
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_1]
                  and
                  (
                    throw_4=java_lang_NullPointerExceptionLit)
                  and
                  (
                    l0_exit_stmt_reached_0=l0_exit_stmt_reached_3)
                  and
                  (
                    t_22_0=t_22_2)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_1])
                  )
                  and
                  realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_1,
                                                         throw_3,
                                                         throw_4,
                                                         t_22_0,
                                                         t_22_1,
                                                         t_22_2,
                                                         realbugs_SinglyLinkedListNode_next_0,
                                                         l0_exit_stmt_reached_1,
                                                         l0_exit_stmt_reached_2,
                                                         l0_exit_stmt_reached_3]
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_2]
                )
              )
              and
              TruePred[]
              and
              (
                l0_exit_stmt_reached_0=l0_exit_stmt_reached_3)
              and
              (
                t_22_0=t_22_2)
              and
              (
                throw_2=throw_4)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                throw_4]
              and
              (
                var_14_ws_4_1=(neq[t_22_2,
                   null]=>(true)else(false)) // bug is here (comparison of return value of getNext with null)
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_4]
                )
              )
              and
              TruePred[]
              and
              (
                var_14_ws_4_0=var_14_ws_4_1)
            )
          )
          and
          (
            (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                 throw_4,
                                                                 var_14_ws_4_1]
              and
              TruePred[]
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_4]
                  and
                  (
                    variant_3_1=fun_set_size[fun_reach[var_13_temp_1,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_0]])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_4]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    variant_3_0=variant_3_1)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_4]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                        var_13_temp_1]
                      and
                      getUnusedObject[throw_5,
                                     usedObjects_0,
                                     usedObjects_1]
                      and
                      instanceOf[throw_5,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_5]
                          and
                          (
                            throw_6=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_5])
                          )
                          and
                          java_lang_Throwable_Constructor_0[]
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
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                            var_13_temp_1]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_4=throw_6)
                      and
                      (
                        usedObjects_0=usedObjects_1)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_4]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_0=usedObjects_1)
                  and
                  (
                    throw_4=throw_6)
                )
              )
              and
              TruePred[]
              and
              TruePred[]
              and
              TruePred[]
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_6]
                  and
                  (
                    t_23_1=var_12_count_1)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_6]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    t_23_0=t_23_1)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_6]
                  and
                  (
                    var_12_count_2=add[var_12_count_1,1])
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_6]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_12_count_1=var_12_count_2)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_6]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_1]
                      and
                      (
                        throw_8=java_lang_NullPointerExceptionLit)
                      and
                      (
                        l2_exit_stmt_reached_0=l2_exit_stmt_reached_3)
                      and
                      (
                        t_24_0=t_24_2)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_1])
                      )
                      and
                      realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_1,
                                                             throw_7,
                                                             throw_8,
                                                             t_24_0,
                                                             t_24_1,
                                                             t_24_2,
                                                             realbugs_SinglyLinkedListNode_next_0,
                                                             l2_exit_stmt_reached_1,
                                                             l2_exit_stmt_reached_2,
                                                             l2_exit_stmt_reached_3]
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_6]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    l2_exit_stmt_reached_0=l2_exit_stmt_reached_3)
                  and
                  (
                    t_24_0=t_24_2)
                  and
                  (
                    throw_6=throw_8)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_8]
                  and
                  (
                    var_13_temp_2=t_24_2)
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_8]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_13_temp_1=var_13_temp_2)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_8]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_2]
                      and
                      (
                        throw_10=java_lang_NullPointerExceptionLit)
                      and
                      (
                        t_25_0=t_25_2)
                      and
                      (
                        l3_exit_stmt_reached_0=l3_exit_stmt_reached_3)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_2])
                      )
                      and
                      realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_2,
                                                             throw_9,
                                                             throw_10,
                                                             t_25_0,
                                                             t_25_1,
                                                             t_25_2,
                                                             realbugs_SinglyLinkedListNode_next_0,
                                                             l3_exit_stmt_reached_1,
                                                             l3_exit_stmt_reached_2,
                                                             l3_exit_stmt_reached_3]
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_8]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    t_25_0=t_25_2)
                  and
                  (
                    l3_exit_stmt_reached_0=l3_exit_stmt_reached_3)
                  and
                  (
                    throw_8=throw_10)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_10]
                  and
                  (
                    var_14_ws_4_2=(neq[t_25_2,
                       null]=>(true)else(false)) // bug is here (comparison of return value of getNext with null)
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_10]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    var_14_ws_4_1=var_14_ws_4_2)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_10]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                         var_13_temp_2,
                                                                         variant_3_1]
                      and
                      getUnusedObject[throw_11,
                                     usedObjects_1,
                                     usedObjects_2]
                      and
                      instanceOf[throw_11,
                                java_lang_Object]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_11]
                          and
                          (
                            throw_12=java_lang_NullPointerExceptionLit)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_11])
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
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                             var_13_temp_2,
                                                                             variant_3_1]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        throw_10=throw_12)
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
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_10]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    usedObjects_1=usedObjects_2)
                  and
                  (
                    throw_10=throw_12)
                )
              )
              and
              (
                (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                     throw_12,
                                                                     var_14_ws_4_2]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_12]
                      and
                      (
                        variant_3_2=fun_set_size[fun_reach[var_13_temp_2,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_0]])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_12]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        variant_3_1=variant_3_2)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_12]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                            var_13_temp_2]
                          and
                          getUnusedObject[throw_13,
                                         usedObjects_2,
                                         usedObjects_3]
                          and
                          instanceOf[throw_13,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_13]
                              and
                              (
                                throw_14=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_13])
                              )
                              and
                              java_lang_Throwable_Constructor_0[]
                              and
                              (
                                throw_13=throw_14)
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                                var_13_temp_2]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_12=throw_14)
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
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_12]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_2=usedObjects_3)
                      and
                      (
                        throw_12=throw_14)
                    )
                  )
                  and
                  TruePred[]
                  and
                  TruePred[]
                  and
                  TruePred[]
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_14]
                      and
                      (
                        t_23_2=var_12_count_2)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_14]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_23_1=t_23_2)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_14]
                      and
                      (
                        var_12_count_3=add[var_12_count_2,1])
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_14]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_12_count_2=var_12_count_3)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_14]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_2]
                          and
                          (
                            throw_16=java_lang_NullPointerExceptionLit)
                          and
                          (
                            l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
                          and
                          (
                            t_24_2=t_24_4)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_2])
                          )
                          and
                          realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_2,
                                                                 throw_15,
                                                                 throw_16,
                                                                 t_24_2,
                                                                 t_24_3,
                                                                 t_24_4,
                                                                 realbugs_SinglyLinkedListNode_next_0,
                                                                 l6_exit_stmt_reached_1,
                                                                 l6_exit_stmt_reached_2,
                                                                 l6_exit_stmt_reached_3]
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_14]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
                      and
                      (
                        t_24_2=t_24_4)
                      and
                      (
                        throw_14=throw_16)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_16]
                      and
                      (
                        var_13_temp_3=t_24_4)
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_16]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_13_temp_2=var_13_temp_3)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_16]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_3]
                          and
                          (
                            throw_18=java_lang_NullPointerExceptionLit)
                          and
                          (
                            t_25_2=t_25_4)
                          and
                          (
                            l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_3])
                          )
                          and
                          realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_3,
                                                                 throw_17,
                                                                 throw_18,
                                                                 t_25_2,
                                                                 t_25_3,
                                                                 t_25_4,
                                                                 realbugs_SinglyLinkedListNode_next_0,
                                                                 l7_exit_stmt_reached_1,
                                                                 l7_exit_stmt_reached_2,
                                                                 l7_exit_stmt_reached_3]
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_16]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        t_25_2=t_25_4)
                      and
                      (
                        l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
                      and
                      (
                        throw_16=throw_18)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_18]
                      and
                      (
                        var_14_ws_4_3=(neq[t_25_4,
                           null]=>(true)else(false)) // bug is here (comparison of return value of getNext with null)
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_18]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        var_14_ws_4_2=var_14_ws_4_3)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                        throw_18]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                             var_13_temp_3,
                                                                             variant_3_2]
                          and
                          getUnusedObject[throw_19,
                                         usedObjects_3,
                                         usedObjects_4]
                          and
                          instanceOf[throw_19,
                                    java_lang_Object]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_19]
                              and
                              (
                                throw_20=java_lang_NullPointerExceptionLit)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_19])
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
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                                 var_13_temp_3,
                                                                                 variant_3_2]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            throw_18=throw_20)
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
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_18]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        usedObjects_3=usedObjects_4)
                      and
                      (
                        throw_18=throw_20)
                    )
                  )
                  and
                  (
                    (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                         throw_20,
                                                                         var_14_ws_4_3]
                      and
                      TruePred[]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_20]
                          and
                          (
                            variant_3_3=fun_set_size[fun_reach[var_13_temp_3,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_0]])
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_20]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            variant_3_2=variant_3_3)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_20]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                                var_13_temp_3]
                              and
                              getUnusedObject[throw_21,
                                             usedObjects_4,
                                             usedObjects_5]
                              and
                              instanceOf[throw_21,
                                        java_lang_Object]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_21]
                                  and
                                  (
                                    throw_22=java_lang_NullPointerExceptionLit)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_21])
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
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                                    var_13_temp_3]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                throw_20=throw_22)
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
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_20]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            usedObjects_4=usedObjects_5)
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
                      TruePred[]
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_22]
                          and
                          (
                            t_23_3=var_12_count_3)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_22]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            t_23_2=t_23_3)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_22]
                          and
                          (
                            var_12_count_4=add[var_12_count_3,1])
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_22]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            var_12_count_3=var_12_count_4)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_22]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_3]
                              and
                              (
                                throw_24=java_lang_NullPointerExceptionLit)
                              and
                              (
                                l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
                              and
                              (
                                t_24_4=t_24_6)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_3])
                              )
                              and
                              realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_3,
                                                                     throw_23,
                                                                     throw_24,
                                                                     t_24_4,
                                                                     t_24_5,
                                                                     t_24_6,
                                                                     realbugs_SinglyLinkedListNode_next_0,
                                                                     l10_exit_stmt_reached_1,
                                                                     l10_exit_stmt_reached_2,
                                                                     l10_exit_stmt_reached_3]
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_22]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
                          and
                          (
                            t_24_4=t_24_6)
                          and
                          (
                            throw_22=throw_24)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_24]
                          and
                          (
                            var_13_temp_4=t_24_6)
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_24]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            var_13_temp_3=var_13_temp_4)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_24]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_4]
                              and
                              (
                                throw_26=java_lang_NullPointerExceptionLit)
                              and
                              (
                                t_25_4=t_25_6)
                              and
                              (
                                l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_4])
                              )
                              and
                              realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_4,
                                                                     throw_25,
                                                                     throw_26,
                                                                     t_25_4,
                                                                     t_25_5,
                                                                     t_25_6,
                                                                     realbugs_SinglyLinkedListNode_next_0,
                                                                     l11_exit_stmt_reached_1,
                                                                     l11_exit_stmt_reached_2,
                                                                     l11_exit_stmt_reached_3]
                            )
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_24]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            t_25_4=t_25_6)
                          and
                          (
                            l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
                          and
                          (
                            throw_24=throw_26)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_26]
                          and
                          (
                            var_14_ws_4_4=(neq[t_25_6,
                               null]=>(true)else(false)) // bug is here (comparison of return value of getNext with null)
                          )
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_26]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            var_14_ws_4_3=var_14_ws_4_4)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                            throw_26]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                                 var_13_temp_4,
                                                                                 variant_3_3]
                              and
                              getUnusedObject[throw_27,
                                             usedObjects_5,
                                             usedObjects_6]
                              and
                              instanceOf[throw_27,
                                        java_lang_Object]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_27]
                                  and
                                  (
                                    throw_28=java_lang_NullPointerExceptionLit)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_27])
                                  )
                                  and
                                  java_lang_Throwable_Constructor_0[]
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
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                                     var_13_temp_4,
                                                                                     variant_3_3]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                throw_26=throw_28)
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
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_26]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            usedObjects_5=usedObjects_6)
                          and
                          (
                            throw_26=throw_28)
                        )
                      )
                      and
                      (
                        (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                             throw_28,
                                                                             var_14_ws_4_4]
                          and
                          TruePred[]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_28]
                              and
                              (
                                variant_3_4=fun_set_size[fun_reach[var_13_temp_4,realbugs_SinglyLinkedListNode,realbugs_SinglyLinkedListNode_next_0]])
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_28]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                variant_3_3=variant_3_4)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_28]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                                    var_13_temp_4]
                                  and
                                  getUnusedObject[throw_29,
                                                 usedObjects_6,
                                                 usedObjects_7]
                                  and
                                  instanceOf[throw_29,
                                            java_lang_Object]
                                  and
                                  (
                                    (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_29]
                                      and
                                      (
                                        throw_30=java_lang_NullPointerExceptionLit)
                                    )
                                    or
                                    (
                                      (
                                        not (
                                          realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_29])
                                      )
                                      and
                                      java_lang_Throwable_Constructor_0[]
                                      and
                                      (
                                        throw_29=throw_30)
                                    )
                                  )
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition8[realbugs_SinglyLinkedListNode_next_0,
                                                                                        var_13_temp_4]
                                    )
                                  )
                                  and
                                  TruePred[]
                                  and
                                  (
                                    throw_28=throw_30)
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
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_28]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                usedObjects_6=usedObjects_7)
                              and
                              (
                                throw_28=throw_30)
                            )
                          )
                          and
                          TruePred[]
                          and
                          TruePred[]
                          and
                          TruePred[]
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_30]
                              and
                              (
                                t_23_4=var_12_count_4)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_30]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                t_23_3=t_23_4)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_30]
                              and
                              (
                                var_12_count_5=add[var_12_count_4,1])
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_30]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                var_12_count_4=var_12_count_5)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_30]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_4]
                                  and
                                  (
                                    throw_32=java_lang_NullPointerExceptionLit)
                                  and
                                  (
                                    t_24_6=t_24_8)
                                  and
                                  (
                                    l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_4])
                                  )
                                  and
                                  realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_4,
                                                                         throw_31,
                                                                         throw_32,
                                                                         t_24_6,
                                                                         t_24_7,
                                                                         t_24_8,
                                                                         realbugs_SinglyLinkedListNode_next_0,
                                                                         l14_exit_stmt_reached_1,
                                                                         l14_exit_stmt_reached_2,
                                                                         l14_exit_stmt_reached_3]
                                )
                              )
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_30]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                t_24_6=t_24_8)
                              and
                              (
                                l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
                              and
                              (
                                throw_30=throw_32)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_32]
                              and
                              (
                                var_13_temp_5=t_24_8)
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_32]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                var_13_temp_4=var_13_temp_5)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_32]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_5]
                                  and
                                  (
                                    throw_34=java_lang_NullPointerExceptionLit)
                                  and
                                  (
                                    l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
                                  and
                                  (
                                    t_25_6=t_25_8)
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition4[var_13_temp_5])
                                  )
                                  and
                                  realbugs_SinglyLinkedListNode_getNext_0[var_13_temp_5,
                                                                         throw_33,
                                                                         throw_34,
                                                                         t_25_6,
                                                                         t_25_7,
                                                                         t_25_8,
                                                                         realbugs_SinglyLinkedListNode_next_0,
                                                                         l15_exit_stmt_reached_1,
                                                                         l15_exit_stmt_reached_2,
                                                                         l15_exit_stmt_reached_3]
                                )
                              )
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_32]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
                              and
                              (
                                t_25_6=t_25_8)
                              and
                              (
                                throw_32=throw_34)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_34]
                              and
                              (
                                var_14_ws_4_5=(neq[t_25_8,
                                   null]=>(true)else(false))  // bug is here (comparison of return value of getNext with null)
                              )
                            )
                            or
                            (
                              (
                                not (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_34]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                var_14_ws_4_4=var_14_ws_4_5)
                            )
                          )
                          and
                          (
                            (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                throw_34]
                              and
                              (
                                (
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                                     var_13_temp_5,
                                                                                     variant_3_4]
                                  and
                                  getUnusedObject[throw_35,
                                                 usedObjects_7,
                                                 usedObjects_8]
                                  and
                                  instanceOf[throw_35,
                                            java_lang_Object]
                                  and
                                  (
                                    (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_35]
                                      and
                                      (
                                        throw_36=java_lang_NullPointerExceptionLit)
                                    )
                                    or
                                    (
                                      (
                                        not (
                                          realbugs_SinglyLinkedListCountNodes1Bug7Condition6[throw_35])
                                      )
                                      and
                                      java_lang_Throwable_Constructor_0[]
                                      and
                                      (
                                        throw_35=throw_36)
                                    )
                                  )
                                )
                                or
                                (
                                  (
                                    not (
                                      realbugs_SinglyLinkedListCountNodes1Bug7Condition10[realbugs_SinglyLinkedListNode_next_0,
                                                                                         var_13_temp_5,
                                                                                         variant_3_4]
                                    )
                                  )
                                  and
                                  TruePred[]
                                  and
                                  (
                                    throw_34=throw_36)
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
                                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                                    throw_34]
                                )
                              )
                              and
                              TruePred[]
                              and
                              (
                                usedObjects_7=usedObjects_8)
                              and
                              (
                                throw_34=throw_36)
                            )
                          )
                          and
                          TruePred[]
                        )
                        or
                        (
                          (
                            not (
                              realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                                 throw_28,
                                                                                 var_14_ws_4_4]
                            )
                          )
                          and
                          TruePred[]
                          and
                          (
                            l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
                          and
                          (
                            var_12_count_4=var_12_count_5)
                          and
                          (
                            t_23_3=t_23_4)
                          and
                          (
                            t_24_6=t_24_8)
                          and
                          (
                            t_25_6=t_25_8)
                          and
                          (
                            l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
                          and
                          (
                            var_13_temp_4=var_13_temp_5)
                          and
                          (
                            variant_3_3=variant_3_4)
                          and
                          (
                            usedObjects_6=usedObjects_8)
                          and
                          (
                            throw_28=throw_36)
                          and
                          (
                            var_14_ws_4_4=var_14_ws_4_5)
                        )
                      )
                    )
                    or
                    (
                      (
                        not (
                          realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                             throw_20,
                                                                             var_14_ws_4_3]
                        )
                      )
                      and
                      TruePred[]
                      and
                      (
                        l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
                      and
                      (
                        var_12_count_3=var_12_count_5)
                      and
                      (
                        t_23_2=t_23_4)
                      and
                      (
                        t_24_4=t_24_8)
                      and
                      (
                        t_25_4=t_25_8)
                      and
                      (
                        l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
                      and
                      (
                        l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
                      and
                      (
                        var_13_temp_3=var_13_temp_5)
                      and
                      (
                        variant_3_2=variant_3_4)
                      and
                      (
                        l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
                      and
                      (
                        usedObjects_4=usedObjects_8)
                      and
                      (
                        throw_20=throw_36)
                      and
                      (
                        var_14_ws_4_3=var_14_ws_4_5)
                    )
                  )
                )
                or
                (
                  (
                    not (
                      realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                         throw_12,
                                                                         var_14_ws_4_2]
                    )
                  )
                  and
                  TruePred[]
                  and
                  (
                    l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
                  and
                  (
                    var_12_count_2=var_12_count_5)
                  and
                  (
                    t_23_1=t_23_4)
                  and
                  (
                    l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
                  and
                  (
                    t_24_2=t_24_8)
                  and
                  (
                    t_25_2=t_25_8)
                  and
                  (
                    l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
                  and
                  (
                    l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
                  and
                  (
                    l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
                  and
                  (
                    var_13_temp_2=var_13_temp_5)
                  and
                  (
                    variant_3_1=variant_3_4)
                  and
                  (
                    l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
                  and
                  (
                    usedObjects_2=usedObjects_8)
                  and
                  (
                    throw_12=throw_36)
                  and
                  (
                    var_14_ws_4_2=var_14_ws_4_5)
                )
              )
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                     throw_4,
                                                                     var_14_ws_4_1]
                )
              )
              and
              TruePred[]
              and
              (
                l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
              and
              (
                var_12_count_1=var_12_count_5)
              and
              (
                t_23_0=t_23_4)
              and
              (
                l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
              and
              (
                l2_exit_stmt_reached_0=l2_exit_stmt_reached_3)
              and
              (
                t_24_0=t_24_8)
              and
              (
                t_25_0=t_25_8)
              and
              (
                l3_exit_stmt_reached_0=l3_exit_stmt_reached_3)
              and
              (
                l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
              and
              (
                l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
              and
              (
                l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
              and
              (
                var_13_temp_1=var_13_temp_5)
              and
              (
                variant_3_0=variant_3_4)
              and
              (
                l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
              and
              (
                usedObjects_0=usedObjects_8)
              and
              (
                throw_4=throw_36)
              and
              (
                var_14_ws_4_1=var_14_ws_4_5)
            )
          )
          and
          (
            not (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition12[exit_stmt_reached_1,
                                                                 throw_36,
                                                                 var_14_ws_4_5]
            )
          )
        )
      )
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                            throw_1]
        )
      )
      and
      TruePred[]
      and
      (
        l15_exit_stmt_reached_0=l15_exit_stmt_reached_3)
      and
      (
        l0_exit_stmt_reached_0=l0_exit_stmt_reached_3)
      and
      (
        l6_exit_stmt_reached_0=l6_exit_stmt_reached_3)
      and
      (
        l2_exit_stmt_reached_0=l2_exit_stmt_reached_3)
      and
      (
        l3_exit_stmt_reached_0=l3_exit_stmt_reached_3)
      and
      (
        l14_exit_stmt_reached_0=l14_exit_stmt_reached_3)
      and
      (
        var_14_ws_4_0=var_14_ws_4_5)
      and
      (
        variant_3_0=variant_3_4)
      and
      (
        l11_exit_stmt_reached_0=l11_exit_stmt_reached_3)
      and
      (
        usedObjects_0=usedObjects_8)
      and
      (
        var_12_count_1=var_12_count_5)
      and
      (
        t_23_0=t_23_4)
      and
      (
        t_24_0=t_24_8)
      and
      (
        t_25_0=t_25_8)
      and
      (
        l7_exit_stmt_reached_0=l7_exit_stmt_reached_3)
      and
      (
        t_22_0=t_22_2)
      and
      (
        l10_exit_stmt_reached_0=l10_exit_stmt_reached_3)
      and
      (
        var_13_temp_0=var_13_temp_5)
      and
      (
        throw_1=throw_36)
    )
  )
  and
  (
    (
      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                        throw_36]
      and
      (
        (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition15[]
          and
          (
            (
              realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                throw_36]
              and
              (
                return_1=var_12_count_5)
              and
              (
                exit_stmt_reached_2=true)
            )
            or
            (
              (
                not (
                  realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                                    throw_36]
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
              realbugs_SinglyLinkedListCountNodes1Bug7Condition15[])
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
          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_1,
                                                            throw_36]
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
      realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_2,
                                                        throw_36]
      and
      (
        return_2=0)
      and
      (
        exit_stmt_reached_3=true)
    )
    or
    (
      (
        not (
          realbugs_SinglyLinkedListCountNodes1Bug7Condition0[exit_stmt_reached_2,
                                                            throw_36]
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
one sig realbugs_SinglyLinkedListCountNodes1Bug7_0 extends realbugs_SinglyLinkedListCountNodes1Bug7 {}

one sig realbugs_SinglyLinkedListNode_0, realbugs_SinglyLinkedListNode_1, realbugs_SinglyLinkedListNode_2 extends realbugs_SinglyLinkedListNode {}

one sig java_lang_Object_0, java_lang_Object_1, java_lang_Object_2, java_lang_Object_3, java_lang_Object_4, java_lang_Object_5, java_lang_Object_6, java_lang_Object_7 extends java_lang_Object {}

one sig java_lang_Boolean_0, java_lang_Boolean_1 extends java_lang_Boolean {}

one sig java_io_PrintStream_0 extends java_io_PrintStream {}

fact {
  no ( QF.frealbugs_SinglyLinkedListNode_next_0.univ & QF.brealbugs_SinglyLinkedListNode_next_0.univ ) and
  realbugs_SinglyLinkedListNode = QF.frealbugs_SinglyLinkedListNode_next_0.univ + QF.brealbugs_SinglyLinkedListNode_next_0.univ
}
//-----SMB: local_ordering()-----//
fun next_realbugs_SinglyLinkedListCountNodes1Bug7 [] : realbugs_SinglyLinkedListCountNodes1Bug7 -> lone realbugs_SinglyLinkedListCountNodes1Bug7 {
none -> none
}
fun min_realbugs_SinglyLinkedListCountNodes1Bug7 [os: set realbugs_SinglyLinkedListCountNodes1Bug7] : lone realbugs_SinglyLinkedListCountNodes1Bug7 {
  os - os.^(next_realbugs_SinglyLinkedListCountNodes1Bug7[])
}
fun prevs_realbugs_SinglyLinkedListCountNodes1Bug7[o : realbugs_SinglyLinkedListCountNodes1Bug7] : set realbugs_SinglyLinkedListCountNodes1Bug7 {
  o.^(~next_realbugs_SinglyLinkedListCountNodes1Bug7[])
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
  java_lang_Object_6 -> java_lang_Object_7
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
realbugs_SinglyLinkedListCountNodes1Bug7_0 -> realbugs_SinglyLinkedListNode_0  +  realbugs_SinglyLinkedListNode_0 -> realbugs_SinglyLinkedListNode_1  +  realbugs_SinglyLinkedListNode_1 -> realbugs_SinglyLinkedListNode_2  +  realbugs_SinglyLinkedListNode_2 -> java_lang_Object_0  +  java_lang_Object_0 -> java_lang_Object_1  +  java_lang_Object_1 -> java_lang_Object_2  +  java_lang_Object_2 -> java_lang_Object_3  +  java_lang_Object_3 -> java_lang_Object_4  +  java_lang_Object_4 -> java_lang_Object_5  +  java_lang_Object_5 -> java_lang_Object_6  +  java_lang_Object_6 -> java_lang_Object_7  +  java_lang_Object_7 -> java_lang_Boolean_0  +  java_lang_Boolean_0 -> java_lang_Boolean_1  +  java_lang_Boolean_1 -> java_io_PrintStream_0
}
fun globalMin[s : set java_lang_Object] : lone java_lang_Object {
s - s.^globalNext[]
}
//-----SMB: define_min_parent()-----//
fun minP_realbugs_SinglyLinkedListNode [o : realbugs_SinglyLinkedListNode] : java_lang_Object {
  globalMin[(QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0 + QF.frealbugs_SinglyLinkedListNode_next_0).o]
}
fun minP_java_lang_Object [o : java_lang_Object] : java_lang_Object {
  globalMin[(QF.realbugs_SinglyLinkedListNode_value_0).o]
}
//-----SMB: define_freach()-----//
fun FReach[] : set java_lang_Object {
(QF.thiz_0).*(QF.realbugs_SinglyLinkedListNode_value_0 + QF.booleanValue_0 + QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0 + QF.frealbugs_SinglyLinkedListNode_next_0) - null
}
//-----SMB: order_root_nodes()-----//
//-----SMB: root_is_minimum()-----//
fact {
((QF.thiz_0 != null) implies QF.thiz_0 = realbugs_SinglyLinkedListCountNodes1Bug7_0 )
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
p1 in realbugs_SinglyLinkedListCountNodes1Bug7 and p2 in realbugs_SinglyLinkedListNode )
implies o1 in prevs_realbugs_SinglyLinkedListNode[o2]
}
//-----SMB: avoid_holes()-----//
fact {
 all o : realbugs_SinglyLinkedListCountNodes1Bug7 |
  o in FReach[] implies
   prevs_realbugs_SinglyLinkedListCountNodes1Bug7[o] in FReach[]
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
1) realbugs_SinglyLinkedListCountNodes1Bug7
2) realbugs_SinglyLinkedListNode
3) java_lang_Object
4) java_lang_Boolean
5) java_io_PrintStream

root nodes ordering:
====================
1) thiz:realbugs_SinglyLinkedListCountNodes1Bug7

recursive field ordering:
=========================
1) realbugs_SinglyLinkedListNode_next:(realbugs_SinglyLinkedListNode)->one(null+realbugs_SinglyLinkedListNode)

non-recursive field ordering:
=============================
1) realbugs_SinglyLinkedListCountNodes1Bug7_header:(realbugs_SinglyLinkedListCountNodes1Bug7)->one(null+realbugs_SinglyLinkedListNode)
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
  l17_l0_exit_stmt_reached_2:boolean,
  l17_l0_exit_stmt_reached_3:boolean,
  l17_l10_exit_stmt_reached_0:boolean,
  l17_l10_exit_stmt_reached_1:boolean,
  l17_l10_exit_stmt_reached_2:boolean,
  l17_l10_exit_stmt_reached_3:boolean,
  l17_l11_exit_stmt_reached_0:boolean,
  l17_l11_exit_stmt_reached_1:boolean,
  l17_l11_exit_stmt_reached_2:boolean,
  l17_l11_exit_stmt_reached_3:boolean,
  l17_l14_exit_stmt_reached_0:boolean,
  l17_l14_exit_stmt_reached_1:boolean,
  l17_l14_exit_stmt_reached_2:boolean,
  l17_l14_exit_stmt_reached_3:boolean,
  l17_l15_exit_stmt_reached_0:boolean,
  l17_l15_exit_stmt_reached_1:boolean,
  l17_l15_exit_stmt_reached_2:boolean,
  l17_l15_exit_stmt_reached_3:boolean,
  l17_l2_exit_stmt_reached_0:boolean,
  l17_l2_exit_stmt_reached_1:boolean,
  l17_l2_exit_stmt_reached_2:boolean,
  l17_l2_exit_stmt_reached_3:boolean,
  l17_l3_exit_stmt_reached_0:boolean,
  l17_l3_exit_stmt_reached_1:boolean,
  l17_l3_exit_stmt_reached_2:boolean,
  l17_l3_exit_stmt_reached_3:boolean,
  l17_l6_exit_stmt_reached_0:boolean,
  l17_l6_exit_stmt_reached_1:boolean,
  l17_l6_exit_stmt_reached_2:boolean,
  l17_l6_exit_stmt_reached_3:boolean,
  l17_l7_exit_stmt_reached_0:boolean,
  l17_l7_exit_stmt_reached_1:boolean,
  l17_l7_exit_stmt_reached_2:boolean,
  l17_l7_exit_stmt_reached_3:boolean,
  l17_t_22_0:null + realbugs_SinglyLinkedListNode,
  l17_t_22_1:null + realbugs_SinglyLinkedListNode,
  l17_t_22_2:null + realbugs_SinglyLinkedListNode,
  l17_t_23_0:Int,
  l17_t_23_1:Int,
  l17_t_23_2:Int,
  l17_t_23_3:Int,
  l17_t_23_4:Int,
  l17_t_24_0:null + realbugs_SinglyLinkedListNode,
  l17_t_24_1:null + realbugs_SinglyLinkedListNode,
  l17_t_24_2:null + realbugs_SinglyLinkedListNode,
  l17_t_24_3:null + realbugs_SinglyLinkedListNode,
  l17_t_24_4:null + realbugs_SinglyLinkedListNode,
  l17_t_24_5:null + realbugs_SinglyLinkedListNode,
  l17_t_24_6:null + realbugs_SinglyLinkedListNode,
  l17_t_24_7:null + realbugs_SinglyLinkedListNode,
  l17_t_24_8:null + realbugs_SinglyLinkedListNode,
  l17_t_25_0:null + realbugs_SinglyLinkedListNode,
  l17_t_25_1:null + realbugs_SinglyLinkedListNode,
  l17_t_25_2:null + realbugs_SinglyLinkedListNode,
  l17_t_25_3:null + realbugs_SinglyLinkedListNode,
  l17_t_25_4:null + realbugs_SinglyLinkedListNode,
  l17_t_25_5:null + realbugs_SinglyLinkedListNode,
  l17_t_25_6:null + realbugs_SinglyLinkedListNode,
  l17_t_25_7:null + realbugs_SinglyLinkedListNode,
  l17_t_25_8:null + realbugs_SinglyLinkedListNode,
  l17_t_26_0:boolean,
  l17_t_26_1:boolean,
  l17_var_12_count_0:Int,
  l17_var_12_count_1:Int,
  l17_var_12_count_2:Int,
  l17_var_12_count_3:Int,
  l17_var_12_count_4:Int,
  l17_var_12_count_5:Int,
  l17_var_13_temp_0:null + realbugs_SinglyLinkedListNode,
  l17_var_13_temp_1:null + realbugs_SinglyLinkedListNode,
  l17_var_13_temp_2:null + realbugs_SinglyLinkedListNode,
  l17_var_13_temp_3:null + realbugs_SinglyLinkedListNode,
  l17_var_13_temp_4:null + realbugs_SinglyLinkedListNode,
  l17_var_13_temp_5:null + realbugs_SinglyLinkedListNode,
  l17_var_14_ws_4_0:boolean,
  l17_var_14_ws_4_1:boolean,
  l17_var_14_ws_4_2:boolean,
  l17_var_14_ws_4_3:boolean,
  l17_var_14_ws_4_4:boolean,
  l17_var_14_ws_4_5:boolean,
  l17_variant_3_0:Int,
  l17_variant_3_1:Int,
  l17_variant_3_2:Int,
  l17_variant_3_3:Int,
  l17_variant_3_4:Int,
  realbugs_SinglyLinkedListCountNodes1Bug7_header_0:( realbugs_SinglyLinkedListCountNodes1Bug7 ) -> one ( null + realbugs_SinglyLinkedListNode ),
  realbugs_SinglyLinkedListNode_value_0:( realbugs_SinglyLinkedListNode ) -> one ( java_lang_Object + null ),
  return_0:Int,
  return_1:Int,
  return_2:Int,
  thiz_0:realbugs_SinglyLinkedListCountNodes1Bug7,
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
  throw_4:java_lang_Throwable + null,
  throw_5:java_lang_Throwable + null,
  throw_6:java_lang_Throwable + null,
  throw_7:java_lang_Throwable + null,
  throw_8:java_lang_Throwable + null,
  throw_9:java_lang_Throwable + null,
  usedObjects_0:set ( java_lang_Object ),
  usedObjects_1:set ( java_lang_Object ),
  usedObjects_2:set ( java_lang_Object ),
  usedObjects_3:set ( java_lang_Object ),
  usedObjects_4:set ( java_lang_Object ),
  usedObjects_5:set ( java_lang_Object ),
  usedObjects_6:set ( java_lang_Object ),
  usedObjects_7:set ( java_lang_Object ),
  usedObjects_8:set ( java_lang_Object )
}


fact {
  precondition_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[QF.booleanValue_0,
                                                                    QF.java_lang_Boolean_FALSE_0,
                                                                    QF.java_lang_Boolean_TRUE_0,
                                                                    QF.java_lang_System_out_0,
                                                                    QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0,
                                                                    (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                    QF.realbugs_SinglyLinkedListNode_value_0,
                                                                    QF.return_0,
                                                                    QF.thiz_0,
                                                                    QF.throw_0,
                                                                    QF.usedObjects_0]

}

fact {
  realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[QF.thiz_0,
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
                                                       QF.return_0,
                                                       QF.return_1,
                                                       QF.return_2,
                                                       (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                       QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0,
                                                       QF.usedObjects_0,
                                                       QF.usedObjects_1,
                                                       QF.usedObjects_2,
                                                       QF.usedObjects_3,
                                                       QF.usedObjects_4,
                                                       QF.usedObjects_5,
                                                       QF.usedObjects_6,
                                                       QF.usedObjects_7,
                                                       QF.usedObjects_8,
                                                       QF.l17_exit_stmt_reached_1,
                                                       QF.l17_exit_stmt_reached_2,
                                                       QF.l17_exit_stmt_reached_3,
                                                       QF.l17_var_13_temp_0,
                                                       QF.l17_var_13_temp_1,
                                                       QF.l17_var_13_temp_2,
                                                       QF.l17_var_13_temp_3,
                                                       QF.l17_var_13_temp_4,
                                                       QF.l17_var_13_temp_5,
                                                       QF.l17_var_14_ws_4_0,
                                                       QF.l17_var_14_ws_4_1,
                                                       QF.l17_var_14_ws_4_2,
                                                       QF.l17_var_14_ws_4_3,
                                                       QF.l17_var_14_ws_4_4,
                                                       QF.l17_var_14_ws_4_5,
                                                       QF.l17_var_12_count_0,
                                                       QF.l17_var_12_count_1,
                                                       QF.l17_var_12_count_2,
                                                       QF.l17_var_12_count_3,
                                                       QF.l17_var_12_count_4,
                                                       QF.l17_var_12_count_5,
                                                       QF.l17_variant_3_0,
                                                       QF.l17_variant_3_1,
                                                       QF.l17_variant_3_2,
                                                       QF.l17_variant_3_3,
                                                       QF.l17_variant_3_4,
                                                       QF.l17_t_24_0,
                                                       QF.l17_t_24_1,
                                                       QF.l17_t_24_2,
                                                       QF.l17_t_24_3,
                                                       QF.l17_t_24_4,
                                                       QF.l17_t_24_5,
                                                       QF.l17_t_24_6,
                                                       QF.l17_t_24_7,
                                                       QF.l17_t_24_8,
                                                       QF.l17_t_25_0,
                                                       QF.l17_t_25_1,
                                                       QF.l17_t_25_2,
                                                       QF.l17_t_25_3,
                                                       QF.l17_t_25_4,
                                                       QF.l17_t_25_5,
                                                       QF.l17_t_25_6,
                                                       QF.l17_t_25_7,
                                                       QF.l17_t_25_8,
                                                       QF.l17_t_26_0,
                                                       QF.l17_t_26_1,
                                                       QF.l17_t_22_0,
                                                       QF.l17_t_22_1,
                                                       QF.l17_t_22_2,
                                                       QF.l17_t_23_0,
                                                       QF.l17_t_23_1,
                                                       QF.l17_t_23_2,
                                                       QF.l17_t_23_3,
                                                       QF.l17_t_23_4,
                                                       QF.l17_l15_exit_stmt_reached_0,
                                                       QF.l17_l15_exit_stmt_reached_1,
                                                       QF.l17_l15_exit_stmt_reached_2,
                                                       QF.l17_l15_exit_stmt_reached_3,
                                                       QF.l17_l0_exit_stmt_reached_0,
                                                       QF.l17_l0_exit_stmt_reached_1,
                                                       QF.l17_l0_exit_stmt_reached_2,
                                                       QF.l17_l0_exit_stmt_reached_3,
                                                       QF.l17_l6_exit_stmt_reached_0,
                                                       QF.l17_l6_exit_stmt_reached_1,
                                                       QF.l17_l6_exit_stmt_reached_2,
                                                       QF.l17_l6_exit_stmt_reached_3,
                                                       QF.l17_l2_exit_stmt_reached_0,
                                                       QF.l17_l2_exit_stmt_reached_1,
                                                       QF.l17_l2_exit_stmt_reached_2,
                                                       QF.l17_l2_exit_stmt_reached_3,
                                                       QF.l17_l3_exit_stmt_reached_0,
                                                       QF.l17_l3_exit_stmt_reached_1,
                                                       QF.l17_l3_exit_stmt_reached_2,
                                                       QF.l17_l3_exit_stmt_reached_3,
                                                       QF.l17_l14_exit_stmt_reached_0,
                                                       QF.l17_l14_exit_stmt_reached_1,
                                                       QF.l17_l14_exit_stmt_reached_2,
                                                       QF.l17_l14_exit_stmt_reached_3,
                                                       QF.l17_l11_exit_stmt_reached_0,
                                                       QF.l17_l11_exit_stmt_reached_1,
                                                       QF.l17_l11_exit_stmt_reached_2,
                                                       QF.l17_l11_exit_stmt_reached_3,
                                                       QF.l17_l7_exit_stmt_reached_0,
                                                       QF.l17_l7_exit_stmt_reached_1,
                                                       QF.l17_l7_exit_stmt_reached_2,
                                                       QF.l17_l7_exit_stmt_reached_3,
                                                       QF.l17_l10_exit_stmt_reached_0,
                                                       QF.l17_l10_exit_stmt_reached_1,
                                                       QF.l17_l10_exit_stmt_reached_2,
                                                       QF.l17_l10_exit_stmt_reached_3]

}

assert repair_assert_0{
  postcondition_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0,
                                                                     (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                     QF.return_2,
                                                                     QF.thiz_0,
                                                                     QF.throw_36]
}

check repair_assert_0  for 0 but  exactly 3 realbugs_SinglyLinkedListNode, 15 java_lang_Object, exactly 1 realbugs_SinglyLinkedListCountNodes1Bug7, exactly 2 java_lang_Boolean, exactly 1 java_io_PrintStream,4 int

pred repair_pred_0{
  postcondition_realbugs_SinglyLinkedListCountNodes1Bug7_countNodes_0[QF.realbugs_SinglyLinkedListCountNodes1Bug7_header_0,
                                                                     (QF.brealbugs_SinglyLinkedListNode_next_0)+(QF.frealbugs_SinglyLinkedListNode_next_0),
                                                                     QF.return_2,
                                                                     QF.thiz_0,
                                                                     QF.throw_36]
}
run repair_pred_0  for 0 but  exactly 3 realbugs_SinglyLinkedListNode, 15 java_lang_Object, exactly 1 realbugs_SinglyLinkedListCountNodes1Bug7, exactly 2 java_lang_Boolean, exactly 1 java_io_PrintStream,4 int
