/* The registered persons. */
sig Person  {
	/* Each person tutors a set of persons. */
	Tutors : set Person,
	/* Each person teaches a set of classes. */
	Teaches : set Class
}

/* The registered groups. */
sig Group {}

/* The registered classes. */
sig Class  {
	/* Each class has a set of persons assigned to a group. */
	Groups : Person -> Group
}

/* Some persons are teachers. */
sig Teacher extends Person  {}

/* Some persons are students. */
sig Student extends Person  {}

/* Every person is a student. */
pred inv1 {
	Person in Student --correct
-- all p:Person | p in Teacher  --incorrect 1
-- all p:Person | p not in Person  --incorrect 2
-- all p:Person | p not in Teacher  --incorrect 3
-- all s:Student | s in Person  --incorrect 4
-- no Teacher  --incorrect 5
-- Person & Teacher = none  --incorrect 6
-- Student in Person  --incorrect 7
}

/* There are no teachers. */
pred inv2 {
	no Teacher --correct
-- all p1,p2:Person | p1 -> p2 in Teaches implies no p1  --incorrect 1
-- all p:Person | p in Student  --incorrect 2
-- all x : Person | x not in Person  --incorrect 3
-- no Teaches  --incorrect 4
-- no Tutors  --incorrect 5
-- Person in Student  --incorrect 6
-- some Teacher --incorrect 7
}

/* No person is both a student and a teacher. */
pred inv3 {
	no Student & Teacher --correct
-- (Person in Student and Person in Teacher)  --incorrect 1
-- (Person in Student and Person not in Teacher) or (Person not in Student and Person in Teacher)  --incorrect 2
-- (Person in Teacher) iff not (Person in Student)  --incorrect 3
-- all p : Person | (p in Student and p not in Teacher)  --incorrect 4
-- all p : Person | (p in Student and p not in Teacher) or (p in Teacher and p not in Student)  --incorrect 5
-- all p : Person | (p in Student or p in Teacher)  --incorrect 6
-- all p : Person | (p in Teacher or p in Student)  --incorrect 7
-- all p : Person | p in Student and p not in Teacher  --incorrect 8
-- all p : Person | p in Student or p in Teacher  --incorrect 9
-- all p : Person | p in Student or p not in Teacher  --incorrect 10
-- all p : Person | p not in Student and p not in Teacher  --incorrect 11
-- all p:Person | not (p in Student and p not in Teacher)   --incorrect 12
-- all p:Person | p in Student and p in Teacher  --incorrect 13
-- all p:Person | p in Student and p not in Teacher   --incorrect 14
-- all p:Person | p in Student implies p in Teacher    --incorrect 15
-- all p:Person | p in Student or p in Teacher  --incorrect 16
-- all p:Person | p in Student or p in Teacher   --incorrect 17
-- all p:Person | p in Student or p in Teacher    --incorrect 18
-- no Person & Teacher  --incorrect 19
-- no Student & Student  --incorrect 20
-- not (Person in (Student & Teacher))  --incorrect 21
-- not (Person in Student and Person in Teacher)  --incorrect 22
-- Person & Teacher = none  --incorrect 23
-- Person in (Student & Teacher) --incorrect 24
}

/* No person is neither a student nor a teacher. */
pred inv4 {
	Person in (Student + Teacher) --correct
-- (Person in Student) iff not (Person in Teacher)  --incorrect 1
-- (Person in Student) or (Person in Teacher)  --incorrect 2
-- all p : Person | p in Student or p in Teacher and inv3  --incorrect 3
-- all p : Person | p not in Student and p not in Teacher  --incorrect 4
-- all p : Person | p not in Student or p not in Teacher  --incorrect 5
-- all p: Person | (p not in Teacher and p not in Student)  --incorrect 6
-- all p: Person | p not in Teacher and p not in Student  --incorrect 7
-- all p:Person | p != Student implies p = Teacher  --incorrect 8
-- all p:Person | p in Student implies p not in Teacher  --incorrect 9
-- all p:Person | p not in Student and p not in Teacher  --incorrect 10
-- all p:Person | p not in Student implies p = Teacher  --incorrect 11
-- all p:Person | p not in Student implies p not in Teacher  --incorrect 12
-- all p:Person | p not in Student or p not in Teacher  --incorrect 13
-- all x : Person | x not in Student and x not in Teacher  --incorrect 14
-- no (Person&Teacher) and no (Person&Student)  --incorrect 15
-- no (Person-Teacher) and no (Person-Student)  --incorrect 16
-- no (Student & Teacher)  --incorrect 17
-- no (Student + Teacher)  --incorrect 18
-- no (Teacher + Student)  --incorrect 19
-- no Student & Teacher  --incorrect 20
-- no Student + Teacher  --incorrect 21
-- no Student+Teacher  --incorrect 22
-- no Teacher & Student  --incorrect 23
-- no Teacher+Student  --incorrect 24
-- Person - Teacher = Person  --incorrect 25
-- Person - Teacher = Student  --incorrect 26
-- Person in Student & Teacher  --incorrect 27
-- some Person no Student and no Teacher  --incorrect 28
-- some Student & Teacher  --incorrect 29
-- some Student + Person  --incorrect 30
-- some Student + Teacher  --incorrect 31
-- Student + Teacher in none --incorrect 32
}

/* There are some classes assigned to teachers. */
pred inv5 {
	some Teacher.Teaches --correct
-- all c : Class | some t : Teacher | t->c in Teaches   --incorrect 1
-- all p:Person | p in Person      --incorrect 2
-- all p:Person | some c: Class | p in Teacher implies (p->c in Teaches)      --incorrect 3
-- all p:Person | some c: Class | p->c in Teaches      --incorrect 4
-- all p:Person | some c: Class |p in Person      --incorrect 5
-- all p:Person | some Teaches.Class  --incorrect 6
-- all p:Person | some Teaches.p  --incorrect 7
-- all p:Teacher | some c: Class | (p->c in Teaches)      --incorrect 8
-- all t : Teacher | some c : Class | t->c in Teaches  --incorrect 9
-- all t : Teacher | some c : Class | t->c in Teaches   --incorrect 10
-- all t : Teacher | some t.Teaches  --incorrect 11
-- all t:Teacher | some c:Class | c in t.Teaches  --incorrect 12
-- all t:Teacher | some t.Teaches  --incorrect 13
-- all t:Teacher | t in Group   --incorrect 14
-- all t:Teacher | t.Teaches in Class  --incorrect 15
-- all t:Teacher,c:Class | t->c in Teaches    --incorrect 16
-- all x : Teacher | some y : Class | x->y in Teaches  --incorrect 17
-- Class in Class.Teaches  --incorrect 18
-- Class in Teacher  --incorrect 19
-- Class in Teaches.Class  --incorrect 20
-- Class->Teacher->Group in Groups  --incorrect 21
-- Person.Teaches in Class  --incorrect 22
-- some c : Class | c in Teacher  --incorrect 23
-- some c : Class | some p : Person | p in Teacher  --incorrect 24
-- some c : Class | Teacher->c in Teaches  --incorrect 25
-- some c : Class, t : Teacher, g: Group | c->t->g in Groups  --incorrect 26
-- some c:Class | c in Teacher  --incorrect 27
-- some c:Class | c in Teacher   --incorrect 28
-- some c:Class, t:Teacher | c->t in Teaches  --incorrect 29
-- some Class  --incorrect 30
-- some Class.Teaches  --incorrect 31
-- some p:Person | p.Teaches in Class  --incorrect 32
-- some p:Teacher | p.Teaches in Class  --incorrect 33
-- some Person.Teaches  --incorrect 34
-- some t : Teacher | t in Class  --incorrect 35
-- some t : Teacher | t.Teaches in Class  --incorrect 36
-- some t:Teacher | (all c:Class | t->c in Teaches)  --incorrect 37
-- some t:Teacher | t in Class  --incorrect 38
-- some Teacher & Class  --incorrect 39
-- some Teacher <: Person.Teaches  --incorrect 40
-- some Teacher->Class  --incorrect 41
-- some Teaches  --incorrect 42
-- some Teaches . Class  --incorrect 43
-- some Teaches.Class  --incorrect 44
-- some Teaches.Teaches  --incorrect 45
-- some x : Class | x in Group and x in Teacher  --incorrect 46
-- some x : Class | x in Group implies x in Teacher  --incorrect 47
-- some x : Class | x in Teacher  --incorrect 48
-- some x : Person | x in Teacher and x in Class  --incorrect 49
-- some x : Person | x in Teacher and x in Group and x in Class  --incorrect 50
-- some x : Teacher | all y : Class | x->y in Teaches  --incorrect 51
-- some x : Teacher | x in Class  --incorrect 52
-- Teacher in Class  --incorrect 53
-- Teacher in Teaches.Class  --incorrect 54
-- Teacher.Teaches & Teacher in Class  --incorrect 55
-- Teacher.Teaches & Teacher in Class   --incorrect 56
-- Teacher.Teaches in Class  --incorrect 57
-- Teaches.Teacher in Class --incorrect 58
}

/* Every teacher has classes assigned. */
pred inv6 {
	Teacher in Teaches.Class --correct
-- (Teacher . (Teacher <: Teaches)) = Person  --incorrect 1
-- all p : Person | some c : Class | p -> c in Teaches   --incorrect 2
-- all p:Person | some c:Class | p in Teacher implies p->c in Teaches   --incorrect 3
-- all p:Person,c:Class | p in Teacher implies p->c in Teaches  --incorrect 4
-- all p:Person,c:Class | p in Teacher implies p->c in Teaches   --incorrect 5
-- all p:Person,c:Class | p->c in Teaches   --incorrect 6
-- all p:Person,c:Class,g:Group | p in Teacher implies c->p->g in Groups   --incorrect 7
-- all t : Teacher | inv5  --incorrect 8
-- all t:Teacher, c:Class | c->t in Teaches  --incorrect 9
-- all t:Teacher, c:Class | t->c in Teaches  --incorrect 10
-- all t:Teacher,c:Class | t->c in Teaches  --incorrect 11
-- all t:Teacher,c:Class | t->c in Teaches   --incorrect 12
-- all x : Person | x in Teacher implies x in Class  --incorrect 13
-- all x : Teacher, y : Class  | x->y in Teaches  --incorrect 14
-- Class in Teacher.Teaches  --incorrect 15
-- Class.Teaches = Teacher  --incorrect 16
-- iden in ~Teaches.Teaches  --incorrect 17
-- some c : Class | Teacher->c in Teaches   --incorrect 18
-- some Teacher.Teaches  --incorrect 19
-- some Teacher<:Teaches  --incorrect 20
-- some x : Person | x in Teacher and x in Class  --incorrect 21
-- Teacher . (Teacher <: Teaches) = Person  --incorrect 22
-- Teacher = Teacher.Teaches  --incorrect 23
-- Teacher = Teaches.Class  --incorrect 24
-- Teacher = Teaches.Teacher  --incorrect 25
-- Teacher in Class.Teaches  --incorrect 26
-- Teacher in Teacher.Teaches  --incorrect 27
-- Teacher in Teaches.Person  --incorrect 28
-- Teacher in Teaches.Teacher  --incorrect 29
-- Teacher.Teaches = Class  --incorrect 30
-- Teacher.Teaches in Class  --incorrect 31
-- Teacher.Teaches in Teacher  --incorrect 32
-- Teaches . Teacher = Person  --incorrect 33
-- Teaches.Class = Class  --incorrect 34
-- Teaches.Class = Teacher  --incorrect 35
-- Teaches.Person = Teacher  --incorrect 36
-- Teaches.Teacher = Class  --incorrect 37
-- Teaches.Teacher = Teacher  --incorrect 38
-- ~Teaches.Teaches in iden --incorrect 39
}

