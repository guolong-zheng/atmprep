package kodkod.examples.pardinus.target;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import kodkod.ast.*;
import kodkod.engine.Solution;
import kodkod.engine.Solver;
import kodkod.engine.satlab.SATFactory;
import kodkod.instance.*;

/**
 * Target-oriented model finding example: graph coloring.
 * @author Tiago Guimarães, Alcino Cunha, Nuno Macedo // [HASLab] target-oriented model finding
 */

public final class Basic {
	private Relation as, rs;
	
	/**
	 * Problem has 3 relations: nodes, their adjacent nodes and their color.
	 */
	public Basic() {
		as = Relation.unary("A");
		rs = Relation.binary("r");
	}
	
	public Bounds bounds(int size) {
		
		// creates nodes (Ni) and colors (Ci)
		List<String> atoms = new LinkedList<String>();
		for (int i = 0; i < size; i++) {
			atoms.add("A" + i);
		}

		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		String lastA = "A" + (size-1);
		TupleFactory factory = universe.factory();
		
		bounds.bound(as,factory.range(factory.tuple("A0"),factory.tuple(lastA)));
		bounds.setTarget(as, factory.range(factory.tuple("A0"),factory.tuple(lastA)));
				
		bounds.bound(rs, factory.area(factory.tuple("A0","A0"), factory.tuple(lastA,lastA)));
		TupleSet color_bound = factory.noneOf(2);
//		color_bound.add(factory.tuple("A0","A0"));
		bounds.setTarget(rs, color_bound);
		
		bounds.setWeight(as, 2);
		bounds.setWeight(rs, 1);
		
		System.out.println(bounds);
		
		return bounds;
	}
	
	
	/**
	 * Constraint enforcing single color.
	 * @param color the set of colors
	 * @return
	 */
	public Formula lonecolor(Relation color) {
		Variable n = Variable.unary("n");
		Formula body = n.join(color).one();
		return body.forAll(n.oneOf(as));
	}

	/**
	 * Overall problem
	 * @return
	 */
	public Formula model() {
		return lonecolor(rs);
	}
			
	/**
	 * Solves a target-oriented problem with provided size and backlinks.
	 * @param size
	 * @param back
	 * @param maxSATSolver
	 * @return
	 */
	public static long graph(int size, SATFactory maxSATSolver) {
		Basic model = new Basic();
		Solver solver = new Solver();
//		solver.options().setSolver(SATFactory.externalPMaxSATFactory("/Users/alcino/Documents/workspace/Exemplos/yices", "graph_"+size+"_"+back+".wcnf", 2));
//		solver.options().setSolver(SATFactory.PMaxSAT4J);
		solver.options().setSolver(maxSATSolver);
		solver.options().setBitwidth(1);
		//solver.options().setSymmetryBreaking(0);
		Iterator<Solution> sols = solver.solveAll(model.model(),model.bounds(size));
		Solution sol = sols.next();
		//System.out.println(sol.stats());
		System.out.println(sol);
		sol = sols.next();
		System.out.println(sol);
		sol = sols.next();
		System.out.println(sol);
		sol = sols.next();
		System.out.println(sol);
		return(sol.stats().translationTime()+sol.stats().solvingTime());
	}

	
	public static void main(String args[]) {
		System.out.println(graph(1,SATFactory.PMaxSAT4J));
		//System.out.println("tempo = " + graph_notarget(100,0));
		//System.out.println("tempo = " + graph_notarget(100,1));
		//System.out.println("tempo = " + graph_notarget(90,5));
		//notarget();
		//test();
	}
}
