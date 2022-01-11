

/* The set of files in the file system. */
sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash extends File {}
/* The set of protected files. */
sig Protected extends File {}

/* The trash is empty. */
pred inv1 {
	no Trash --correct
-- File in Trash  --incorrect 1
-- all f:File|f in Trash  --incorrect 2
-- all f : File | f in Trash  --incorrect 3
-- all f:File | f in Trash  --incorrect 4
-- all f:File | f in Trash  --incorrect 5
-- all f:File | f in Trash  --incorrect 6
-- some Trash  --incorrect 7
-- no Trash  all f:File | f in Trash  --incorrect 8
-- all f:File  | f in Trash  --incorrect 9
-- no File  --incorrect 10
-- Trash in File  --incorrect 11
}

/* All files are deleted. */
pred inv2 {
	File in Trash --correct
-- all f:Trash | f not in File --incorrect 1
}

/* Some file is deleted. */
pred inv3 {
	some Trash --correct
-- File - Trash in Trash --incorrect 1
-- some File --incorrect 2
-- File in Trash --incorrect 3
-- one Trash --incorrect 4
-- File in Trash --incorrect 5
}

/* Protected files cannot be deleted. */
pred inv4 {
	no Protected & Trash --correct
-- all f : File | f in Protected and f not in Trash  --incorrect 1
-- all f : File | some f : Protected | f not in Trash  --incorrect 2
-- all f : Protected | f not in File  --incorrect 3
-- all f:File | (f in Protected)  --incorrect 4
-- all f:File | all t:Trash | f!=t  --incorrect 5
-- all f:File | f in Protected  --incorrect 6
-- no (Protected + Trash)  --incorrect 7
-- not Protected in Trash  --incorrect 8
-- Protected in File  --incorrect 9
-- Protected in Trash  --incorrect 10
-- Protected not in Trash  --incorrect 11
-- some f:File|f in Protected implies f not in Trash --incorrect 12
}

/* All unprotected files are deleted.. */
pred inv5 {
	File - Protected in Trash --correct
-- (File & Protected) in Trash  --incorrect 1
-- all f : File | f in Trash implies f not in Protected  --incorrect 2
-- all f : File | f not in Protected and f in Trash  --incorrect 3
-- all f:File | (f not in Protected)  --incorrect 4
-- all f:File | all p:Protected | f != p implies f in Trash  --incorrect 5
-- all f:File | f in Trash  --incorrect 6
-- all f:File | f in Trash implies f not in Protected  --incorrect 7
-- all f:File | f not in Protected  --incorrect 8
-- all f:File | f not in Protected and f in Trash  --incorrect 9
-- all f:File | lone f.link  --incorrect 10
-- all f:Protected | no f & Trash  --incorrect 11
-- all f:Protected | no f&Trash  --incorrect 12
-- all f:Protected | not f in Trash  --incorrect 13
-- all f:Trash | f in Protected  --incorrect 14
-- all f:Trash | f not in Protected  --incorrect 15
-- all p : Protected | not p in Trash  --incorrect 16
-- all p:Protected | not p in Trash  --incorrect 17
-- File & Protected in Trash  --incorrect 18
-- File & Trash = File - Protected  --incorrect 19
-- File - Protected = Trash  --incorrect 20
-- File = Trash - Protected  --incorrect 21
-- no Protected  --incorrect 22
-- no Protected & Trash  --incorrect 23
-- no Protected -> Trash  --incorrect 24
-- no Protected&Trash  --incorrect 25
-- not Protected & File in Trash  --incorrect 26
-- not Protected in Trash  --incorrect 27
-- Protected in File & Trash  --incorrect 28
-- Protected in Trash  --incorrect 29
-- some f : File | f not in Protected and f in Trash  --incorrect 30
-- Trash = File - Protected  --incorrect 31
-- Trash = Protected - File  --incorrect 32
-- Trash in (File - Protected)  --incorrect 33
-- Trash in File - Protected --incorrect 34
}