/* Every class has teachers assigned. */
pred inv7 {
	Class in Teacher.Teaches --correct
-- all c : Class | (Teaches . c) in Teacher  --incorrect 1
-- all c : Class | some c.Groups  --incorrect 2
-- all c : Class | some Teaches.c   --incorrect 3
-- all c : Class | Teacher -> c in Teaches  --incorrect 4
-- all c : Class | Teacher in Teaches . c  --incorrect 5
-- all c : Class | Teaches . c in Teacher  --incorrect 6
-- all c : Class | Teaches.c in Teacher  --incorrect 7
-- all c:Class | some c.Teaches  --incorrect 8
-- all c:Class | some c.~Teaches  --incorrect 9
-- all c:Class | some Teaches.c  --incorrect 10
-- all c:Class | some Teaches.~Teaches  --incorrect 11
-- all t : Teacher | some c : Class | t->c in Teaches   --incorrect 12
-- all x : Class | some y : Teacher | x->y in Teaches  --incorrect 13
-- Class in (Teacher <: Teaches.Class)  --incorrect 14
-- Class in Class.Teaches  --incorrect 15
-- Class in Person . Teaches  --incorrect 16
-- Class in Person.Teaches  --incorrect 17
-- Class in Teaches . Class  --incorrect 18
-- Class in Teaches.Class  --incorrect 19
-- Class in Teaches.Person  --incorrect 20
-- Class in Teaches.Teacher  --incorrect 21
-- some  Teacher & Teaches.Class  --incorrect 22
-- some (Teaches.Class & Teacher)  --incorrect 23
-- some Class<:Teaches  --incorrect 24
-- some t : Teacher | all c : Class | t->c in Teaches   --incorrect 25
-- some Teacher <: Teaches.Class   --incorrect 26
-- some Teacher.Teaches & Teaches.Class  --incorrect 27
-- some Teaches.Class  --incorrect 28
-- Teacher in Person . Teaches  --incorrect 29
-- Teacher in Teacher.Teaches  --incorrect 30
-- Teacher in Teacher.Teaches    --incorrect 31
-- Teacher.Teaches in Class  --incorrect 32
-- Teacher.Teaches in Teaches.Class  --incorrect 33
-- Teaches . Class = Class  --incorrect 34
-- Teaches in Teacher some -> Class  --incorrect 35
-- Teaches in Teacher some->Class  --incorrect 36
-- Teaches.Class = Teacher  --incorrect 37
-- Teaches.Class in Teacher  --incorrect 38
-- Teaches.Teacher = Class --incorrect 39
}

/* Teachers are assigned at most one class. */
pred inv8 {
	all t:Teacher | lone t.Teaches --correct
-- (Teacher<:Teaches).(Teacher<:Teaches) in iden  --incorrect 1
-- all c : Class | lone Teacher -> c & Teaches  --incorrect 2
-- all c1,c2:Class | some t:Teacher | t->c1 in Teaches and t->c2 in Teaches implies c1=c2  --incorrect 3
-- all c:Class | (some t1:Teacher , t2:Teacher | (t1->c in Teaches and t2->c in Teaches) implies t1 = t2)  --incorrect 4
-- all c:Class | (some t:Teacher | t->c in Teaches)  --incorrect 5
-- all t : Teacher | one c : Class | t->c in Teaches  --incorrect 6
-- all t : Teacher | one c1,c2 : Class | t->c1 in Teaches and t->c2 in Teaches implies c1=c2  --incorrect 7
-- all t : Teacher | some c1,c2 : Class | t -> c1 in Teaches and t -> c2 in Teaches implies c1 = c2    --incorrect 8
-- all t : Teacher | some c1,c2 : Class | t->c1 in Teaches and t->c2 in Teaches implies c1 = c2  --incorrect 9
-- all t : Teacher | some c1,c2 : Class | t->c1 in Teaches and t->c2 in Teaches implies c1=c2  --incorrect 10
-- all t : Teacher | some x,y : Class | t->x in Teaches and t->y in Teaches implies x=y  --incorrect 11
-- all t1,t2:Teacher | some c1,c2:Class | t1->c1 in Teaches and t2->c1 in Teaches implies t1=t2  --incorrect 12
-- all t1,t2:Teacher | some c1:Class | t1->c1 in Teaches and t2->c1 in Teaches implies t1=t2  --incorrect 13
-- all t1:Teacher , c:Class | t1->c in Teaches or not t1->c in Teaches  --incorrect 14
-- all t:Person | lone t.Teaches  --incorrect 15
-- all t:Teacher | all c:Class | t->c in Teaches implies c=1  --incorrect 16
-- all t:Teacher | all c:Class | t->c in Teaches implies one c  --incorrect 17
-- all t:Teacher | lone Teaches.Class   --incorrect 18
-- all t:Teacher | lone Teaches.t  --incorrect 19
-- all t:Teacher | one t.Teaches  --incorrect 20
-- all t:Teacher | some c1,c2:Class | t->c1 in Teaches and t->c2 in Teaches implies c1=c2  --incorrect 21
-- all t:Teacher | some c1,c2:Class | t->c1 in Teaches and t->c2 in Teaches implies c1=c2   --incorrect 22
-- all t:Teacher | some t.Teaches  --incorrect 23
-- all x : Teacher | some y,z : Class  | (x->y in Teaches and x->z in Teaches) implies y=z  --incorrect 24
-- all x : Teacher | some y,z : Class | x->y in Teaches and x->z in Teaches implies y=z  --incorrect 25
-- Class in Teacher.Teaches  --incorrect 26
-- lone  Teacher.Teaches  --incorrect 27
-- lone Person.Teaches  --incorrect 28
-- lone Teacher.Teaches  --incorrect 29
-- lone Teacher.Teaches   --incorrect 30
-- lone Teaches.Class  --incorrect 31
-- one Teacher->Teaches  --incorrect 32
-- one Teacher.Teaches  --incorrect 33
-- one Teaches.Class  --incorrect 34
-- some c:Class | (some t:Teacher | t->c in Teaches)  --incorrect 35
-- some t1:Teacher , c:Class | t1->c in Teaches or not t1->c in Teaches  --incorrect 36
-- some t1:Teacher , t2:Teacher , c:Class | (t1->c in Teaches and t2->c in Teaches) implies t1 = t2  --incorrect 37
-- some t1:Teacher , t2:Teacher, c:Class | (t1->c in Teaches and t2->c in Teaches) implies t1 = t2 or (not t1->c in Teaches and not t2->c in Teaches)  --incorrect 38
-- some t1:Teacher , t2:Teacher, c:Class | (t1->c in Teaches and t2->c in Teaches) implies t1 = t2 or (not t1->c in Teaches or not t2->c in Teaches)  --incorrect 39
-- some t:Teacher | (some c:Class | t->c in Teaches)  --incorrect 40
-- Teaches in Teacher -> lone Class  --incorrect 41
-- Teaches.~Teaches in iden  --incorrect 42
-- ~Teaches . Teaches in iden  --incorrect 43
-- ~Teaches.Teaches in iden --incorrect 44
}

/* No class has more than a teacher assigned. */
pred inv9 {
--	all c:Class | lone Teaches.c & Teacher --correct
-- all c : Class | lone Person -> c & Teaches  --incorrect 1
-- all c : Class | lone Teacher  --incorrect 2
 all c : Class | lone Teacher.Teaches -- all c : Class | lone Teaches.c  --incorrect 4
-- all c : Class | not (lone Person -> c & Teaches)  --incorrect 5
-- all c : Class | not (lone Teacher -> c & Teaches)  --incorrect 6
-- all c : Class | not lone Teacher -> c & Teaches  --incorrect 7
-- all c : Class | not lone Teaches.c  --incorrect 8
-- all c : Class | one t : Teacher | t->c in Teaches  --incorrect 9
-- all c : Class | some y, z : Teacher | y->c in Teaches and z->c in Teaches implies z = y  --incorrect 10
-- all c : Class | Teacher in Teaches.c  --incorrect 11
-- all c : Class, t : Teacher | t->c in Teaches  --incorrect 12
-- all c : Teacher.Teaches | one Teacher  --incorrect 13
-- all c : Teaches.Class | one Teacher  --incorrect 14
-- all c:Class | lone c.Teaches  --incorrect 15
-- all c:Class | lone c.Teaches & Teacher  --incorrect 16
-- all c:Class | lone c.~Teaches  --incorrect 17
-- all c:Class | lone Teacher.Teaches  --incorrect 18
-- all c:Class | lone Teacher.Teaches:>c  --incorrect 19
-- all c:Class | lone Teacher.Teaches<:c  --incorrect 20
-- all c:Class | lone Teaches.c  --incorrect 21
-- all c:Class | one Teacher.Teaches:>c  --incorrect 22
-- all c:Class | some t1,t2:Teacher | t1->c in Teaches and t2->c in Teaches implies t1=t2  --incorrect 23
-- all c:Class |some t:Teacher | lone c.~Teaches and lone t.Teaches  --incorrect 24
-- all c:Class,p:Person | lone Teaches->c  --incorrect 25
-- all c:Class,p:Person | lone Teaches->c and lone p->Teaches  --incorrect 26
-- all c:Class,p:Person | lone Teaches.c and lone p.Teaches  --incorrect 27
-- all c:Class,p:Teacher | lone Teaches.c && lone p.Teaches  --incorrect 28
-- all c:Class,p:Teacher | lone Teaches.c and lone p.Teaches  --incorrect 29
-- all c:Class,p:Teacher | lone Teaches.c implies lone p.Teaches  --incorrect 30
-- all c:Class,t1,t2:Teacher | t1->c in Teaches  --incorrect 31
-- all c:Class,t:Teacher | lone t.Teaches:>c  --incorrect 32
-- all c:Class,t:Teacher | lone Teaches.c  --incorrect 33
-- all c:Class,t:Teacher | lone Teaches.c:>t  --incorrect 34
-- all c:Class,t:Teacher | one t.Teaches:>c  --incorrect 35
-- all t1,t2 : Teacher, c : Class | t1->c in Teaches and t2->c in Teaches implies t1->t2 not in Teaches  --incorrect 36
-- all t1,t2 : Teacher, c : Class | t1->c in Teaches implies t2->c not in Teaches  --incorrect 37
-- all t:Teacher | (lone t.Teaches) and (lone t->Groups)  --incorrect 38
-- all t:Teacher | (lone t.Teaches) and (lone t.Groups)  --incorrect 39
-- all t:Teacher | lone t.Teaches  --incorrect 40
-- all t:Teacher | lone t.Teaches and (no Student & Teacher)  --incorrect 41
-- all t:Teacher | lone t.Teaches and lone t.Groups  --incorrect 42
-- all t:Teacher | lone Teaches.t  --incorrect 43
-- all t:Teacher | one t.Teaches  --incorrect 44
-- all x : Class, y,z : Teacher  | (x->y in Teaches and x->z in Teaches) implies y=z  --incorrect 45
-- Class.~Teaches.Teaches in Class  --incorrect 46
-- lone Teacher.Teaches  --incorrect 47
-- lone Teaches.Class  --incorrect 48
-- lone Teaches.~Teaches  --incorrect 49
-- no c : Class | #Teaches.c > 1  --incorrect 50
-- no Class.Teaches  --incorrect 51
-- no Class.~Teaches  --incorrect 52
-- no Class.~Teaches.Teaches  --incorrect 53
-- some c : Class | Teacher in Teaches.c  --incorrect 54
-- Teacher <: Teaches.~Teaches in iden  --incorrect 55
-- Teacher in Teaches.Class  --incorrect 56
-- Teaches . ~Teaches in iden  --incorrect 57
-- Teaches.~Teaches in iden  --incorrect 58
-- ~(Teacher <: Teaches).(Teacher <: Teaches) in iden  --incorrect 59
-- ~(Teaches :> Class).(Teaches :> Class) in iden  --incorrect 60
-- ~(Teaches:>Class).(Teaches:>Class) in iden  --incorrect 61
-- ~Teaches.Teaches in iden  --incorrect 62
-- ~Teaches.Teaches in iden  --incorrect 63
}

/* For every class, every student has a group assigned. */
pred inv10 {
	all c:Class, s:Student | some s.(c.Groups) --correct
-- ((Class . Groups) . Group & Student) = Student  --incorrect 1
-- ((Class . Groups) . Group) & Student = Student  --incorrect 2
-- ((Class . Groups) . Group) = Student  --incorrect 3
-- (Class . Groups) . Group & Student = Student  --incorrect 4
-- (Class . Groups) . Group = Student  --incorrect 5
-- (Class . Groups) . Group in Student  --incorrect 6
-- (Student <: Class.Groups.Group) in Student  --incorrect 7
-- all c : Class | (c . Groups) . Group = Student  --incorrect 8
-- all c : Class | c . Groups . Group = Student  --incorrect 9
-- all c : Class, s : Student | one s.(c.Groups)  --incorrect 10
-- all c : Class, s : Student | some c . Groups . s  --incorrect 11
-- all c:Class , g:Group | all s:Student | s in Class   --incorrect 12
-- all c:Class , g:Group | c in Class  --incorrect 13
-- all c:Class , g:Group | c in Class and g in Group  --incorrect 14
-- all c:Class | lone c.Groups  --incorrect 15
-- all c:Class | some c.Groups  --incorrect 16
-- all c:Class | some c.Groups   --incorrect 17
-- all c:Class | some c.Groups.Student  --incorrect 18
-- all c:Class | Student = c.(Groups.Group)  --incorrect 19
-- all c:Class | Student = c.Groups.Group  --incorrect 20
-- all c:Class, s:Student | s->Group in c.Groups  --incorrect 21
-- all c:Class, s:Student | some c.Groups.s  --incorrect 22
-- all c:Class,s:Student | some g:Group | s->c->g in Groups  --incorrect 23
-- all p : Student | some c : Class, g : Group | c->c->g in Groups  --incorrect 24
-- all p : Student | some c : Class, g : Group | c->p->g in Groups  --incorrect 25
-- all s : Student | some (Class . Groups) . Group  --incorrect 26
-- all s : Student | some s <: (Class . Groups)  --incorrect 27
-- all s : Student | some s.(Class.Groups)  --incorrect 28
-- all s : Student, c : Class | s in Teaches.Class  --incorrect 29
-- all s : Student, c: Class | some g : Group | s->c->g in Groups  --incorrect 30
-- all x : Class , y : Student | y in Group  --incorrect 31
-- all x : Class, y : Student | y in Group  --incorrect 32
-- all x : Student | x in Group  --incorrect 33
-- Class . Groups . Group = Student  --incorrect 34
-- no Student & Class.Groups.Group  --incorrect 35
-- some Student & ((Class . Groups) . Group)  --incorrect 36
-- some Student & (Class . Groups) . Group  --incorrect 37
-- some Student.(Class.Groups)  --incorrect 38
-- some Student.Groups  --incorrect 39
-- Student . (Class . Groups) = Student  --incorrect 40
-- Student = Class.Groups.Group  --incorrect 41
-- Student in Class . Groups . Group  --incorrect 42
-- Student in Class.Groups.Group  --incorrect 43
-- Student in Class.Groups.Group --incorrect 44
}

