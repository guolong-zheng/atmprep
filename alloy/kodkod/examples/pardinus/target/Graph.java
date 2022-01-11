package kodkod.examples.pardinus.target;
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

public final class Graph {
	private Relation node, adj, color;
	
	/**
	 * Problem has 3 relations: nodes, their adjacent nodes and their color.
	 */
	public Graph() {
		node = Relation.unary("Node");
		adj = Relation.binary("adj");
		color = Relation.binary("color");
	}
	
	/**
	 * Creates a target-oriented problem with given size.
	 * @param size the number of nodes.
	 * @param back the size of the backlinks (== size of inconsistency)
	 * @return
	 */
	public Bounds bounds(int size, int back) {
		
		// creates nodes (Ni) and colors (Ci)
		List<String> atoms = new LinkedList<String>();
		for (int i = 0; i < size; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i < size; i++) {
			atoms.add("C" + i);
		}
		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		String lastN = "N" + (size-1);
		String lastC = "C" + (size-1);
		TupleFactory factory = universe.factory();
		
		bounds.boundExactly(node,factory.range(factory.tuple("N0"),factory.tuple(lastN)));
		//bounds.boundExactly(colors,factory.range(factory.tuple("C0"),factory.tuple(lastC)));
		
		TupleSet adj_bound = factory.noneOf(2);
		for (int i = 1; i < size; i++) {
			adj_bound.add(factory.tuple("N"+(i-1),"N"+i));
		}
		adj_bound.add(factory.tuple("N"+(size-1),"N"+(size-1-back)));
		bounds.boundExactly(adj, adj_bound);
				
		bounds.bound(color, factory.area(factory.tuple("N0","C0"), factory.tuple(lastN,lastC)));
		TupleSet color_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			color_bound.add(factory.tuple("N"+i,"C"+i));
		}
		bounds.setTarget(color, color_bound);
		
