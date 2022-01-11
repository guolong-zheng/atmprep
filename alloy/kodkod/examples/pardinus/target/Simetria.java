package kodkod.examples.pardinus.target;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import kodkod.ast.*;
import kodkod.engine.Solution;
import kodkod.engine.Solver;
import kodkod.engine.satlab.SATFactory;
import kodkod.instance.Bounds;
import kodkod.instance.PardinusBounds;
import kodkod.instance.TupleFactory;
import kodkod.instance.Universe;

/**
 * Target-oriented model finding example: symmetry.
 * @author Tiago Guimarães, Alcino Cunha, Nuno Macedo // [HASLab] target-oriented model finding
 */
public final class Simetria {
	private Relation set;
	
	public Simetria() {
		set = Relation.unary("set");
	}
	
	public Bounds bounds(int size) {
		List<String> atoms = new LinkedList<String>();
		for (int i = 0; i < size; i++) {
			atoms.add("A" + i);
		}
		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		TupleFactory factory = universe.factory();
		bounds.bound(set,factory.range(factory.tuple("A0"),factory.tuple("A"+(size-1))));
		bounds.setTarget(set, factory.range(factory.tuple("A0"), factory.tuple("A2")));
		return bounds;
	}
	
	public Formula formula(int size) {
		// return (Formula.TRUE);
		return (set.count().eq(IntConstant.constant(size)));
	}
	
	public static void main(String args[]) {
		Simetria model = new Simetria();
		Solver solver = new Solver();
//		solver.options().setSolver(SATFactory.externalPMaxSATFactory("/Users/alcino/Documents/workspace/Exemplos/yices", null, 2));
//		solver.options().setSolver(SATFactory.IncrementalSAT4J);
		solver.options().setSolver(SATFactory.PMaxSAT4J);
		solver.options().setBitwidth(5);
		solver.options().setSymmetryBreaking(3);
		Iterator<Solution> sols = solver.solveAll(model.formula(3),model.bounds(5));
		while (sols.hasNext()) {
			System.out.println(sols.next().toString());			
		}
	}
}