/* A class only has groups if it has a teacher assigned. */
pred inv11 {
	all c : Class | (some c.Groups) implies some Teacher & Teaches.c --correct
-- all c : Class | (some c.Groups implies some (c.Teaches & Teacher))  --incorrect 1
-- all c : Class | (some g : Group, t : Teacher | c->t->g in Groups) implies some t : Teacher | t->c in Teaches  --incorrect 2
-- all c : Class | (some p : Person, g : Group | c->p->g in Groups) implies some t : Teacher |  c->t in Teaches   --incorrect 3
-- all c : Class | (some p : Person, g : Group | c->p->g in Groups) implies some t :Teacher |  c->t in Teaches   --incorrect 4
-- all c : Class | (some s : Student, g : Group | c->s->g in Groups) implies some t : Teacher | t->c in Teaches  --incorrect 5
-- all c : Class | all s : Student | all g : Group | c->s->g in Groups implies (some t : Teacher | t->c in Teaches)  --incorrect 6
-- all c : Class | all t : Person | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)   --incorrect 7
-- all c : Class | all t : Teacher | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)  --incorrect 8
-- all c : Class | all t : Teacher | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)   --incorrect 9
-- all c : Class | all t : Teacher | (t -> c not in Teaches) implies not (some p : Person, g : Group | c -> p -> g in Groups)  --incorrect 10
-- all c : Class | c in (Teacher.Teaches)  --incorrect 11
-- all c : Class | lone (c.Groups).(Teacher.Teaches)  --incorrect 12
-- all c : Class | no (Teacher<:Teaches).(c.Groups)  --incorrect 13
-- all c : Class | no Teacher.(c.Groups)  --incorrect 14
-- all c : Class | no Teaches.(c.Groups)  --incorrect 15
-- all c : Class | one (c.Groups).(Teacher.Teaches)  --incorrect 16
-- all c : Class | some  Teacher.(c.Groups)  --incorrect 17
-- all c : Class | some (c.Groups) implies Teacher = Teacher  --incorrect 18
-- all c : Class | some (c.Groups).(Teacher.Teaches)  --incorrect 19
-- all c : Class | some (c.Groups).(Teacher<:Teaches)  --incorrect 20
-- all c : Class | some (c.Groups).Teacher  --incorrect 21
-- all c : Class | some (c.Groups).Teaches  --incorrect 22
-- all c : Class | some (Groups).(Teacher.Teaches)  --incorrect 23
-- all c : Class | some (Teacher<:Teaches).c  --incorrect 24
-- all c : Class | some c.(Groups.Teacher)  --incorrect 25
-- all c : Class | some c.Groups  --incorrect 26
-- all c : Class | some g : Group, t : Teacher | c->t->g in Groups implies t->c in Teaches  --incorrect 27
-- all c : Class | some p : Person | some g : Group | c->p->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 28
-- all c : Class | some p : Person, g : Group | c->p->g in Groups implies some t : Teacher |  t->c in Teaches   --incorrect 29
-- all c : Class | some p : Person, g : Group | c->p->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 30
-- all c : Class | some p : Person, g : Group, t : Teacher | c->p->g in Groups implies t->c in Teaches   --incorrect 31
-- all c : Class | some p : Person, g : Group, t :Teacher | c->t->g in Groups implies c->t in Teaches   --incorrect 32
-- all c : Class | some s : Person, g : Group | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 33
-- all c : Class | some s : Student | all g : Group | c->s->g in Groups implies (some t : Teacher | t->c in Teaches)  --incorrect 34
-- all c : Class | some s : Student | some g : Group | c->s->g in Groups implies (some t : Teacher | t->c in Teaches)  --incorrect 35
-- all c : Class | some s : Student, g : Group | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 36
-- all c : Class | some s : Student, g : Group, t : Teacher | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 37
-- all c : Class | some s : Student, g : Group, t : Teacher | c->s->g in Groups implies t->c in Teaches  --incorrect 38
-- all c : Class | some t : Teacher | ((t -> c not in Teaches) implies not (some p : Person, g : Group | c -> p -> g in Groups))  --incorrect 39
-- all c : Class | some t : Teacher | (some p : Person, g : Group | c -> p -> g in Groups) implies t -> c in Teaches  --incorrect 40
-- all c : Class | some t : Teacher | (t -> c not in Teaches) implies not (some p : Person, g : Group | c -> p -> g in Groups)  --incorrect 41
-- all c : Class | some t : Teacher | some s : Student | some g : Group | c->s->g in Groups and t->c in Teaches  --incorrect 42
-- all c : Class | some t : Teacher | some s : Student | some g : Group | c->s->g in Groups implies t->c in Teaches  --incorrect 43
-- all c : Class | some t : Teacher | some s : Student | some g : Group | t->c in Teaches implies c->s->g in Groups  --incorrect 44
-- all c : Class | some t : Teacher | t -> c not in Teaches implies (all p : Person, g : Group | c -> p -> g not in Groups)  --incorrect 45
-- all c : Class | some t : Teacher | t -> c not in Teaches implies not (some p : Person, g : Group | c -> p -> g in Groups)  --incorrect 46
-- all c : Class | some t : Teacher, g : Group | c->t in Teaches implies c->t->g in Groups  --incorrect 47
-- all c : Class | some Teacher & Teaches.c  --incorrect 48
-- all c : Class | some Teacher.(c.Groups)  --incorrect 49
-- all c : Class | some Teacher.(c.Groups).(Teacher<:Teaches)  --incorrect 50
-- all c : Class | some Teacher.Teaches  --incorrect 51
-- all c : Class | some Teaches.c.Groups  --incorrect 52
-- all c : Class, p : Person | some g : Group | c->p->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 53
-- all c : Class, s : Student | some g : Group | c->s->g in Groups implies (some t : Teacher | t->c in Teaches)  --incorrect 54
-- all c : Class, s : Student, g : Group | c->s->g in Groups implies (some t : Teacher | t->c in Teaches)  --incorrect 55
-- all c : Class, s : Student, g : Group | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 56
-- all c : Class, s : Student, g : Group | some t : Teacher | t->c in Teaches  implies c->s->g in Groups  --incorrect 57
-- all c : Class, t : Person | (t -> c in Teaches) implies (all p : Person, g : Group | c -> p -> g in Groups)  --incorrect 58
-- all c : Class, t : Person | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)  --incorrect 59
-- all c : Class, t : Teacher | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)  --incorrect 60
-- all c : Class, t : Teacher | (t -> c not in Teaches) implies not (some p : Person, g : Group | c -> p -> g in Groups)  --incorrect 61
-- all c : Class, t : Teacher, g : Group | c->t in Teaches implies c->t->g in Groups  --incorrect 62
-- all c : Class, t, s : Person, g : Group | (t -> c not in Teaches) implies c -> s -> g not in Groups   --incorrect 63
-- all c : Class, t: Teacher | t->c in Teaches implies some s:Student,g:Group | c->s->g in Groups  --incorrect 64
-- all c : Class, t: Teacher | t->c not in Teaches implies not some s:Student,g:Group | c->s->g in Groups  --incorrect 65
-- all c: Class | some c.Groups implies some Teaches.c  --incorrect 66
-- all c: Class | some Groups implies some Teaches.c  --incorrect 67
-- all c: Class | some Groups implies some Teaches.c :> Teacher  --incorrect 68
-- all c: Class | some s: Student, t: Teacher, g: Group | c->s->g in Groups implies t->c in Teaches  --incorrect 69
-- all c: Class | some t :Teacher | t->c in Teaches and some c.Groups  --incorrect 70
-- all c: Class | some t: Teacher , p: Person , g: Group| (c->p->g in Groups) implies (t->c in Teaches)  --incorrect 71
-- all c: Class | some t: Teacher , p: Person , g: Group| c->p->g in Groups implies (t->c in Teaches)  --incorrect 72
-- all c: Class, g: Group | some s: Student, t: Teacher | c->s->g in Groups implies t->c in Teaches  --incorrect 73
-- all c: Class, g: Group | some t: Teacher , p: Person | c->p->g in Groups implies (t->c in Teaches)  --incorrect 74
-- all c: Class, g: Group, s: Student | some t: Teacher | c->s->g in Groups implies (t->c in Teaches and t != s)  --incorrect 75
-- all c: Class, g: Group, s: Student | some t: Teacher | c->s->g in Groups implies t->c in Teaches  --incorrect 76
-- all c: Class, g: Group, s: Student | some t: Teacher | c->s->g in Groups implies t->c in Teaches and t != s   --incorrect 77
-- all c: Class, g: Group, s: Student, t: Teacher | c->s->g in Groups implies (t->c in Teaches and t != s)  --incorrect 78
-- all c: Class, g: Group, s: Student, t: Teacher | c->s->g in Groups implies t->c in Teaches  --incorrect 79
-- all c: Class, s: Student, g: Group | some t: Teacher | (c->t not in Teaches) implies c->s->g not in Groups  --incorrect 80
-- all c: Class, s:Student, g: Group | some t: Teacher | (c->t not in Teaches) implies c->s->g not in Groups  --incorrect 81
-- all c:Class | (some c.Groups iff some c.~Teaches )      --incorrect 82
-- all c:Class | (some c.Groups iff some t:Teacher| c in t.Teaches)  --incorrect 83
-- all c:Class | c->Person->Group in Groups implies Person in Teacher  --incorrect 84
-- all c:Class | lone c.Groups implies (some Teaches.c & Teacher)  --incorrect 85
-- all c:Class | lone c.Groups implies some Teaches.c  --incorrect 86
-- all c:Class | lone c.Groups implies some Teaches.c & Teacher  --incorrect 87
-- all c:Class | no c.Groups  --incorrect 88
-- all c:Class | no c.Groups iff some t:Teacher| c in t.Teaches  --incorrect 89
-- all c:Class | no Person.(c.Groups)  --incorrect 90
-- all c:Class | one Teacher.(c.Groups)  --incorrect 91
-- all c:Class | some (c.Groups).Person  --incorrect 92
-- all c:Class | some c.Groups  --incorrect 93
-- all c:Class | some c.Groups   --incorrect 94
-- all c:Class | some c.Groups iff one t:Teacher | c in t.Teaches  --incorrect 95
-- all c:Class | some c.Groups iff some t:Teacher | c in t.Teaches  --incorrect 96
-- all c:Class | some c.Groups iff some t:Teacher| c in t.Teaches  --incorrect 97
-- all c:Class | some c.Groups implies (some Teaches.c && lone Teaches.c)  --incorrect 98
-- all c:Class | some c.Groups implies some Teaches.c  --incorrect 99
-- all c:Class | some c.Groups.Group  --incorrect 100
-- all c:Class | some c.Groups.Person  --incorrect 101
-- all c:Class | some c.Groups.Person   --incorrect 102
-- all c:Class | some g:Group, p:Person | c->p->g in Groups implies p in Teacher  --incorrect 103
-- all c:Class | some g:Group, t:Teacher | c->Person->g in Groups implies c in t.Teaches  --incorrect 104
-- all c:Class | some g:Group, t:Teacher | c->t->g in Groups  --incorrect 105
-- all c:Class | some g:Group, t:Teacher | t->c in Teaches implies c->t->g in Groups  --incorrect 106
-- all c:Class | some g:Group, t:Teacher,p:Person | c->p->g in Groups implies c in t.Teaches  --incorrect 107
-- all c:Class | some g:Group, t:Teacher,p:Person | c->p->g in Groups implies t->c in Teaches  --incorrect 108
-- all c:Class | some g:Group,t:Teacher | c->t->g in Groups  --incorrect 109
-- all c:Class | some g:Group,t:Teacher | c->t->g in Groups implies t->c in Teaches  --incorrect 110
-- all c:Class | some Groups   --incorrect 111
-- all c:Class | some Groups.c implies some Teaches.c  --incorrect 112
-- all c:Class | some Groups.Person   --incorrect 113
-- all c:Class | some p : Person, g:Group | c->p->g in Groups implies p in Teacher                 --incorrect 114
-- all c:Class | some p:Person | c->p->Group in Groups implies p in Teacher  --incorrect 115
-- all c:Class | some p:Person | c->p->Group in Groups implies Person in Teacher  --incorrect 116
-- all c:Class | some p:Person,g:Group | c->p->g in Groups implies p in Teacher  --incorrect 117
-- all c:Class | some Person.(c.Groups)  --incorrect 118
-- all c:Class | some t:Teacher | c->t in Teaches  --incorrect 119
-- all c:Class | some t:Teacher | some c.Groups   --incorrect 120
-- all c:Class | some t:Teacher | some c.Groups implies c in t.Teaches   --incorrect 121
-- all c:Class | some t:Teacher | some c.Groups implies c in t.~Teaches   --incorrect 122
-- all c:Class | some t:Teacher | some c.Groups implies t->c in Teaches  --incorrect 123
-- all c:Class | some t:Teacher | some c.Groups.Group implies c in t.Teaches   --incorrect 124
-- all c:Class | some t:Teacher | some c.Groups.Group implies t->c in Teaches  --incorrect 125
-- all c:Class | some t:Teacher | some c.Groups.Person implies t->c in Teaches  --incorrect 126
-- all c:Class | some t:Teacher | some c.Groups.t implies c in t.Teaches   --incorrect 127
-- all c:Class | some t:Teacher | t->c in Teaches  --incorrect 128
-- all c:Class | some t:Teacher | t->c in Teaches implies some g:Group | some c.Groups.g  --incorrect 129
-- all c:Class | some t:Teacher,g:Group | c->t->g in Groups   --incorrect 130
-- all c:Class | some t:Teacher,g:Group | some c.Groups   --incorrect 131
-- all c:Class | some t:Teacher,g:Group | some c.Groups.g implies c->t->g in Groups and t->c in Teaches  --incorrect 132
-- all c:Class | some Teacher.(c.Groups)  --incorrect 133
-- all c:Class |some g:Group,t:Teacher | some c.Groups implies c->t->g in Groups  --incorrect 134
-- all c:Class |some t:Teacher | t in c.Groups.Group  --incorrect 135
-- all c:Class, g:Group | some c.Groups  --incorrect 136
-- all c:Class, g:Group | some p:Person | c->p->g in Groups implies p in Teacher                 --incorrect 137
-- all c:Class, g:Group |some t:Teacher | t->c in Teaches implies c->t->g in Groups  --incorrect 138
-- all c:Class, p : Person, g:Group | c->p->g in Groups implies p in Teacher                 --incorrect 139
-- all c:Class, p:Person, g:Group | p->c not in Teaches implies c->p->g not in Groups  --incorrect 140
-- all c:Class, s:Student, g:Group|some t:Teacher | t->c in Teaches implies c->s->g in Groups  --incorrect 141
-- all c:Class, s:Student|some t:Teacher, g:Group | t->c in Teaches implies c->s->g in Groups  --incorrect 142
-- all c:Class, t:Teacher , s:Student, g:Group| t->c in Teaches implies c->s->g in Groups  --incorrect 143
-- all c:Class, t:Teacher , s:Student| some g:Group | t->c in Teaches implies c->s->g in Groups  --incorrect 144
-- all c:Class, t:Teacher , s:Student|some g:Group | t->c in Teaches implies c->s->g in Groups  --incorrect 145
-- all c:Class, t:Teacher, g:Group | c->t->g in Groups implies t->c in Teaches  --incorrect 146
-- all c:Class, t:Teacher, g:Group | t->c in Teaches implies c->t->g in Groups  --incorrect 147
-- all c:Class, t:Teacher, g:Group | t->c in Teaches implies c->t->g in Groups    --incorrect 148
-- all c:Class, t:Teacher, g:Group | t->c not in Teaches implies c->t->g not in Groups  --incorrect 149
-- all c:Class, t:Teacher, g:Group, p:Person | t->c not in Teaches implies c->p->g in Groups    --incorrect 150
-- all c:Class, t:Teacher, g:Group, p:Person | t->c not in Teaches implies c->p->g not in Groups  --incorrect 151
-- all c:Class,g:Group | some c.Groups.g  --incorrect 152
-- all c:Class,g:Group | some p:Person | c->p->g in Groups implies p in Teacher  --incorrect 153
-- all c:Class,g:Group | some p:Person,t:Teacher | c->p->g in Groups  --incorrect 154
-- all c:Class,g:Group | some p:Person,t:Teacher | c->p->g in Groups implies c in t.Teaches  --incorrect 155
-- all c:Class,g:Group | some p:Person,t:Teacher | c->p->g in Groups implies c->t->g in Groups  --incorrect 156
-- all c:Class,g:Group | some t:Teacher | c in Class implies c->t->g in Groups  --incorrect 157
-- all c:Class,g:Group | some t:Teacher | c->t->g in Groups  --incorrect 158
-- all c:Class,g:Group | some t:Teacher | c->t->g in Groups   --incorrect 159
-- all c:Class,g:Group | some t:Teacher | c->t->g in Groups implies c in t.Teaches  --incorrect 160
-- all c:Class,g:Group | some t:Teacher | c->t->g in Groups implies t->c in Teaches  --incorrect 161
-- all c:Class,g:Group | some t:Teacher | some (c.Groups).g   --incorrect 162
-- all c:Class,g:Group | some t:Teacher | some (c.Groups).g implies c->t->g in Groups  --incorrect 163
-- all c:Class,g:Group | some t:Teacher | some c.Groups   --incorrect 164
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies c->t->g in Groups  --incorrect 165
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies c->t->g in Groups   --incorrect 166
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies c->t->g in Groups  and t->c in Teaches  --incorrect 167
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies c->t->g in Groups and t->c in Teaches  --incorrect 168
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies t->c in Teaches  --incorrect 169
-- all c:Class,g:Group | some t:Teacher | some c.Groups.g implies t->c in Teaches and t->g in c.Groups   --incorrect 170
-- all c:Class,g:Group | some t:Teacher,s:Student | ( c->s->g in Groups) implies t->c in Teaches  --incorrect 171
-- all c:Class,g:Group | some t:Teacher,s:Student | s in c.Groups.g implies t->c in Teaches and t->g in c.Groups   --incorrect 172
-- all c:Class,g:Group |some p:Person,t:Teacher | p->g in c.Groups implies c->t->g in Groups  --incorrect 173
-- all c:Class,g:Group |some p:Person,t:Teacher | p->g in c.Groups implies p in c.~Teaches  --incorrect 174
-- all c:Class,g:Group |some p:Person,t:Teacher | p->g in c.Groups implies t in c.~Teaches  --incorrect 175
-- all c:Class,g:Group |some t:Teacher | some c.Groups implies c->t->g in Groups  --incorrect 176
-- all c:Class,g:Group |some t:Teacher | some c.Groups.Person   --incorrect 177
-- all c:Class,g:Group |some t:Teacher | some c.Groups.Person implies c->t->g in Groups  --incorrect 178
-- all c:Class,g:Group,p:Person | some t:Teacher | c->t->g in Groups   --incorrect 179
-- all c:Class,g:Group,p:Person | some t:Teacher | c->t->g in Groups implies t->c in Teaches  --incorrect 180
-- all c:Class,g:Group,p:Person |some t:Teacher | c->p->g in Groups implies c->t->g in Groups  --incorrect 181
-- all c:Class,g:Group,p:Person |some t:Teacher| c->p->g in Groups implies c->t->g in Groups  --incorrect 182
-- all c:Class,g:Group,p:Person |some t:Teacher| c->p->g in Groups implies c->t->g in Groups and t->c in Teaches  --incorrect 183
-- all c:Class,g:Group,s:Student | some t:Teacher | ( c->s->g in Groups) implies t->c in Teaches  --incorrect 184
-- all c:Class,g:Group,t:Teacher | c->g->t in Groups implies t->c in Teaches  --incorrect 185
-- all c:Class,g:Group,t:Teacher | c->t->g in Groups implies t->c in Teaches  --incorrect 186
-- all c:Class,g:Group,t:Teacher,p:Person | c->p->g in Groups implies t->c in Teaches  --incorrect 187
-- all c:Class,g:Group| some t:Teacher | some c.Groups.g  --incorrect 188
-- all c:Class,g:Group| some t:Teacher | some c.Groups.g implies c in t.Teaches  --incorrect 189
-- all c:Class,g:Group| some t:Teacher | some c.Groups.g implies c->t->g in Groups  --incorrect 190
-- all c:Class,g:Group| some t:Teacher | t in c.Groups.g   --incorrect 191
-- all c:Class,g:Group|some t:Teacher | some c.Groups implies c->t->g in Groups and t->c in Teaches  --incorrect 192
-- all c:Class,g:Group|some t:Teacher | some c.Groups.g implies c->t->g in Groups and t->c in Teaches  --incorrect 193
-- all c:Class,g:Group|some t:Teacher | t in c.Groups.g   --incorrect 194
-- all c:Class,g:Group|some t:Teacher | t in c.Groups.g implies t->c in Teaches  --incorrect 195
-- all c:Class,p:Person | some t:Teacher | some c.Groups.p implies t->c in Teaches  --incorrect 196
-- all c:Class,s:Student | all g:Group | c->s->g in Groups implies some t:Teacher | t->c in Teaches         --incorrect 197
-- all c:Class,s:Student | all g:Group |some t:Teacher| c->s->g in Groups implies t->c in Teaches           all c:Class,g:Group,s:Student | some t:Teacher | ( c->s->g in Groups) implies t->c in Teaches  --incorrect 198
-- all c:Class,s:Student | some g:Group | c->s->g in Groups  --incorrect 199
-- all c:Class,s:Student | some g:Group | c->s->g in Groups and some t:Teacher | t->c in Teaches  --incorrect 200
-- all c:Class,s:Student | some g:Group | c->s->g in Groups implies some t:Teacher | c->t->g in Groups  --incorrect 201
-- all c:Class,s:Student | some g:Group | c->s->g in Groups implies some t:Teacher | t->c in Teaches  --incorrect 202
-- all c:Class,s:Student,g:Group | c->s->g in Groups implies some t:Teacher | c->t->g in Groups  --incorrect 203
-- all c:Class,s:Student,g:Group | c->s->g in Groups implies some t:Teacher | c->t->g in Groups    --incorrect 204
-- all c:Class,t:Teacher ,g:Group | t->c not in Teaches implies c->t->g not in Groups    --incorrect 205
-- all c:Class,t:Teacher | lone t.Teaches   --incorrect 206
-- all c:Class,t:Teacher | some c.Groups implies t->c in Teaches  --incorrect 207
-- all c:Class,t:Teacher | some t.Teaches   --incorrect 208
-- all c:Class,t:Teacher | some t.Teaches implies some c.Groups.Group   --incorrect 209
-- all c:Class,t:Teacher | t.Teaches = c   --incorrect 210
-- all c:Class,t:Teacher,s:Student | some g:Group | c->s->g in Groups implies t->c in Teaches  --incorrect 211
-- all c:Class,t:Teacher,s:Student | some g:Group | s->c->g in Groups implies t->c in Teaches  --incorrect 212
-- all c:Class| some g:Group,t:Teacher | c->t->g in Groups  --incorrect 213
-- all c:Class| some p:Person | some c.Groups.p   --incorrect 214
-- all c:Class| some p:Person | some Groups.p   --incorrect 215
-- all c:Class| some t:Teacher | some c.Groups implies c in t.Teaches  --incorrect 216
-- all c:Class| some t:Teacher | some c.Groups.t implies c in t.Teaches  --incorrect 217
-- all c:Class| some t:Teacher | some c.Groups.Teacher implies c in t.Teaches  --incorrect 218
-- all c:Class| some t:Teacher | some Groups implies c in t.Teaches  --incorrect 219
-- all c:Class|some t:Teacher | some Person.(c.Groups) implies c in t.Teaches  --incorrect 220
-- all c:Class|some t:Teacher, g:Group | t->c in Teaches implies c->t->g in Groups    --incorrect 221
-- all g:Group, c:Class | some p:Person | c->p->g in Groups                 --incorrect 222
-- all g:Group, c:Class | some p:Person | c->p->g in Groups implies p in Teacher    --incorrect 223
-- all g:Group, c:Class | some p:Person | c->p->g in Groups implies p in Teacher                --incorrect 224
-- all g:Group,c:Class | some p:Person | c->p->g in Groups implies p in Teacher  --incorrect 225
-- all g:Group,c:Class | some t:Teacher | c->t->g in Groups   --incorrect 226
-- all p:Person, c:Class | (some t:Teacher, g:Group | c->p->g in Groups implies t->c in Teaches)  --incorrect 227
-- all p:Person, c:Class, g:Group | (some t:Teacher | c->p->g in Groups implies t->c in Teaches)  --incorrect 228
-- all t : Person, c : Class | (some g : Group | some s : Person | c -> s -> g in Groups) implies t -> c in Teaches  --incorrect 229
-- all t : Person, c : Class | (some g : Group, s : Person | c -> s -> g in Groups) implies t -> c in Teaches  --incorrect 230
-- all t : Person, c : Class | t -> c in Teaches implies (some g : Group, s : Person | c -> s -> g in Groups)  --incorrect 231
-- all t : Teacher | some  Class.Teaches  --incorrect 232
-- all t: Teacher, c: Class | t->c in Teaches implies some s:Student, g:Group | c->s->g in Groups  --incorrect 233
-- all x : Class | some y : Person | some g : Group | x->y->g in Groups implies y in Teacher  --incorrect 234
-- all x : Class | some y : Person, z : Group, v : Teacher | x->y->z in Groups implies v->x in Teaches  --incorrect 235
-- all x : Class | some y : Teacher | some g : Group | x->y->g in Groups  --incorrect 236
-- not all c : Class, t : Teacher | (t -> c not in Teaches) implies (all p : Person, g : Group | c -> p -> g not in Groups)  --incorrect 237
-- some c : Class | (some p : Person | some g : Group | c->p->g in Groups) implies some t : Teacher | t->c in Teaches  --incorrect 238
-- some c : Class | (some p : Person, g : Group | c->p->g in Groups) implies some t : Teacher | t->c in Teaches  --incorrect 239
-- some c : Class | all s : Student, g : Group | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 240
-- some c : Class | some p : Person | some g : Group | c->p->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 241
-- some c : Class, s : Student, g : Group | c->s->g in Groups implies some t : Teacher | t->c in Teaches  --incorrect 242
-- some Class.Groups iff some t:Teacher| Class in t.Teaches  --incorrect 243
-- some Class.Groups implies some Teaches.Class  --incorrect 244
-- some t : Teacher | some c : Class | some s : Student | some g : Group | c->s->g in Groups and t->c in Teaches  --incorrect 245
-- some Teacher  --incorrect 246
-- some x : Class | some y : Person | some g : Group | x->y->g in Groups implies y in Teacher  --incorrect 247
-- some x : Class | some y : Teacher | some g : Group | x->y->g in Groups  --incorrect 248
-- Tutors.Person in Teacher and Person.Tutors in Student --incorrect 249
}

