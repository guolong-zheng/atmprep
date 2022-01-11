
abstract sig Source {}
sig User extends Source {
    profile : set Work,
    visible : set Work
}
sig Institution extends Source {}

sig Id {}
sig Work {
    ids : some Id,
    source : one Source
}

// Specify the following invariants!
// You can check their correctness with the different commands and
// specifying a given invariant you can assume the others to be true.

pred inv1 { // The works publicly visible in a curriculum must be part of its profile
	all u:User | u.visible in u.profile --correct
--  all w : Work | some (User<:visible).w implies some w.(User<:profile)  --incorrect 1
--  all w : Work | some (User<:visible).w implies some w.(User<:profile)   --incorrect 2
--  all w : Work | some w.(User<:visible) implies some w.(User<:profile)  --incorrect 3
--  all u : User, w : Work | u->w in visible and u->w in profile  --incorrect 4
--  User.visible in User.profile  --incorrect 5
--  all w1, w2 : Work | w1->w2 in visible and w1->w2 in profile  --incorrect 6
--  Work in User.profile  --incorrect 7
--  all w : Work | some (User<:visible).w  --incorrect 8
--  all w : Work | some (User<:visible).w implies some (User<:profile).w  --incorrect 9
--  all w1, w2 : Work | w1->w2 in profile  --incorrect 10
--  Work in User.profile  --incorrect 11
--  some (User<:visible).Work implies some (User<:profile).Work   --incorrect 12
--  some User.visible  --incorrect 13
--  User.visible in User.profile  --incorrect 14
--  User.visible in User.profile  --incorrect 15
--  User.visible in User.profile & User  --incorrect 16
--  all u : User, w : Work | u->w in visible and u->w in profile  --incorrect 17
--  all w : Work | some (User<:visible).w implies some (User<:profile).w   --incorrect 18
--  (User<:visible).Work in (User<:profile).Work   --incorrect 19
--  Work in User.profile + User.visible  --incorrect 20
--  User.visible in User.profile  --incorrect 21
--  no User  --incorrect 22
--  all w : Work | some (User<:visible).w implies some w.(User<:profile)  --incorrect 23
--  Work in User.profile & User.visible  --incorrect 24
--  all u : User, w : Work | u->w in profile  --incorrect 25
--  User.visible in User.profile & User  --incorrect 26
--  all w : Work | some (User<:visible).w implies some w.(User<:profile)  --incorrect 27
}