/* A file links to at most one file. */
pred inv6 {
	~link . link in iden --correct
-- (link . ~link) in (~link . link)  --incorrect 1
-- (link . ~link) in iden  --incorrect 2
-- all f : File | all g : File | f->g in link  --incorrect 3
-- all f : File | lone link :> f  --incorrect 4
-- all f : File | lone link.f  --incorrect 5
-- all f : File | some g : File | f->g in link  --incorrect 6
-- all f : File | some g : File | f->g in link implies g->f not in link  --incorrect 7
-- all f : File | some g,h : File | f->g in link implies f->h not in link  --incorrect 8
-- all f,g : File | f->g in link  --incorrect 9
-- all f,g,h : File | f->g in link and f->h in link  --incorrect 10
-- all f,g,h : File | f->g in link implies f->h not in link  --incorrect 11
-- all f,g,h:File| f->g in link  --incorrect 12
-- all f,g,h:File| f->g in link and f->h in link  --incorrect 13
-- all f,g,h:File| no Trash  --incorrect 14
-- all f,g:File | f->g in link  --incorrect 15
-- all f,g:File | f->g in link implies g->f in link  --incorrect 16
-- all f1,f2,f3 : File | (f1 -> f3 in link and f2 -> f3 in link) implies f1 = f2  --incorrect 17
-- all f1,f2,f3 : File | (f1 -> f3 in link and f2 -> f3 in link) implies f2 = f3  --incorrect 18
-- all f1,f2,f3 : File | f1 -> f3 in link and f2 -> f3 in link implies f2 = f3  --incorrect 19
-- all f1,f2,f3:File | ((f1 -> f3 in link and f2 -> f3 in link)) implies f1 = f2  --incorrect 20
-- all f:File | lone f->link  --incorrect 21
-- all f:File | lone File  --incorrect 22
-- all f:File | one f.link  --incorrect 23
-- all x, y, z : File | x -> y in link implies x -> z not in link  --incorrect 24
-- all x,y : File | x->y in link  --incorrect 25
-- all x,y : File | x->y in link implies (all z : File | x->z not in link)  --incorrect 26
-- all x,y : File | x->y in link implies (all z : File | z != x and x->z not in link)  --incorrect 27
-- all x,y : File | x->y in link implies (all z : File | z != y and x->z not in link)  --incorrect 28
-- all x,y,z : File | (x->y in link and x->z in link) implies x=y  --incorrect 29
-- all x,y,z : File | (x->y in link) and (x->z in link) implies x=y  --incorrect 30
-- all x,y,z : File | x->y in link implies (all z : File | x->z not in link)  --incorrect 31
-- File.link in File  --incorrect 32
-- link . ~link in iden  --incorrect 33
-- link.~link in iden  --incorrect 34
-- lone (File.link)  --incorrect 35
-- lone File.link  --incorrect 36
-- lone link  --incorrect 37
-- lone link.File  --incorrect 38
-- one File.link  --incorrect 39
-- one link.~link  --incorrect 40
-- some f : File | lone f.link  --incorrect 41
-- some f : File | lone link :> f  --incorrect 42
-- some f1,f2,f3:File | (f1->f2 in link and f1->f3 in link) implies f2=f3  --incorrect 43
-- some f1,f2,f3:File | f1->f2 in link and f1->f3 in link implies f2=f3  --incorrect 44
-- some x,y : File | x->y in link --incorrect 45
}