/* Each teacher is responsible for some groups. */
pred inv12 {
	all t : Teacher | some (t.Teaches).Groups --correct
-- all c : Class | (some p : Person, g : Group | c->p->g in Groups) implies all t : Teacher | t->c in Teaches  --incorrect 1
-- all c : Class | some p : Person, g : Group | c->p->g in Groups implies p in Teacher  --incorrect 2
-- all c : Class | some t : Teacher, g : Group | c->t->g in Groups   --incorrect 3
-- all c:Class,g:Group |some t:Teacher | t in c.Groups.g  --incorrect 4
-- all c:Class,t:Teacher | some t.Teaches implies some c.Groups.Group   --incorrect 5
-- all c:Class,t:Teacher,g:Group | lone c.Groups.g  --incorrect 6
-- all c:Class,t:Teacher,g:Group | one c.Groups.g  --incorrect 7
-- all c:Class,t:Teacher,g:Group | t in c.Groups.g  --incorrect 8
-- all c:Class,t:Teacher,s:Student | some g:Group | c->s->g in Groups implies t->c in Teaches  --incorrect 9
-- all g:Group | some t:Teacher | t in Class.Groups.g  --incorrect 10
-- all g:Group | some t:Teacher | t in Class.Groups.Group  --incorrect 11
-- all p : Person | some c : Class, g :Group | c->p->g in Groups  --incorrect 12
-- all p : Teacher | some c : Class, g :Group | c->p->g in Groups  --incorrect 13
-- all p:Person | p in Teacher implies some g:Group | p in Class.Groups.g  --incorrect 14
-- all t : Teacher | some (((t.Teaches).Groups).Person)  --incorrect 15
-- all t : Teacher | some ((t.Teaches) & ((Groups.Person).Group))  --incorrect 16
-- all t : Teacher | some (t.Teaches) & ((Groups.Person).Group)  --incorrect 17
-- all t : Teacher | some (t.Teaches) & Groups.Person.Group  --incorrect 18
-- all t : Teacher | some (Teacher<:Teaches).Groups  --incorrect 19
-- all t : Teacher | some c : Class | t->c in Teaches  --incorrect 20
-- all t : Teacher | some c : Class | t->c in Teaches implies some p : Person | all g : Group | c->p->g in Groups  --incorrect 21
-- all t : Teacher | some c : Class | t->c in Teaches implies some p : Person, g : Group | c->p->g in Groups  --incorrect 22
-- all t : Teacher | some c : Class, g : Group | c->t->g in Groups  --incorrect 23
-- all t : Teacher | some c : Class, g : Group | c->t->g in Groups   --incorrect 24
-- all t : Teacher | some c : Class, g : Group | c->t->g in Groups and t->c in Teaches  --incorrect 25
-- all t : Teacher | some c : Class, g : Group | c->t->g in Groups implies t->c in Teaches  --incorrect 26
-- all t : Teacher | some c : Class, g : Group | t->c in Teaches and c->t->g in Groups   --incorrect 27
-- all t : Teacher | some c : Class, g : Group | t->c in Teaches implies c->t->g in Groups   --incorrect 28
-- all t : Teacher | some c : Class, g : Group, t0 : Teacher | c->t->g in Groups and t0->c in Teaches  --incorrect 29
-- all t : Teacher | some c : Class, p : Person, g : Group | c->p->g in Groups implies t->c in Teaches   --incorrect 30
-- all t : Teacher | some g : Group, c : Class | c->t->g in Groups  --incorrect 31
-- all t : Teacher | some g : Group, c : Class | t->c in Teaches and c->t->g in Groups  --incorrect 32
-- all t : Teacher | some p : Person, g : Group | t->p->g in Groups  --incorrect 33
-- all t : Teacher | some p : Person, g : Group, c : Class | t->c in Teaches implies c->p->g in Groups  --incorrect 34
-- all t : Teacher | some t.Teaches & (Groups.Person).Group  --incorrect 35
-- all t : Teacher | some t.Teaches & Groups.Person.Group  --incorrect 36
-- all t : Teacher | some Teacher<:(Teaches.Groups)  --incorrect 37
-- all t : Teacher, c : Class | some g : Group | c->t->g in Groups  --incorrect 38
-- all t : Teacher, c : Class | t->c in Teaches  --incorrect 39
-- all t : Teacher, c : Class | t->c in Teaches implies some p : Person | all g : Group | c->p->g in Groups  --incorrect 40
-- all t : Teacher, c : Class | t->c in Teaches implies some p : Person, g : Group | c->p->g in Groups  --incorrect 41
-- all t : Teacher, c : Class, g : Group | c->t->g in Groups  --incorrect 42
-- all t0, t1 : Teacher | some c : Class, g : Group | c->t0->g in Groups implies t1->c in Teaches  --incorrect 43
-- all t: Teacher | some g: Group, c: Class | (c->t->g in Groups)  --incorrect 44
-- all t: Teacher | some g: Group, c: Class | c->t->g in Groups  --incorrect 45
-- all t: Teacher | some g: Group, c: Class | t->c in Teaches implies (c->t->g in Groups)  --incorrect 46
-- all t: Teacher|some c: Class | t->c in Teaches implies some s:Student, g:Group | c->s->g in Groups  --incorrect 47
-- all t:Teacher  | some Groups.t  --incorrect 48
-- all t:Teacher  | some t.Groups  --incorrect 49
-- all t:Teacher , s:Student | (some g:Group ,c:Class| t->c in Teaches and c->s->g in Groups)  --incorrect 50
-- all t:Teacher , s:Student | some g:Group ,c:Class| t->c in Teaches and c->s->g in Groups  --incorrect 51
-- all t:Teacher | (some g:Group , c:Class | t->c->g in Groups)  --incorrect 52
-- all t:Teacher | (some g:Group ,c:Class| t->c in Teaches and c->t->g in Groups)  --incorrect 53
-- all t:Teacher | all c:Class |some g:Group | t in Person  --incorrect 54
-- all t:Teacher | all g:Group | t.Tutors in g.~(Class.Groups)  --incorrect 55
-- all t:Teacher | some c:Class, g:Group | c->t->g in Groups  --incorrect 56
-- all t:Teacher | some c:Class,g:Group | c->t->g in Groups  --incorrect 57
-- all t:Teacher | some g:Group | Class->t->g in Groups  --incorrect 58
-- all t:Teacher | some g:Group | g in t.(Class.Groups)  --incorrect 59
-- all t:Teacher | some g:Group | t in Class.Groups.g  --incorrect 60
-- all t:Teacher | some g:Group | t.Tutors in g.~(Class.Groups)  --incorrect 61
-- all t:Teacher | some g:Group,c:Class | c->t->g in Groups  --incorrect 62
-- all t:Teacher | some g:Group,c:Class | t->c in Teaches and c->t->g in Groups  --incorrect 63
-- all t:Teacher | some Groups.Group.t  --incorrect 64
-- all t:Teacher | some t.(Class.Groups)  --incorrect 65
-- all t:Teacher, c:Class | (some g:Group | c->t->g in Groups)  --incorrect 66
-- all t:Teacher, c:Class | some t.(c.Groups)  --incorrect 67
-- all t:Teacher, c:Class, s:Student | some g:Group | t->c in Teaches implies c->s->g in Groups  --incorrect 68
-- all t:Teacher,c:Class | some g:Group | c->t->g in Groups  --incorrect 69
-- all t:Teacher,c:Class,g:Group | c->t->g in Groups  --incorrect 70
-- all x : Teacher | some y : Class, z : Group | y->x->z in Groups   --incorrect 71
-- all x : Teacher, y : Class | some z : Group | y->x->z in Groups  --incorrect 72
-- all x : Teacher, y : Class | some z : Group | y->x->z in Groups   --incorrect 73
-- all x : Teacher, y : Class | some z : Group | y->x->z in Groups and x->y in Teaches  --incorrect 74
-- all x : Teacher, y : Class, z : Group | y->x->z in Groups  --incorrect 75
-- all x : Teacher, y : Class, z : Group | y->x->z in Groups and x->y in Teaches  --incorrect 76
-- all x : Teacher, y : Class, z : Group | z->x->z in Groups  --incorrect 77
-- Group in Class.Groups.Teacher  --incorrect 78
-- no Class.Groups  --incorrect 79
-- no Class.Groups.Teacher  --incorrect 80
-- no Group.~(Class.Groups)  --incorrect 81
-- no Groups.Group  --incorrect 82
-- no Person.~(Class.Groups)  --incorrect 83
-- no ~(Class.Groups)  --incorrect 84
-- some (Teacher<:Teaches).Groups  --incorrect 85
-- some c : Class | (some p : Person, g : Group | c->p->g in Groups) implies all t : Teacher | t->c in Teaches  --incorrect 86
-- some c : Class | (some p : Person, g : Group | c->p->g in Groups) implies some t : Teacher | t->c in Teaches  --incorrect 87
-- some Teacher<:(Teaches.Groups)  --incorrect 88
-- Teacher in Group.~(Class.Groups)  --incorrect 89
-- Teacher in Person.Teaches  --incorrect 90
-- ~iden.iden in ~((Teacher.Teaches).Groups).((Teacher.Teaches).Groups) --incorrect 91
}