pred inv2 { // A user profile can only have works added by himself or some external institution
--all u:User, w:Work | w in u.profile implies (u in w.source or some i:Institution | i in w.source) --correct
--  all u : User, w : Work | u->w in profile implies (u.source in User or u.source in Institution)  --incorrect 1
--  all u : User | some (u<:profile).Work implies some u.(Work<:source) & Institution.(Work<:source)    --incorrect 2
--  all u:User ,i:Institution | u.profile.source = u  --incorrect 3
--  all u : User| some w : Work | u->w in profile implies (w.source in User or w.source in Institution)  --incorrect 4
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution     --incorrect 5
--  all u : User | u.profile.ids in u + Institution  --incorrect 6
--  all u : User | (u<:profile).Work in (Work<:source).u & (Work<:source).Institution   --incorrect 7
--  all w : Work | w.source in Source  --incorrect 8
--  all u:User , w:Work |some i:Institution| (w in u.profile) implies (w.source = u || w.source = i)   --incorrect 9
--  all u : User | (u<:profile).Work in (Work<:source).u + (Work<:source).Institution  --incorrect 10
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution    --incorrect 11
--  all u : User | (u<:profile).Work in (Work<:source).u + (Work<:source).Institution   --incorrect 12
--  all u:User, w:Work, i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 13
--  all u : User, w : Work | u->w in profile implies (w.source in User or w.source in Institution)  --incorrect 14
--  all w:Work | (w in User.profile) implies (User = w.source)   --incorrect 15
--  all u:User, w:Work | some i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 16
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution   --incorrect 17
--  all u : User | some (u<:profile).Work implies some (Work<:source).u or some (Work<:source).Institution   --incorrect 18
--  all u:User , w:Work, i:Institution | w in u.profile && w.source = u || w.source = i  --incorrect 19
--  all u:User, w:Work | w in u.profile implies (some i:Institution | u in w.source or i in w.source)  --incorrect 20
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution   --incorrect 21
--  all u : User | (Work<:source).u in (Work<:source).Institution   --incorrect 22
--  all u:User, w:Work | some i:Institution | w in u.profile implies u in w.source or i in w.source  --incorrect 23
--  all u : User | (u<:profile).Work in (Work<:source).u + (Work<:source).Institution   --incorrect 24
--  all u : User | some (u<:profile).Work implies some (Work<:source).u & (Work<:source).Institution   --incorrect 25
--  all u:User , w:Work, i:Institution | w in u.profile && (w.source = u || w.source = i)  --incorrect 26
--  all u : User | some (u<:profile).Work implies some u.(Work<:source) & Institution.(Work<:source)   --incorrect 27
--  all u:User, w:Work | w in u.profile implies u in w.source  --incorrect 28
--  all u : User | u.profile.ids in (u + Institution)  --incorrect 29
  all u : User | some w : Work | u->w in profile implies (w.source in Institution or w.source in User) --  all u : User | some w : Work | u->w in profile implies some (w<:source).Institution or some (w<:source).User  --incorrect 31
--  all u:User , w:Work, i:Institution | w in u.profile && (w.source = u)  --incorrect 32
--  all u:User, w:(u.profile + u.visible) | w in (u+Institution)  --incorrect 33
--  Work.source in (User+Institution)  --incorrect 34
--  all u:User ,i:Institution | u.profile.source = u || u.profile.source = i  --incorrect 35
--  all w:Work | (w in User.profile) implies (w.source = User )   --incorrect 36
--  all u:User , w:Work | (w in u.profile) implies (w.source = u )   --incorrect 37
--  all u : User | some w : Work | u->w in profile implies (Institution in w.source or User in w.source)  --incorrect 38
--  all u:User, w:Work | some i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 39
--  all u:User, w:Work | some i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 40
--  all u:User, w:Work | some i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 41
--  all u : User | some (Work<:source).u or some (Work<:source).Institution   --incorrect 42
--  all u : User | some (u<:profile).Work implies some (Work<:source).u + (Work<:source).Institution   --incorrect 43
--  all u:User,w:Work | some i:Institution | w in u.profile implies (w.source = i or w.source = u)  --incorrect 44
--  all u : User | Work.(u<:profile) in (Work<:source).u & (Work<:source).Institution   --incorrect 45
--  all u : User | Work.(u<:profile) in u.(Work<:source) + Institution.(Work<:source)     --incorrect 46
--  all u : User | (u<:profile).Work in (Work<:source).u + (Work<:source).Institution  --incorrect 47
--  all u : User | (u<:profile).Work in u.(Work<:source) + Institution.(Work<:source)     --incorrect 48
--  all u : User | Work.(u<:profile) in u.(Work<:source) + (Work<:source).Institution     --incorrect 49
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution   --incorrect 50
--  all u:User, w:Work, i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 51
--  all u : User | some (u<:profile).Work implies some (Work<:source).u & (Work<:source).Institution   --incorrect 52
--  all u:User, w:(u.profile + u.visible) | w in (u+Institution)  --incorrect 53
--  all u:User , w:Work | (w in u.profile) implies (w.source = u || w.source = Institution)   --incorrect 54
--  all u : User | Work.(u<:profile) in (Work<:source).u + (Work<:source).Institution  --incorrect 55
--  all u:User, w:Work, i:Institution | w in u.profile implies (u in w.source || i in w.source)  --incorrect 56
--  all w:Work | (w in User.profile) && (User = w.source)   --incorrect 57
--  all u:User, w:Work | some i:Institution | w in u.profile implies (u in w.source or i in w.source)  --incorrect 58
--  all u:User, w:Work, i:Institution | w in u.profile implies u in w.source or i in w.source  --incorrect 59
--  all u:User , w:Work | w in u.profile && one w.source --incorrect 60
}