/* There is no deleted link. */
pred inv7 {
	no link.Trash --correct
-- all f : File | f.link not in Trash  --incorrect 1
-- all f : File | no link . f  --incorrect 2
-- all f : File | no link.f  --incorrect 3
-- all f : File | some f1 : File | f->f1 in link implies f not in Trash  --incorrect 4
-- all f,g : File | f->g in link and f not in Trash  --incorrect 5
-- all f,g : File | f->g in link and g not in Trash  --incorrect 6
-- all f,g : File | f->g in link implies f not in Trash and g not in Trash  --incorrect 7
-- all f,g:File | (f->g in link) implies f not in Trash and g not in Trash  --incorrect 8
-- all f,g:File | f->g in link implies f not in Trash  --incorrect 9
-- all f,g:File | f->g in link implies f not in Trash and g not in Trash  --incorrect 10
-- all f,g:File | f->g not in link  --incorrect 11
-- all f1 : File | some f : File | f->f1 in link implies f1 not in Trash  --incorrect 12
-- all f1,f2 : File | (f1 -> f2 in link) implies f1 not in Trash  --incorrect 13
-- all f1,f2 : File | f1 -> f2 in link  --incorrect 14
-- all f1,f2 : File | f1 -> f2 in link implies f1 not in Trash  --incorrect 15
-- all f1,f2 : File | f1 not in Trash and f2 not in Trash  --incorrect 16
-- all f1,f2 : File | f1->f2 in link implies f1 not in Trash  --incorrect 17
-- all f1,f2 : File | f1->f2 in link implies f2 in Trash  --incorrect 18
-- all f1,f2:File | f1 in f2.link implies f2 not in Trash  --incorrect 19
-- all f:File | f.^link not in Trash  --incorrect 20
-- all f:File | f.link in Protected  --incorrect 21
-- all f:File | f.link in Trash  --incorrect 22
-- all f:File | f.link not in Trash  --incorrect 23
-- all f:File | f.link not in Trash and f not in Trash  --incorrect 24
-- all f:File | link.f not in Trash  --incorrect 25
-- all f:File |f.link not in Trash  --incorrect 26
-- all x, y : File | x->y in link and x not in Trash  --incorrect 27
-- all x, y : File | x->y in link and x not in Trash and y not in Trash  --incorrect 28
-- all x, y : File | x->y in link and y not in Trash  --incorrect 29
-- all x, y : File | x->y in link and y not in Trash and x not in Trash  --incorrect 30
-- all x, y : File | x->y in link implies ((x not in Trash) and (y not in Trash))  --incorrect 31
-- all x, y : File | x->y in link implies (x not in Trash and y not in Trash)  --incorrect 32
-- all x, y : File | x->y in link implies x not in Trash  --incorrect 33
-- all x, y : File | x->y in link implies x not in Trash and y not in Trash  --incorrect 34
-- all x,y : File | x->y in link implies x not in Trash  --incorrect 35
-- all x,y :File | (x->y in link and y->x in link) implies x not in Trash and y not in Trash  --incorrect 36
-- all x,y :File | (x->y in link) implies x not in Trash and y not in Trash  --incorrect 37
-- all x,y:File | (x->y in link) implies (x not in Trash and y not in Trash)  --incorrect 38
-- all x,y:File | (x->y in link) implies (x not in Trash or y not in Trash)  --incorrect 39
-- File in Protected  --incorrect 40
-- File.link in Protected  --incorrect 41
-- File.link in Trash  --incorrect 42
-- no f:File | f.link in Trash  --incorrect 43
-- no f:File | link.f in Trash  --incorrect 44
-- no File.link  --incorrect 45
-- no link  --incorrect 46
-- no link.File & Trash  --incorrect 47
-- no Trash & Protected and all f:File | f.link in Protected  --incorrect 48
-- no Trash . link  --incorrect 49
-- no Trash.link  --incorrect 50
-- ~link . link in iden --incorrect 51
}

/* There are no links. */
pred inv8 {
	no link --correct
-- all f : File | f in Trash --incorrect 1
-- all f1,f2 : File | f1 -> f2 in link and f1 in Trash --incorrect 2
-- all f:File |f.link not in File --incorrect 3

}

/* A link does not link to another link. */
pred inv9 {
--	no link.link --correct
-- .link  all f1,f2,f3,f4:File | f1->f2 in link and f3->f4 in link implies f2->f3 not in link  --incorrect 1
-- all f,g:File | f->g in link implies g->f not in link  --incorrect 2
-- some x,y,z : File | x->y in link implies y->z not in link  --incorrect 3
-- all f,g,h:File | f->g in link   --incorrect 4
-- all x,y,z : File | x->y in link and y->z not in link    --incorrect 5
-- all f : File | no link.f.link  --incorrect 6
-- link.~link in iden  --incorrect 7
-- all f1:File,f2:File | not f1.link = f2  --incorrect 8
-- no link.~link  --incorrect 9
 all f1:File,f2:File | not f1.link = f2.link }