/* Only teachers tutor, and only students are tutored. */
pred inv13 {
	Tutors.Person in Teacher and Person.Tutors in Student --correct
-- all p:Person,t:Teacher,s:Student | s->p not in Tutors and p->t not in Tutors  --incorrect 1
-- all p:Person,t:Teacher,s:Student | s->p not in Tutors and p->t not in Tutors and t->s in Tutors  --incorrect 2
-- all s:Student | s not in Person.^Tutors  --incorrect 3
-- all s:Student | s not in Person.^~Tutors  --incorrect 4
-- all s:Student, t:Teacher | s not in Person.*Tutors and t not in Person.*Tutors  --incorrect 5
-- all s:Student, t:Teacher | s not in Person.^Tutors and t not in Person.^Tutors  --incorrect 6
-- all s:Student, t:Teacher | s not in Person.^Tutors and t not in Person.^~Tutors  --incorrect 7
-- all s:Student, t:Teacher | s not in Person.^Tutors and t not in Person.Tutors  --incorrect 8
-- all s:Student, t:Teacher | s not in Person.Tutors.^Tutors and t not in Person.~Tutors.^~Tutors  --incorrect 9
-- all s:Student,t:Teacher | s not in Person.^~Tutors and t not in Person.^Tutors  --incorrect 10
-- all t : Teacher, s : Student | Teacher<:Tutors  in Tutors:>Student  --incorrect 11
-- all t : Teacher, s : Student | Tutors:>Student in Teacher<:Tutors  --incorrect 12
-- all t1:Teacher,t2:Teacher,s:Student | s->t1 not in Tutors and t1->t2 not in Tutors  --incorrect 13
-- all t: Teacher, s: Student | t->s in Tutors  --incorrect 14
-- all t:Teacher, s:Student | s->t not in Tutors  --incorrect 15
-- all t:Teacher, s:Student | t->s in Tutors and s->t not in Tutors  --incorrect 16
-- all t:Teacher,s:Student | s->t not in Tutors  --incorrect 17
-- all t:Teacher,s:Student | s->t not in Tutors and t->s in Tutors  --incorrect 18
-- all t:Teacher,s:Student | s->t not in Tutors and t->t not in Tutors  --incorrect 19
-- all t:Teacher,s:Student | s->t not in Tutors and t->t not in Tutors and s->t not in Tutors  --incorrect 20
-- all t:Teacher,s:Student,c:Class | t->c in Teaches and t->s in Tutors  --incorrect 21
-- all t:Teacher,s:Student,c:Class | t->c in Teaches and t->s in Tutors and not s->c in Teaches  --incorrect 22
-- all t:Teacher,s:Student,c:Class | t->c in Teaches and t->s in Tutors and s->c not in Teaches  --incorrect 23
-- all t:Teacher,s:Student,p:Person | p->t not in Tutors and s->p not in Tutors  --incorrect 24
-- all x, y : Person | x->y in Tutors implies x in Teacher  --incorrect 25
-- no Person.^Tutors  --incorrect 26
-- no Person.^~Tutors  --incorrect 27
-- no Person.Tutors  --incorrect 28
-- no Student & Student.Tutors  --incorrect 29
-- no Student & Student.Tutors and no Teacher & Teacher.~Tutors  --incorrect 30
-- no Student & Student.~Tutors and no Teacher & Teacher.~Tutors  --incorrect 31
-- no Student.Tutors  --incorrect 32
-- no Student.Tutors and no Teacher.~Tutors  --incorrect 33
-- Person.^~Tutors in Teacher  --incorrect 34
-- some t:Teacher | all s:Student | t->s in Tutors  --incorrect 35
-- Student in Person.^Tutors and Teacher in Person.^~Tutors  --incorrect 36
-- Teacher in Person.^*Tutors and Student in Person.*Tutors  --incorrect 37
-- Teacher in Person.^~Teaches and Student in Person.^Teaches  --incorrect 38
-- Teacher in Person.^~Tutors and Student in Person.^Tutors  --incorrect 39
-- Teacher in Person.~Teaches and Student in Person.Teaches  --incorrect 40
-- Teacher in Person.~Tutors and Student in Person.Tutors  --incorrect 41
-- Teacher in Student.Tutors  --incorrect 42
-- Teacher in Teacher.Tutors  --incorrect 43
-- Teacher in Tutors.Teacher  --incorrect 44
-- Teacher.Tutors in Student  Tutors.Student in Teacher  --incorrect 45
-- Tutors.Teacher in Student.Tutors --incorrect 46
}