pred inv3 { // The works added to a profile by a given source cannot have common identifiers
	all w1, w2 : Work, u : User | w1 != w2 and (w1 + w2) in u.profile and (w1.source = w2.source) implies no w1.ids & w2.ids --correct
--  all w:Work, w1:Work | (w in User.profile && w1 in User.profile) implies no (w.ids & w1.ids)  --incorrect 1
--  all w1, w2:Work, u:User | (w1 in u.profile and w2 in u.profile) implies w1.ids != w2.ids    --incorrect 2
--  all u:User, w1, w2:Work | w1 in u.profile and w2 in u.profile implies w1.ids not in w2.ids  --incorrect 3
--  all w:Work, w1:Work | no (w.ids & w1.ids)  --incorrect 4
--  all w:Work, w1:Work | (w in User.profile && w1 in User.profile) implies no (w.ids & w1.ids)  --incorrect 5
--  all u: User | all w1, w2: u.profile | not w1.ids = w2.ids  --incorrect 6
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.ids) and (w1.source = w2.source)) implies no (w1.ids & w2.ids)  --incorrect 7
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies (w1.ids != w2.ids)  --incorrect 8
--  all u:User, w:Work, w1:Work | w.source = w1.source && w1 in u.profile && w in u.profile implies w.ids != w1.ids  --incorrect 9
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and no (w1.ids & w2.ids) and (w1.source = w2.source)) implies (w1=w2)  --incorrect 10
--  lone Work<:(User.profile)  --incorrect 11
--  all u:User, w1, w2:Work | w1 in u.profile and w2 in u.profile implies w1.ids not in w2.ids and w2.ids not in w1.ids  --incorrect 12
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.^ids = w2.ids)) implies w1=w2  --incorrect 13
--  all u: User, w1, w2: u.profile | w1.ids != w2.ids  --incorrect 14
--  all w1, w2:Work, u:User, i:Id | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies (w1.ids != w2.ids)  --incorrect 15
--  all w:Work | lone w.ids  --incorrect 16
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies  (w1.ids not in w2.ids and w2.ids not in w1.ids)  --incorrect 17
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.ids) and (w1.source = w2.source)) implies w1=w2  --incorrect 18
--  all w1, w2:Work, u:User | (w1 in u.profile and w2 in u.profile) implies  (w1.ids not in w2.ids and w2.ids not in w1.ids)  --incorrect 19
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.*ids) and (w1.source = w2.source)) implies w1=w2  --incorrect 20
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies (w1.ids != w2.ids)  --incorrect 21
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies no (w1.ids & w2.ids)  --incorrect 22
--  Work<:ids != Work<:ids  --incorrect 23
--  all w1, w2:Work, u:User | (w1 in u.profile and w2 in u.profile) implies w1.ids!=w2.ids   --incorrect 24
--  all w1, w2:Work, u:User | (w1 in u.profile and w2 in u.profile) implies no (w1.ids & w2.ids)  --incorrect 25
--  all w:Work, w1:Work | w in User.profile && w1 in User.profile implies no (w.ids & w1.ids)  --incorrect 26
--  all w1, w2:Work, u:User | (w1 in u.profile and w2 in u.profile) and (w1.source=w2.source) implies no (w1.ids & w2.ids)  --incorrect 27
--  all x, y : Work | x.ids != y.ids  --incorrect 28
--  all w:Work, w1:Work | (w in User.profile && w1 in User.profile) implies no (w.ids & w1.ids)  --incorrect 29
--  all w1, w2 : Work | some u : User | w1 != w2 and (w1 + w2) in u.profile implies no w1.ids & w2.ids  --incorrect 30
--  all w1, w2 : Work | some u : User | w1 != w2 and (w1 + w2) in u.profile and (w1.source = w2.source) implies no w1.ids & w2.ids  --incorrect 31
--  all w1,w2:Work | w1.ids = w2.ids implies w1 = w2  --incorrect 32
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.^ids = w2.^ids)) implies w1=w2  --incorrect 33
--  Work<:ids != Work<:ids  --incorrect 34
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.ids)) implies w1=w2  --incorrect 35
--  all w1, w2 : Work | some u : User, s : Source | w1 != w2 and (w1 + w2) in u.profile and (w1.source = w2.source) implies no w1.ids & w2.ids  --incorrect 36
--  all u: User, w1, w2: u.profile | all i: w1.ids | i not in w2.ids  --incorrect 37
--  all x, y : Work | x<:ids != y<:ids  --incorrect 38
--  all u:User, w:Work, w1:Work | w1 in u.profile && w in u.profile implies w.ids != w1.ids  --incorrect 39
--  all w:(User.profile) | lone w.ids  --incorrect 40
--  ~ids.ids in iden  --incorrect 41
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.*ids = w2.*ids) and (w1.source = w2.source)) implies w1=w2  --incorrect 42
--  Work<:ids != Work<:ids  --incorrect 43
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.ids)) implies w1=w2  --incorrect 44
--  all x, y : Work | no x.ids & y.ids  --incorrect 45
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies no (w1.ids & w2.ids)  --incorrect 46
--  all u: User, w1, w2: u.profile, i: w1.ids | i not in w2.ids  --incorrect 47
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.ids = w2.ids) and (w1.source = w2.source)) implies w1=w2  --incorrect 48
--  all w1, w2:Work, u:User | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies (w1.ids != w2.ids)  --incorrect 49
--  all w1, w2:Work, u:User, i:Id | ((w1 in u.profile and w2 in u.profile) and (w1.source = w2.source)) implies (w1.ids != w2.ids)  --incorrect 50
--  all u:User , s:Source| lone (u.profile.source & s).ids  --incorrect 51
}
/*======== IFF PERFECT ORACLE ===============*/
pred inv1_OK {
	all u:User | u.visible in u.profile --correct
}
assert inv1_Repaired {
    inv1[] iff inv1_OK[]
}
---------
pred inv2_OK {
		all u:User, w:Work | w in u.profile implies (u in w.source or some i:Institution | i in w.source) --correct
}
assert inv2_Repaired {
    inv2[] iff inv2_OK[]
}
--------
pred inv3_OK {
		all w1, w2 : Work, u : User | w1 != w2 and (w1 + w2) in u.profile and (w1.source = w2.source) implies no w1.ids & w2.ids --correct
}
assert inv3_Repaired {
    inv3[] iff inv3_OK[]
}


-- PerfectOracleCommands
 check inv1_Repaired expect 0
 check inv2_Repaired expect 0
 check inv3_Repaired expect 0 
pred repair_pred_1{inv2[] iff inv2_OK[] }
run repair_pred_1
assert repair_assert_1{inv2[] iff inv2_OK[] }
check repair_assert_1