/* If a link is deleted, so is the file it links to. */
pred inv10 {
	Trash.link in Trash --correct
-- (link.Trash).link in Trash  --incorrect 1
-- all f :File | f.link in Trash implies link.f in Trash  --incorrect 2
-- all f,g : File | f.link in Trash and g.link in Trash  --incorrect 3
-- all f,g : File | link.f in Trash and link.g in Trash  --incorrect 4
-- all f,g:File | f in Trash implies f->g not in link  --incorrect 5
-- all f,g:File | f->g in link implies g in Trash  --incorrect 6
-- all f,g:File | g in Trash and g!=f implies f->g not in link  --incorrect 7
-- all f,g:File | g in Trash implies f->g not in link  --incorrect 8
-- all f:File | f.link in Trash  --incorrect 9
-- all f:File | f.link in Trash implies f in Trash  --incorrect 10
-- all f:File | f.link in Trash implies f.*link in Trash  --incorrect 11
-- all f:File | f.link in Trash implies link.f in Trash  --incorrect 12
-- all f:File | link.f in Trash implies f.link in Trash  --incorrect 13
-- all x : Trash | all y : File | x->y in link  --incorrect 14
-- all x, y : File | x -> y in link and y in Trash implies x in Trash  --incorrect 15
-- all x, y : File | x->y not in link implies y in Trash  --incorrect 16
-- File in Trash  --incorrect 17
-- File.link & File in Trash  --incorrect 18
-- File.link in Trash  --incorrect 19
-- File.link in Trash => link.File in Trash  --incorrect 20
-- link.File & File in Trash  --incorrect 21
-- link.File + File in Trash  --incorrect 22
-- link.File in Trash => File.link in Trash  --incorrect 23
-- link.File in Trash implies File.link in Trash  --incorrect 24
-- link.Trash & File in Trash  --incorrect 25
-- link.Trash + File in Trash  --incorrect 26
-- link.Trash in Trash  --incorrect 27
-- link.Trash in Trash.link  --incorrect 28
-- no Trash.link  --incorrect 29
-- some f : File | f in Trash implies f.link in Trash  --incorrect 30
-- some f : File | f.link in Trash implies f in Trash  --incorrect 31
-- some f1,f2:File | f1->f2 in link implies f2 in Trash  --incorrect 32
-- some f1,f2:File | f1->f2 not in link implies f2 in Trash  --incorrect 33
-- Trash.link in link.Trash --incorrect 34
}
/*======== IFF PERFECT ORACLE ===============*/
pred inv1_OK {
	no Trash --correct
}
assert inv1_Repaired {
    inv1[] iff inv1_OK[]
}
---------
pred inv2_OK {
	File in Trash --correct
}
assert inv2_Repaired {
    inv2[] iff inv2_OK[]
}
--------
pred inv3_OK {
		some Trash --correct
}
assert inv3_Repaired {
    inv3[] iff inv3_OK[]
}
--------
pred inv4_OK {
  	no Protected & Trash  --correct
}
assert inv4_Repaired {
    inv4[] iff inv4_OK[]
}
--------
pred inv5_OK {
  	File - Protected in Trash  --correct
}
assert inv5_Repaired {
    inv5[] iff inv5_OK[]
}
--------
pred inv6_OK {
  ~link . link in iden  --correct
}
assert inv6_Repaired {
    inv6[] iff inv6_OK[]
}
--------
pred inv7_OK {
 no link.Trash  --correct
}
assert inv7_Repaired {
    inv7[] iff inv7_OK[]
}
--------
pred inv8_OK {
 	no link --correct
}
assert inv8_Repaired {
    inv8[] iff inv8_OK[]
}
--------
pred inv9_OK {
  no link.link  --correct
}
assert inv9_Repaired {
    inv9[] iff inv9_OK[]
}
--------
pred inv10_OK {
  Trash.link in Trash --correct
}
assert inv10_Repaired {
    inv10[] iff inv10_OK[]
}


-- PerfectOracleCommands
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
pred repair_pred_1{inv9[] iff inv9_OK[] }
run repair_pred_1
assert repair_assert_1{inv9[] iff inv9_OK[] }
check repair_assert_1