		return bounds;
	}
	
	/**
	 * Creates a problem with given size.
	 * @param size the number of nodes.
	 * @param back the size of the backlinks (== size of inconsistency)
	 * @return
	 */
	public Bounds bounds_notarget(int size, int back) {
		
		List<String> atoms = new LinkedList<String>();
		for (int i = 0; i < size; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i < size; i++) {
			atoms.add("C" + i);
		}
		Universe universe = new Universe(atoms);
		Bounds bounds = new Bounds(universe);
		String lastN = "N" + (size-1);
		String lastC = "C" + (size-1);
		TupleFactory factory = universe.factory();
		
		bounds.boundExactly(node,factory.range(factory.tuple("N0"),factory.tuple(lastN)));
		//bounds.boundExactly(colors,factory.range(factory.tuple("C0"),factory.tuple(lastC)));
		
		TupleSet adj_bound = factory.noneOf(2);
		for (int i = 1; i < size; i++) {
			adj_bound.add(factory.tuple("N"+(i-1),"N"+i));
		}
		adj_bound.add(factory.tuple("N"+(size-1),"N"+(size-1-back)));
		bounds.boundExactly(adj, adj_bound);
				
		bounds.bound(color, factory.area(factory.tuple("N0","C0"), factory.tuple(lastN,lastC)));
		
		return bounds;
	}
	
	/**
	 * Creates a weighted target-oriented problem with given size.
	 * @param size the number of nodes.
	 * @param back the size of the backlinks (== size of inconsistency)
	 * @return
	 */
	public Bounds bounds_weights(int size, int back) {
		
		// creates nodes (Ni) and colors (Ci)
		List<String> atoms = new LinkedList<String>();
		for (int i = 0; i < size; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i < size; i++) {
			atoms.add("C" + i);
		}
		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		String lastN = "N" + (size-1);
		String lastC = "C" + (size-1);
		TupleFactory factory = universe.factory();
		
		bounds.boundExactly(node,factory.range(factory.tuple("N0"),factory.tuple(lastN)));
		//bounds.boundExactly(colors,factory.range(factory.tuple("C0"),factory.tuple(lastC)));
		
		bounds.bound(adj, factory.area(factory.tuple("N0","N0"), factory.tuple(lastN,lastN)));
		TupleSet adj_bound = factory.noneOf(2);
		for (int i = 1; i < size; i++) {
			adj_bound.add(factory.tuple("N"+(i-1),"N"+i));
		}
		adj_bound.add(factory.tuple("N"+(size-1),"N"+(size-1-back)));
		bounds.setTarget(adj, adj_bound);
				
		bounds.bound(color, factory.area(factory.tuple("N0","C0"), factory.tuple(lastN,lastC)));
		TupleSet color_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			color_bound.add(factory.tuple("N"+i,"C"+i));
		}
		bounds.setTarget(color, color_bound);
		
		bounds.setWeight(adj, 8);
		bounds.setWeight(color, 1);
		
		return bounds;
	}
	
	/**
	 * Constraint enforcing single color.
	 * @param color the set of colors
	 * @return
	 */
	public Formula onecolor(Relation color) {
		Variable n = Variable.unary("n");
		Formula body = n.join(color).one();
		return body.forAll(n.oneOf(node));
	}
	
	/**
	 * Constraint enforcing partitions
	 * @param color
	 * @return
	 */
	public Formula samecolor(Relation color) {
		Variable x = Variable.unary("x");
		Variable y = Variable.unary("y");
		Formula body = x.in(y.join(adj.reflexiveClosure())).and(y.in(x.join(adj.reflexiveClosure()))).iff(x.join(color).eq(y.join(color)));
		return(body.forAll(x.oneOf(node).and(y.oneOf(node))));
	}
	
	/**
	 * Overall problem
	 * @return
	 */
	public Formula model() {
		return onecolor(color).and(samecolor(color));
	}
			
	/**
	 * Solves a target-oriented problem with provided size and backlinks.
	 * @param size
	 * @param back
	 * @param maxSATSolver
	 * @return
	 */
	public static long graph(int size, int back, SATFactory maxSATSolver) {
		Graph model = new Graph();
		Solver solver = new Solver();
//		solver.options().setSolver(SATFactory.externalPMaxSATFactory("/Users/alcino/Documents/workspace/Exemplos/yices", "graph_"+size+"_"+back+".wcnf", 2));
//		solver.options().setSolver(SATFactory.PMaxSAT4J);
		solver.options().setSolver(maxSATSolver);
		solver.options().setBitwidth(1);
		//solver.options().setSymmetryBreaking(0);
		Solution sol = solver.solve(model.model(),model.bounds(size,back));
		//System.out.println(sol.stats());
		System.out.println(sol);
		solver.free();
		return(sol.stats().translationTime()+sol.stats().solvingTime());
	}

	/**
	 * Runs a batch of target-oriented problems.
	 * @param maxSATSolver
	 * @return
	 */
	public static void target(SATFactory maxSATSolver) {
		long res[][] = new long[10][6];
		for (int size=10; size<=30; size+=10) {
			for (int delta=0; delta<=5; delta++) {
				//System.out.println("Size: "+size);
				//System.out.println("Delta: "+delta);
				res[size/10-1][delta] = graph(size,delta,maxSATSolver);				
			}
		}
		for (int i=0; i<10; i++) {
			for (int j=0; j<6; j++) {
				System.out.print(res[i][j]);
				if (j<5) {
					System.out.print("\t");
				} else {
					System.out.println();
				}
			}
		}
	}

	/**
	 * Solves a standard problem with provided size and backlinks.
	 * @param size
	 * @param back
	 * @param maxSATSolver
	 * @return
	 */
	public static long graph_notarget(int size, int back,SATFactory satSolver) {
		Graph model = new Graph();
		Solver solver = new Solver();
		solver.options().setSolver(satSolver);
//		System.out.println(solver.toString());
		solver.options().setBitwidth(1);
		Solution sol = solver.solve(model.model(),model.bounds_notarget(size,back));
		//System.out.println(sol);
		solver.free();
		return(sol.stats().translationTime()+sol.stats().solvingTime());
	}
	
	/**
	 * Solves a batch of standard problems.
	 * @param maxSATSolver
	 * @return
	 */
	public static void notarget(SATFactory satSolver) {
		long res[][] = new long[10][6];
		for (int size=10; size<=30; size+=10) {
			for (int delta=0; delta<=5; delta++) {
				System.out.println("Size: "+size);
				System.out.println("Delta: "+delta);
				
				res[size/10-1][delta] = graph_notarget(size,delta,satSolver);		
				//System.out.println(res[size/10-1][delta]);
			}
		}
		for (int i=0; i<10; i++) {
			for (int j=0; j<6; j++) {
				System.out.print(res[i][j]);
				if (j<5) {
					System.out.print("\t");
				} else {
					System.out.println();
				}
			}
		}
	}

	/**
	 * Solves a weighted target-oriented problem with provided size and backlinks.
	 * @param size
	 * @param back
	 * @param maxSATSolver
	 * @return
	 */
	public static long graph_weights(int size, int back, SATFactory maxSATSolver) {
		Graph model = new Graph();
		Solver solver = new Solver();
//		solver.options().setSolver(SATFactory.externalPMaxSATFactory("/Users/alcino/Documents/workspace/Exemplos/yices", "graph_"+size+"_"+back+".wcnf", 2));
//		solver.options().setSolver(SATFactory.PMaxSAT4J);
		solver.options().setSolver(maxSATSolver);
		solver.options().setBitwidth(1);
		//solver.options().setSymmetryBreaking(0);
		Solution sol = solver.solve(model.model(),model.bounds_weights(size,back));
		//System.out.println(sol.stats());
		System.out.println(sol);
		return(sol.stats().translationTime()+sol.stats().solvingTime());
	}

	
	public static void main(String args[]) {
		System.out.println(graph_weights(5,3,SATFactory.PMaxSAT4J));
		//System.out.println("tempo = " + graph_notarget(100,0));
		//System.out.println("tempo = " + graph_notarget(100,1));
		//System.out.println("tempo = " + graph_notarget(90,5));
		//notarget();
		//test();
	}
}