/* Every student in a class is at least tutored by all the teachers
 * assigned to that class. */
pred inv14 {
	all s : Person, c : Class, t : Person, g : Group | (c -> s -> g in Groups) and t -> c in Teaches implies t -> s in Tutors
-- all c : Class | (c . (Groups . Group)) & Student = ((Teaches . c) . Tutors)  --incorrect 1
-- all c : Class | (c . (Groups . Group)) & Student = (Teacher & (Teaches . c) . Tutors)  --incorrect 2
-- all c : Class | (c . (Groups . Group)) & Student in ((Teacher & (Teaches . c)) . Tutors)  --incorrect 3
-- all c : Class | (c . (Groups . Group)) & Student in ((Teaches . c) . Tutors)  --incorrect 4
-- all c : Class | (c . (Groups . Group)) & Student in (Teacher & (Teaches . c) . Tutors)  --incorrect 5
-- all c : Class | (c . (Groups . Group)) & Student in (Teacher & (Teaches . c)) . Tutors  --incorrect 6
-- all c : Class | (c . (Groups . Group)) & Student in (Teaches . c . Tutors)  --incorrect 7
-- all c : Class | (c . (Groups . Group)) & Student in (Teaches . c . Tutors) & Student  --incorrect 8
-- all c : Class | (c . (Groups . Group)) & Student in (Teaches . c . Tutors) & Teacher  --incorrect 9
-- all c : Class | (c . (Groups . Group)) = (Teaches . c . Tutors)  --incorrect 10
-- all c : Class | (c . (Groups . Group)) in (Teaches . c . Tutors)  --incorrect 11
-- all c : Class | (c . (Groups . Group)) in (Teaches . c . Tutors) & Student  --incorrect 12
-- all c : Class | (c . Groups) . Group in (Teaches . c) . Tutors  --incorrect 13
-- all c : Class | c . (Groups . Group) in ((Teaches . c) . Tutors)  --incorrect 14
-- all c : Class | c . (Groups . Group) in (Teaches . c . Tutors)  --incorrect 15
-- all c : Class | c . Groups . Group in (Teacher <: Teaches) . c . Tutors  --incorrect 16
-- all c : Class | c . Groups . Group in Teaches . c . Tutors  --incorrect 17
-- all c : Class | some s : Student, g : Group | c->s->g in Groups implies some t : Teacher | t->s in Tutors  --incorrect 18
-- all c : Class | Teaches . c . Tutors = c . Groups . Group  --incorrect 19
-- all c : Class | Teaches . c . Tutors = Class . Groups . Group  --incorrect 20
-- all c : Class | Teaches . c . Tutors in c . Groups . Group  --incorrect 21
-- all c:Class , t:Teacher, g:Group|some s:Student | (t->c in Teaches and c->s->g in Groups) implies t->s in Tutors  --incorrect 22
-- all c:Class , t:Teacher, s:Student, g:Group|(c->s->g in Groups and t->c in Teaches) implies t->c in Tutors  --incorrect 23
-- all c:Class , t:Teacher, s:Student, g:Group|(c->s->g in Groups and t->c in Teaches) implies t->s in Tutors  --incorrect 24
-- all c:Class , t:Teacher, s:Student, g:Group|(t->c in Teaches and c->s->g in Groups) implies t->s in Tutors  --incorrect 25
-- all c:Class,s:Student | s in (c.Groups).Group  --incorrect 26
-- all c:Class,s:Student | s in (c.Groups).Group implies some t:Teacher | t->c in Teaches and t in s.^~Tutors  --incorrect 27
-- all c:Class,s:Student | s in c.Groups.Group  --incorrect 28
-- all c:Class,s:Student,s:Teacher |some g:Group,t:Teacher| s in c.Groups.Group and c->t->g in Groups  --incorrect 29
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups)  --incorrect 30
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups) and some t.(c.Groups)  --incorrect 31
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups) and some t.(c.Groups) and t->c in Teaches implies t in s.^~Tutors  --incorrect 32
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups) and some t.(c.Groups) implies t in c.^~Tutors  --incorrect 33
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups) and some t.(c.Groups) implies t in s.^~Tutors  --incorrect 34
-- all c:Class,s:Student,t:Teacher | some s.(c.Groups) and t->c in Teaches implies t in s.^~Tutors  --incorrect 35
-- all c:Class,s:Student,t:Teacher |some g:Group| some s.(c.Groups)->g and some t.(c.Groups) and t->c in Teaches implies t in s.^~Tutors  --incorrect 36
-- all c:Class,s:Student,t:Teacher |some g:Group| some s.(c.Groups)->g and some t.(c.Groups)->g and t->c in Teaches implies t in s.^~Tutors  --incorrect 37
-- all c:Class,s:Student,t:Teacher, g:Group| some s.(c.Groups)->g and some t.(c.Groups)->g and t->c in Teaches implies t in s.^~Tutors  --incorrect 38
-- all c:Class,s:Student,t:Teacher, g:Group| some s.(c.Groups)->g and some t.(c.Groups)->g implies t in s.^~Tutors  --incorrect 39
-- all c:Class,s:Student,t:Teacher,g:Group| c->s->g in Groups and c in t.Teaches implies t in s.^(~Tutors)  --incorrect 40
-- all c:Class,s:Student,t:Teacher,g:Group| c->s->g in Groups and c->t->g in Groups  --incorrect 41
-- all c:Class,s:Student,t:Teacher,g:Group| c->s->g in Groups and c->t->g in Groups implies t in s.^(~Tutors)  --incorrect 42
-- all c:Class,s:Student,t:Teacher|some g:Group| c->s->g in Groups and c->t->g in Groups  --incorrect 43
-- all c:Class,s:Student| some t:Teacher | s in c.Groups.Group and t in c.Groups.Group implies t in s.^(~Tutors)  --incorrect 44
-- all c:Class,s:Student| some t:Teacher | s in c.Groups.Group implies t in s.^(~Tutors)  --incorrect 45
-- all c:Class,s:Student|some g:Group| c->s->g in Groups  --incorrect 46
-- all p : Person | some c : Class, g : Group | c->p->g in Groups and some q : Person | q->c in Teaches and q->p in Tutors  --incorrect 47
-- all p : Person | some c : Class, g : Group | c->p->g in Groups and some q : Person | q->c in Teaches implies q->p in Tutors  --incorrect 48
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies p in Student and some t : Teacher | t->p in Tutors and t->c in Teaches  --incorrect 49
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies p->c in Teaches  --incorrect 50
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies some q : Person | q->c in Teaches  --incorrect 51
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies some q : Person | q->c in Teaches and q->p in Tutors  --incorrect 52
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies some q : Person | q->p in Tutors and q->c in Teaches  --incorrect 53
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies some t : Teacher | t->c in Teaches and t->p in Tutors  --incorrect 54
-- all p : Person | some c : Class, g : Group | c->p->g in Groups implies some t : Teacher | t->p in Tutors and t->c in Teaches  --incorrect 55
-- all p : Student | some c : Class, g : Group | c->p->g in Groups implies some t : Teacher | t->p in Tutors and t->c in Teaches  --incorrect 56
-- all s : Person, c : Class | some s.(Teacher<:Tutors) implies some c.(Teacher<:Teaches)  --incorrect 57
-- all s : Person, c : Class, t : Teacher | ((some g : Group | c->s->g in Groups) and t->c in Teaches) implies t->s in Tutors  --incorrect 58
-- all s : Person, c : Class, t : Teacher | (all g : Group | c->s->g in Groups) and t->c in Teaches implies t->s in Tutors  --incorrect 59
-- all s : Student |   some c : Class | (s in c.Groups.Group) implies (        all t : Teaches.c :> Teacher | s in t.Tutors        )  --incorrect 60
-- all s : Student | (some c : Class, g : Group | c->s->g  in Groups) implies some t : Teacher | t->s in Tutors  --incorrect 61
-- all s : Student | (some c : Class, g : Group | c->s->g in Groups) implies some t : Teacher | t->s in Tutors  --incorrect 62
-- all s : Student | (some t : Teacher | t->s in Tutors) implies s in Class  --incorrect 63
-- all s : Student | s in Class implies (some t : Teacher | t->s in Tutors)  --incorrect 64
-- all s : Student | s in Class implies some t : Teacher | t->s in Tutors  --incorrect 65
-- all s : Student | s in Class implies some t : Teacher | t->s in Tutors and t in Class  --incorrect 66
-- all s : Student | s in Class implies some t : Teacher, c : Class | t->s in Tutors and t->c in Teaches  --incorrect 67
-- all s : Student | some c : Class, g : Group | c->s->g  in Groups implies some t : Teacher | t->c in Tutors  --incorrect 68
-- all s : Student | some c : Class, g : Group | c->s->g  in Groups implies some t : Teacher | t->s in Tutors  --incorrect 69
-- all s : Student | some c : Class, g : Group | c->s->g  in Groups implies some t : Teacher | t->s in Tutors and t->c in Teaches  --incorrect 70
-- all s : Student | some s.(Class.Groups)  --incorrect 71
-- all s : Student | some s.(Class.Groups)   implies some (Teacher<:Tutors).s  --incorrect 72
-- all s : Student | some s.(Class.Groups) and some Teacher.Teaches implies some (Teacher<:Tutors).s  --incorrect 73
-- all s : Student | some s.(Class.Groups) and some Teacher<:Teaches implies some (Teacher<:Tutors).s  --incorrect 74
-- all s : Student | some s.(Class<:Groups)  --incorrect 75
-- all s : Student | some s.(Class<:Groups) implies some Class.(Teacher<:Teaches)  --incorrect 76
-- all s : Student | some s.(Teacher<:Teaches)  --incorrect 77
-- all s : Student | some t : Teacher | t->s in Tutors  --incorrect 78
-- all s : Student | some t : Teacher | t->s in Tutors implies s in Class  --incorrect 79
-- all s : Student | some t : Teacher, c : Class | t->c in Teaches implies t->s in Tutors  --incorrect 80
-- all s : Student | some t : Teacher, c : Class | t->s in Tutors and t->c in Teaches  --incorrect 81
-- all s : Student | some t : Teacher, c : Class | t->s in Tutors implies s in Class and t in Class  --incorrect 82
-- all s : Student | some t : Teacher, c : Class | t->s in Tutors implies t->c in Teaches  --incorrect 83
-- all s : Student | some t : Teacher, c : Class, g : Group | (t->c in Teaches implies t->s in Tutors) and c->s->g in Groups  --incorrect 84
-- all s : Student | some t : Teacher, c : Class, g : Group | t->c in Teaches implies t->s in Tutors  --incorrect 85
-- all s : Student | some t : Teacher, c : Class, g : Group | t->c in Teaches implies t->s in Tutors and c->s->g in Groups  --incorrect 86
-- all s : Student | some Tutors.s & Groups.s.Group  --incorrect 87
-- all s : Student, c : Class | some (Teacher<:Teaches).c implies some s.(Teacher<:Teaches)  --incorrect 88
-- all s : Student, c : Class | some (Teacher<:Teaches).c implies some s.(Teacher<:Tutors)  --incorrect 89
-- all s : Student, c : Class | some (Teacher<:Tutors).c implies some s.(Teacher<:Teaches)  --incorrect 90
-- all s : Student, c : Class | some c -> s <: Groups implies (Teaches . c) -> s in Tutors  --incorrect 91
-- all s : Student, c : Class | some c.(Teacher<:Teaches) implies some s.(Teacher<:Tutors)  --incorrect 92
-- all s : Student, c : Class | some g : Group | c->s->g in Groups implies some t : Teacher | t->s in Tutors  --incorrect 93
-- all s : Student, c : Class | some s.(c.Groups) and some (Teacher<:Teaches).c implies some (Teacher<:Tutors).s  --incorrect 94
-- all s : Student, c : Class | some s.(Teacher<:Tutors) implies some c.(Teacher<:Teaches)  --incorrect 95
-- all s : Student, c : Class | some t : Teacher | (some g : Group | c->s->g in Groups) and t->c in Teaches implies t->s in Tutors  --incorrect 96
-- all s : Student, c : Class, g : Group | c->s->g in Groups implies some t : Teacher | t->s in Tutors  --incorrect 97
-- all s : Student, c : Class, t : Teacher | ((all g : Group | c->s->g in Groups) and t->c in Teaches) implies t->s in Tutors  --incorrect 98
-- all s : Student, c : Class, t : Teacher | ((some g : Group | c->s->g in Groups) and t->c in Teaches) implies t->s in Tutors  --incorrect 99
-- all s : Student, c : Class, t : Teacher | (all g : Group | c->s->g in Groups) and t->c in Teaches implies t->s in Tutors  --incorrect 100
-- all s : Student, c : Class, t : Teacher | (some g : Group | c->s->g in Groups) and t->c in Teaches implies t->s in Tutors  --incorrect 101
-- all s : Student, c : Class, t : Teacher | t -> c in Teaches and (some g : Group | c -> s -> g in Groups) iff t -> s in Tutors  --incorrect 102
-- all s : Student, c : Class, t : Teacher | t -> c in Teaches and (some g : Group | c -> s -> g in Groups) implies t -> s in Tutors  --incorrect 103
-- all s : Student, c : Class, t : Teacher, g : Group | ((c -> s -> g in Groups) and (t -> c in Teaches)) implies t -> s in Tutors  --incorrect 104
-- all s : Student, c : Class, t : Teacher, g : Group | (c -> s -> g in Groups) and (t -> c in Teaches) implies t -> s in Tutors  --incorrect 105
-- all s : Student, c : Class, t : Teacher, g : Group | (c -> s -> g in Groups) and t -> c in Teaches implies t -> s in Tutors  --incorrect 106
-- all s : Student, t : Teacher | (some s.(Class.Groups)) implies some t.(Class.Groups)  --incorrect 107
-- all s : Student, t : Teacher | some s.(Class.Groups) and some (t<:Teaches).Class implies some (t<:Tutors).s  --incorrect 108
-- all s : Student, t : Teacher | some s.(Class.Groups) implies some t.(Class.Groups)  --incorrect 109
-- all s : Student, t : Teacher, c : Class | some s.(c.Groups)  --incorrect 110
-- all s : Student, t : Teacher, c : Class | some s.(c<:Groups) and some (t<:Teaches).c implies some (t<:Tutors).s  --incorrect 111
-- all s, t : Person | some s.(Class.Groups) and some t<:(Teaches.Class) implies some t<:(Tutors.s)  --incorrect 112
-- all s, t : Person | some s.(Class.Groups) and some t<:Teaches implies some (t<:Tutors).s  --incorrect 113
-- all s, t : Person | some s.(Class.Groups) and some t<:Teaches implies some t<:(Tutors.s)  --incorrect 114
-- all s, t : Person, c : Class | (some g : Group | c->s->g in Groups) and t->s in Teaches implies t->c in Tutors  --incorrect 115
-- all s,t : Person, c : Class | (some g : Group | c->s->g  in Groups) and t->s in Tutors implies t->c in Teaches  --incorrect 116
-- all s,t : Person, c : Class | some s.(c.Groups)  --incorrect 117
-- all s,t : Person, c : Class | some s.(c.Groups) and some (t.Teaches)  --incorrect 118
-- all s,t : Person, c : Class | some s.(c.Groups) and some (t<:Teaches).c  --incorrect 119
-- all s,t : Person, c : Class | some s.(c.Groups) and some (t<:Teaches).c implies some (t<:Tutors).s  --incorrect 120
-- all s,t : Person, c : Class | some s.(c.Groups) and some t.Teaches  --incorrect 121
-- all s:Student | some t:Teacher | t in s.^~Tutors  --incorrect 122
-- all s:Student, c:Class | some t:Teacher | t->s in Tutors implies t->c in Teaches  --incorrect 123
-- all s:Student, c:Class, g:Group | some t:Teacher | (t->s in Tutors and c->s->g in Groups) implies t->c in Teaches  --incorrect 124
-- all s:Student, c:Class, g:Group, t:Teacher | (t->s in Tutors and c->s->g in Groups) implies t->c in Teaches  --incorrect 125
-- all s:Student, c:Class,t:Teacher | s in c.Groups.Group and t->c in Teaches implies t in s.^~Tutors  --incorrect 126
-- all s:Student,c:Class | s in (c.Groups).Group  --incorrect 127
-- all s:Student,c:Class | s in c.Groups.Group  --incorrect 128
-- all s:Student,c:Class | s in c.Groups.Group implies some t:Teacher | t->c in Teaches  --incorrect 129
-- all s:Student,c:Class | s in c.Groups.Group implies some t:Teacher | t->c in Teaches and t in s.^~Tutors  --incorrect 130
-- all s:Student,c:Class | some s.(c.Groups)  --incorrect 131
-- all s:Student,c:Class | some s.(c.Groups) implies some t:Teacher | t->c in Teaches  --incorrect 132
-- all s:Student,c:Class | some s.(c.Groups) implies some t:Teacher | t->c in Teaches and t in s.~Tutors  --incorrect 133
-- all s:Student,c:Class | some t:Teacher | some c.Groups.s  --incorrect 134
-- all s:Student,c:Class | some t:Teacher | some s.(c.Groups)  --incorrect 135
-- all s:Student,c:Class | some t:Teacher | some s.(c.Groups) and some t.(c.Groups)  --incorrect 136
-- all s:Student,c:Class | some t:Teacher | some s.(c.Groups) and some t.(c.Groups) implies t in s.^~Tutors  --incorrect 137
-- all s:Student,c:Class | some t:Teacher | t->s in Tutors  --incorrect 138
-- all s:Student,c:Class, t:Teacher | t->c in Teaches and one s.(c.Groups) and one t.(c.Groups) implies t in s.^Tutors  --incorrect 139
-- all s:Student,c:Class,g:Group | some t:Teacher |(t->s in Tutors and c->s->g in Groups) implies t->c in Teaches  --incorrect 140
-- all s:Student,c:Class,g:Group|some t:Teacher | some c.Groups  --incorrect 141
-- all s:Student,c:Class,g:Group|some t:Teacher | some c.Groups.s  --incorrect 142
-- all s:Student,c:Class,g:Group|some t:Teacher | some s.(c.Groups)  --incorrect 143
-- all s:Student,c:Class,g:Group|some t:Teacher | some Teacher  --incorrect 144
-- all s:Student,c:Class,g:Group|some t:Teacher | t->c in Teaches and some s.(c.Groups) and some t.(c.Groups)  --incorrect 145
-- all s:Student,c:Class,g:Group|some t:Teacher | t->c in Teaches and some s.(c.Groups) and some t.(c.Groups) implies t in s.^~Tutors  --incorrect 146
-- all s:Student,c:Class,t:Teacher | s in c.Groups.Group  --incorrect 147
-- all s:Student,c:Class,t:Teacher | s in c.Groups.Group and t->c in Teaches  --incorrect 148
-- all s:Student,c:Class,t:Teacher | s in c.Groups.Group and t->c in Teaches implies t in s.^~Tutors  --incorrect 149
-- all s:Student,c:Class,t:Teacher | s in c.Groups.Group and t->c in Teaches implies t in s.~Tutors  --incorrect 150
-- all s:Student,c:Class,t:Teacher | t->c in Teaches and one s.(c.Groups) and one t.(c.Groups) implies t in s.~Tutors  --incorrect 151
-- all s:Student,c:Class|some t:Teacher | t->c in Teaches  --incorrect 152
-- all s:Student,c:Class|some t:Teacher | t->c in Teaches and one s.(c.Groups) and one t.(c.Groups) implies t in s.^Tutors  --incorrect 153
-- all s:Student,c:Class|some t:Teacher | t->c in Teaches and one s.(c.Groups) and one t.(c.Groups) implies t in s.^~Tutors  --incorrect 154
-- all s:Student,c:Class|some t:Teacher | t->c in Teaches and one s.(c.Groups) and one t.(c.Groups) implies t in s.~Tutors  --incorrect 155
-- all s:Student,c:Class|some t:Teacher | t->c in Teaches and some s.(c.Groups) and some t.(c.Groups) implies t in s.^~Tutors  --incorrect 156
-- all s:Student,t:Teacher,c:Class,g:Group | (t->s in Tutors and c->s->g in Groups) implies t->c in Teaches  --incorrect 157
-- all s:Student| some c:Class,t:Teacher | s in c.Groups.Group and t->c in Teaches implies t in s.^~Tutors  --incorrect 158
-- all s:Student| some t:Teacher | t->s in Tutors  --incorrect 159
-- all s:Student| some t:Teacher,c:Class,g:Group | t->s in Tutors and c->s->g in Groups and c->t->g in Groups  --incorrect 160
-- all t : Teacher, c : Class | some Student.(c.Groups) and some (t<:Teaches).c implies some (t<:Tutors).Student  --incorrect 161
-- all x : Class, y : Student  | (some z : Group | x->y->z in Groups) and some v : Teacher | v->x in Teaches implies v->y in Tutors  --incorrect 162
-- all x : Person | some y : Class | (some z : Group | y->x->z in Groups) implies all u : Teacher | u->y in Teaches and u->x in Tutors  --incorrect 163
-- all x : Person, y : Class | (all z : Group | y->x->z in Groups) implies all u : Teacher | u->y in Teaches and u->x in Tutors  --incorrect 164
-- all x : Person, y : Class | (some z : Group | y->x->z in Groups) and all u : Teacher | u->y in Teaches implies u->x in Tutors  --incorrect 165
-- all x : Person, y : Class | (some z : Group | y->x->z in Groups) implies all u : Teacher | u->y in Teaches and u->x in Tutors  --incorrect 166
-- all x : Person, y : Class, v : Teacher | ((some z : Group | y->x->z in Groups) and v->y in Teaches) implies v->x in Tutors  --incorrect 167
-- all x : Person, y : Class, v : Teacher | (all z : Group | y->x->z in Groups) and v->y in Teaches implies v->x in Tutors  --incorrect 168
-- all x : Person, y : Class, v : Teacher | (some z : Group | y->x->z in Groups) and v->y in Teaches  --incorrect 169
-- all x : Person, y : Class, v : Teacher | (some z : Group | y->x->z in Groups) and v->y in Teaches implies v->x in Tutors  --incorrect 170
-- all x : Person, y : Class, v : Teacher | (some z : Group | y->x->z in Groups) and v->y in Teaches implies v->y in Tutors  --incorrect 171
-- all x, v : Person, y : Class | (some z : Group | y->x->z in Groups) and v->y in Teaches implies v->x in Tutors  --incorrect 172
-- Class in (Teacher<:Teaches).Class implies Student in (Teacher<:Tutors).Student  --incorrect 173
-- some Groups.Group  --incorrect 174
-- Student in (Class.Groups).Student and Class in (Teacher<:Teaches).Class implies Student in (Teacher<:Tutors).Student  --incorrect 175
-- Student in Class.(Groups.Student) and Class in (Teacher<:Teaches).Class implies Student in (Teacher<:Tutors).Student  --incorrect 176
-- Student in Student.(Class.Groups) and Class in (Teacher<:Teaches).Class implies Student in (Teacher<:Tutors).Student  --incorrect 177
}

