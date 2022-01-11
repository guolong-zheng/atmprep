package kodkod.examples.pardinus.target;

import java.util.ArrayList;
import java.util.List;

import kodkod.ast.Formula;
import kodkod.ast.IntConstant;
import kodkod.ast.Relation;
import kodkod.engine.Solution;
import kodkod.engine.Solver;
import kodkod.engine.satlab.SATFactory;
import kodkod.instance.Bounds;
import kodkod.instance.TupleFactory;
import kodkod.instance.Universe;

public class Weight_Test {
	
	public static void main(String[] args) {
		String a1 = "atom1";
		String a2 = "atom2";
		String a3= "atom3";
		List<Object> atoms = new ArrayList<Object>();
		atoms.add(a1);
		atoms.add(a2);
		atoms.add(a3);
		Universe uni = new Universe(atoms);
		TupleFactory fac = uni.factory();
		
		Relation a = Relation.unary("A");
		Relation b = Relation.binary("b");
		
		Bounds bounds = new Bounds(uni);
		
		bounds.bound(a, fac.setOf(a1,a2,a3));
		bounds.bound(b, fac.setOf(a1,a2,a3).product(fac.setOf(a1,a2,a3)));
		
		Formula f = b.count().eq(IntConstant.constant(2)).and(
				b.in(a.product(a)));
		
//		bounds.setWeight(a, fac.tuple("atom1"), 1);
//		bounds.setWeight(a, fac.tuple("atom3"), 1);
//		
//		bounds.setWeight(b, fac.tuple("atom1","atom3"), 1);
//		bounds.setWeight(b, fac.tuple("atom3","atom3"), 6);
//
//		bounds.setWeight(b, fac.tuple("atom3","atom1"), 3);
//		
		
		/*bounds.setTarget(a, fac.setOf(a1,a3));
		bounds.setTarget(b, fac.setOf(fac.tuple(a1, a3),fac.tuple(a3,a3)));*/
		Solver solver = new Solver();
		
		solver.options().setSolver(SATFactory.PMaxSAT4J);
		
		Solution sol = solver.solve(f, bounds);
		
		System.out.println(sol.instance());
	}

}
