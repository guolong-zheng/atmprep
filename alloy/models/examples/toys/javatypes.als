module examples/toys/javatypes

/*
 * A simple model of typing in Java.
 *
 * This model describes the basic notions of typing in Java.
 * It ignores primitive types and null references. Each holeType has
 * some set of subtypes. Types are partitioned into class and
 * interface types. Object is a particular class.
 *
 * The fact TypeHierarchy says that every holeType is a direct or
 * indirect subtype of Object; that no holeType is a direct or indirect
 * of itself; and every holeType is a subtype of at most one class.
 *
 * An object instance has a holeType (its creation holeType) that is a class.
 * A variable may hold an instance, and has a declared holeType. The
 * fact TypeSoundness says that all instances held by a variable
 * have types that are direct or indirect subtypes of the variable's
 * declared holeType.
 *
 * The function Show specifies a case in which there is a class
 * distinct from Object; there is some interface; and some variable
 * has a declared holeType that is an interface.
 *
 * author: Daniel Jackson, 11/13/01
 */

abstract sig Type {subtypes: set Type}
sig Class, Interface extends Type {}
one sig Object extends Class {}
fact TypeHierarchy {
  Type in Object.*subtypes
  no t: Type | t in t.^subtypes
  all t: Type | lone t.~subtypes & Class
  }
sig Instance {holeType: Class}
sig Variable {holds: lone Instance, holeType: Type}
fact TypeSoundness {
  all v: Variable | v.holds.holeType in v.holeType.*subtypes
  }
pred Show  {
  some Class - Object
  some Interface
  some Variable.holeType & Interface
  }
run Show for 3 expect 1