/* The tutoring chain of every person eventually reaches a Teacher. */
pred inv15 {
	all s : Person | some Teacher & ^Tutors.s
-- all p : Person | some (Teacher & p . ^Tutors)  --incorrect 1
-- all p : Person | some p <: (^ Tutors)  --incorrect 2
-- all p : Person | some p <: ^ Tutors  --incorrect 3
-- all p : Person | some p2 : Person | p -> p2 in Tutors and p in Teacher  --incorrect 4
-- all p : Person | some q : Person, t : Teacher | t->p in Tutors or (q->p in Tutors and t->q in Tutors) or (t->q in Tutors and q->p in Tutors and p->t in Tutors)  --incorrect 5
-- all p : Person | some q,r : Person | (p in Teacher or q in Teacher or r in Teacher) and (q->p in Tutors or r->p in Tutors or r->q in Tutors)  --incorrect 6
-- all p : Person | some q,r : Person | (p->q in Tutors or q->p in Tutors or p->r in Tutors or r->p in Tutors)  implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 7
-- all p : Person | some q,r : Person | (p->q in Tutors or q->p in Tutors or q->r in Tutors or r->q in Tutors       or r->p in Tutors or p->r in Tutors)  implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 8
-- all p : Person | some q,r : Person | (q in Teacher or r in Teacher) and (q->p in Tutors or r->p in Tutors or r->q in Tutors)  --incorrect 9
-- all p : Person | some t : Teacher | t->p in Tutors or (some q : Person | q->p in Tutors and t->q in Tutors)  --incorrect 10
-- all p : Person | some Teacher <: p . (^ Tutors)  --incorrect 11
-- all p : Teacher | some p <: ^ Tutors  --incorrect 12
-- all p,q,r : Person | (p->q in Tutors implies p in Teacher or q->p in Tutors or q->r in Tutors or r->q in Tutors         or r->p in Tutors or p->r in Tutors)    implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 13
-- all p,q,r : Person | (p->q in Tutors implies p in Teacher) or    (q->p in Tutors implies q in Teacher) or    (q->r in Tutors implies q in Teacher) or    (r->q in Tutors implies r in Teacher) or    (r->p in Tutors implies r in Teacher) or    (p->r in Tutors implies p in Teacher)  --incorrect 14
-- all p,q,r : Person | (p->q in Tutors or q->p in Tutors or q->r in Tutors or r->q in Tutors         or r->p in Tutors or p->r in Tutors)    and (p in Teacher or q in Teacher or r in Teacher)  --incorrect 15
-- all p,q,r : Person | (p->q in Tutors or q->p in Tutors or q->r in Tutors or r->q in Tutors         or r->p in Tutors or p->r in Tutors)    implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 16
-- all p,q,r : Person | (p->q in Tutors or q->p in Tutors or q->r in Tutors or r->q in Tutors         or r->p in Tutors or p->r in Tutors)    or (p in Teacher or q in Teacher or r in Teacher)  --incorrect 17
-- all p,q,r : Person | (p->q in Tutors or q->r in Tutors or q->r in Tutors or r->p in Tutors or p->r in Tutors or r->q in Tutors) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 18
-- all p,q,r : Person | p->q in Tutors and q->r in Tutors implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 19
-- all p1 : Person | (some p2 : Teacher | p2 -> p1 in Tutors) or (some p2, p3 : Person | p2 -> p1 in Tutors and p3 -> p2 in Tutors and p3 in Teacher)  --incorrect 20
-- all p1 : Person | p1 in Teacher or (some p2 : Teacher | p2 -> p1 in Tutors) or (some p2, p3 : Person | p2 -> p1 in Tutors and p3 -> p2 in Tutors and p3 in Teacher)  --incorrect 21
-- all p1, p2, p3 : Person | p1 -> p2 in Tutors and p2 -> p3 in Tutors and p1 in Teacher  --incorrect 22
-- all p:Person |  Teacher in (p.^Tutors)  --incorrect 23
-- all p:Person | p.Tutors.Tutors.Tutors in Teacher  --incorrect 24
-- all p:Person | some t:Teacher | t in (p.^Tutors)  --incorrect 25
-- all p:Person | some t:Teacher | t in p.*Tutors  --incorrect 26
-- all p:Person | some t:Teacher | t in p.^Tutors  --incorrect 27
-- all p:Person | some t:Teacher | t in p.^~Teaches  --incorrect 28
-- all p:Person | some Teacher <:(p.^Tutors)  --incorrect 29
-- all p:Person | Teacher in p.^Tutors  --incorrect 30
-- all p:Person |some t:Teacher | p in p.^~Tutors  --incorrect 31
-- all s : Person | some (s.^Tutors & Teacher)  --incorrect 32
-- all s : Person | some Teacher & ^Tutors.Person  --incorrect 33
-- all s : Person | some Teacher & s.*Tutors  --incorrect 34
-- all s : Person | some Teacher & s.^Tutors  --incorrect 35
-- all s : Student | s.^Tutors in Teacher  --incorrect 36
-- all s : Student | some (s.*Tutors & Teacher)  --incorrect 37
-- all s : Student | some (s.^Tutors & Teacher)  --incorrect 38
-- all s : Student | some (Teacher & s . ^Tutors)  --incorrect 39
-- all s : Student | some s.^Tutors & Teacher  --incorrect 40
-- all s : Student | some t : Teacher | t in s.^Tutors  --incorrect 41
-- all s : Student | some Teacher & s . ^Tutors  --incorrect 42
-- all s:Person | some Teacher & s.*Tutors  --incorrect 43
-- all s:Person | some Teacher & s.^Tutors  --incorrect 44
-- all s:Person | some(s.^Tutors & Teacher)  --incorrect 45
-- all s:Student | some t:Teacher | t in s.^Tutors  --incorrect 46
-- all s:Student | some Teacher & s.^Tutors  --incorrect 47
-- all s:Student | Teacher in s.^Tutors  --incorrect 48
-- all s:Student |some Teacher & s.^Teaches  --incorrect 49
-- all s:Student |some Teacher & s.^Tutors  --incorrect 50
-- all t:Teacher | all p:Person | t in p.^Tutors  --incorrect 51
-- all t:Teacher | all p:Person | t in p.^~Tutors  --incorrect 52
-- all x, y, z : Person | x->y in Tutors and y->z in Tutors and x != y and x != z and y != z implies z in Teacher  --incorrect 53
-- all x, y, z : Person | x->y in Tutors and y->z in Tutors and z->x in Tutors and x != y and x != z and y != z implies x in Teacher  --incorrect 54
-- all x, y, z : Person | x->y in Tutors and y->z in Tutors and z->x in Tutors implies x in Teacher  --incorrect 55
-- all x, y, z : Person | x->y in Tutors and y->z in Tutors and z->x in Tutors implies z in Teacher  --incorrect 56
-- all x, y, z : Person | x->y in Tutors and y->z in Tutors implies z in Teacher  --incorrect 57
-- all x, y, z : Teacher | x->y in Tutors and y->z in Tutors implies z in Teacher  --incorrect 58
-- Person.^~Tutors in Teacher  --incorrect 59
-- Person.Teaches.Teaches.Teaches in Teacher  --incorrect 60
-- Person.Tutors.Tutors.Tutors in Teacher  --incorrect 61
-- some p : Teacher | some p <: ^ Tutors  --incorrect 62
-- some p,q,r : Person | ((p->q in Tutors and q->r in Tutors) or (q->r in Tutors and r->p in Tutors) or (p->r in Tutors and r->p in Tutors)) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 63
-- some p,q,r : Person | ((p->q in Tutors and q->r in Tutors) or (q->r in Tutors and r->p in Tutors) or (p->r in Tutors and r->q in Tutors)) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 64
-- some p,q,r : Person | ((p->q in Tutors or q->p in Tutors) and (q->r in Tutors or r->q in Tutors) and (p->r in Tutors or r->p in Tutors)) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 65
-- some p,q,r : Person | (p->q in Tutors or q->p in Tutors) and (q->r in Tutors and r->q in Tutors) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 66
-- some p,q,r : Person | (p->q in Tutors or q->p in Tutors) and (q->r in Tutors or r->q in Tutors)  implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 67
-- some p,q,r : Person | (p->q in Tutors or q->r in Tutors or q->r in Tutors or r->p in Tutors or p->r in Tutors or r->q in Tutors) implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 68
-- some p,q,r : Person | p->q in Tutors and q->r in Tutors implies (p in Teacher or q in Teacher or r in Teacher)  --incorrect 69
-- some p1, p2, p3 : Person | p1 -> p2 in Tutors and p2 -> p3 in Tutors and p1 in Teacher  --incorrect 70
-- some t:Teacher | t in (Person.^Teaches)  --incorrect 71
-- some t:Teacher |all p:Person | t in p.^Teaches  --incorrect 72
-- some t:Teacher |all p:Person | t in p.^Tutors  --incorrect 73
-- some t:Teacher |all p:Person | t in p.^~Tutors  --incorrect 74
-- some Teacher & ^Tutors.Person  --incorrect 75
-- some x, y, z : Person | x->y in Tutors and y->z in Tutors and x != y and x != z and y != z implies z in Teacher  --incorrect 76
-- some x, y, z : Person | x->y in Tutors and y->z in Tutors implies z in Teacher  --incorrect 77
-- Teacher in Person.^Tutors  --incorrect 78
-- Tutors.Tutors.Tutors.Person in Teacher  --incorrect 79
}/*======== IFF PERFECT ORACLE ===============*/
pred inv1_OK {
  Person in Student --correct
}
assert inv1_Repaired {
    inv1[] iff inv1_OK[]
}
---------
pred inv2_OK {
  no Teacher --correct
}
assert inv2_Repaired {
    inv2[] iff inv2_OK[]
}
--------
pred inv3_OK {
  no Student & Teacher --correct
}
assert inv3_Repaired {
    inv3[] iff inv3_OK[]
}
--------
pred inv4_OK {
 Person in (Student + Teacher) --correct
}
assert inv4_Repaired {
    inv4[] iff inv4_OK[]
}
--------
pred inv5_OK {
  some Teacher.Teaches --correct
}
assert inv5_Repaired {
    inv5[] iff inv5_OK[]
}
--------
pred inv6_OK {
  Teacher in Teaches.Class --correct
}
assert inv6_Repaired {
    inv6[] iff inv6_OK[]
}
--------
pred inv7_OK {
  Class in Teacher.Teaches --correct
}
assert inv7_Repaired {
    inv7[] iff inv7_OK[]
}
--------
pred inv8_OK {
  all t:Teacher | lone t.Teaches --correct
}
assert inv8_Repaired {
    inv8[] iff inv8_OK[]
}
--------
pred inv9_OK {
  all c:Class | lone Teaches.c & Teacher --correct
}
assert inv9_Repaired {
    inv9[] iff inv9_OK[]
}
--------
pred inv10_OK {
  all c:Class, s:Student | some s.(c.Groups) --correct
}
assert inv10_Repaired {
    inv10[] iff inv10_OK[]
}
--------
pred inv11_OK {
  all c : Class | (some c.Groups) implies some Teacher & Teaches.c --correct
}
assert inv11_Repaired {
    inv11[] iff inv11_OK[]
}
--------
pred inv12_OK {
 all t : Teacher | some (t.Teaches).Groups --correct
}
assert inv12_Repaired {
    inv12[] iff inv12_OK[]
}
--------
pred inv13_OK {
  Tutors.Person in Teacher and Person.Tutors in Student  --correct
}
assert inv13_Repaired {
    inv13[] iff inv13_OK[]
}
--------
pred inv14_OK {
      all s : Person, c : Class, t : Person, g : Group | (c -> s -> g in Groups) and t -> c in Teaches implies t -> s in Tutors --correct
}
assert inv14_Repaired {
    inv14[] iff inv14_OK[]
}
--------
pred inv15_OK {
  all s : Person | some Teacher & ^Tutors.s --correct
}
assert inv15_Repaired {
    inv15[] iff inv15_OK[]
}
--------

--- PerfectOracleCommands
 check inv1_Repaired expect 0
 check inv2_Repaired expect 0
 check inv3_Repaired expect 0 
 check inv4_Repaired expect 0
 check inv5_Repaired expect 0
 check inv6_Repaired expect 0
 check inv7_Repaired expect 0
 check inv8_Repaired expect 0
 check inv9_Repaired expect 0
 check inv10_Repaired expect 0
 check inv11_Repaired expect 0
 check inv12_Repaired expect 0
 check inv13_Repaired expect 0
 check inv14_Repaired expect 0
 check inv15_Repaired expect 0
pred repair_pred_1{inv9[] iff inv9_OK[] }
run repair_pred_1
assert repair_assert_1{inv9[] iff inv9_OK[] }
check repair_assert_1
