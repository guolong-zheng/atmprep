package kodkod.examples.pardinus.target;
import java.util.LinkedList;
import java.util.List;

import kodkod.ast.Formula;
import kodkod.ast.Relation;
import kodkod.ast.Variable;
import kodkod.engine.Solution;
import kodkod.engine.Solver;
import kodkod.engine.satlab.SATFactory;
import kodkod.instance.Bounds;
import kodkod.instance.PardinusBounds;
import kodkod.instance.TupleFactory;
import kodkod.instance.TupleSet;
import kodkod.instance.Universe;

/**
 * Target-oriented model finding example: class diagrams to relational database schemas.
 * @author Tiago Guimarães, Alcino Cunha, Nuno Macedo // [HASLab] target-oriented model finding
 */
public class Cd2Rdbms {
	private Relation classes, parent, persistent,class_name,attributes,names;
	private Relation tables, table_name, columns;
	
	
	public Cd2Rdbms() {
		classes = Relation.unary("classes");
		parent = Relation.binary("parent");
		attributes = Relation.binary("attributes");
		persistent = Relation.unary("persistent");
		class_name = Relation.binary("class_name");
		names = Relation.unary("names");

		tables = Relation.unary("tables");
		table_name = Relation.binary("table_name");		
		columns = Relation.binary("columns");
	}
	
	public Bounds bounds(int size, int maxdelta, int change) {
		
		List<String> atoms = new LinkedList<String>();
		
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("C" + i);
		}
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i <= size; i++) {
			atoms.add("T" + i);
		}
			
		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		TupleFactory factory = universe.factory();

		String lastC  = "C" + (2*size+maxdelta-1);
		String lastN  = "N" + (2*size+maxdelta-1);
		String lastT  = "T" + (size-1);

		bounds.bound(classes, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		bounds.setTarget(classes, factory.range(factory.tuple("C0"), factory.tuple("C"+(2*size-1))));

		bounds.bound(names, factory.range(factory.tuple("N0"), factory.tuple(lastN)));
		bounds.setTarget(names, factory.range(factory.tuple("N0"), factory.tuple("N"+(2*size-1))));

		bounds.bound(persistent, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		bounds.setTarget(persistent, factory.range(factory.tuple("C0"), factory.tuple("C"+(size-1))));

		bounds.bound(class_name, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		TupleSet class_name_bound = factory.noneOf(2);
		for (int i = 0; i < 2*size; i++) {
			class_name_bound.add(factory.tuple("C"+i,"N"+i));
		}
		bounds.setTarget(class_name, class_name_bound);

		bounds.bound(parent, factory.area(factory.tuple("C0","C0"), factory.tuple(lastC,lastC)));
		TupleSet parent_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			parent_bound.add(factory.tuple("C"+(i+size),"C"+i));
		}
		for (int i = 1; i < size; i++) {
			parent_bound.add(factory.tuple("C"+i,"C"+(i-1)));
		}
		bounds.setTarget(parent, parent_bound);

		bounds.bound(attributes, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		TupleSet attributes_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			attributes_bound.add(factory.tuple("C"+i,"N"+i));
		}
		bounds.setTarget(attributes, attributes_bound);

		TupleSet tables_bound = factory.range(factory.tuple("T0"),factory.tuple(lastT));
		if (change > 0) {
			tables_bound.add(factory.tuple("T"+size));
		}
		bounds.boundExactly(tables,tables_bound);

		TupleSet table_name_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			table_name_bound.add(factory.tuple("T"+i,"N"+i));
		}
		if (change > 0) {
			table_name_bound.add(factory.tuple("T"+size,"N"+(2*size-1)));
		}
		bounds.boundExactly(table_name, table_name_bound);

		TupleSet columns_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			for (int k = 0; k <= i; k++) {
				columns_bound.add(factory.tuple("T"+i,"N"+k));
			}
		}
		if (change > 0) {
			for (int i = 0; i < size+change-1; i++) {
				columns_bound.add(factory.tuple("T"+size,"N"+i));
			}
		}
		bounds.boundExactly(columns, columns_bound);

		return bounds;
	}
	
public Bounds bounds_restricted(int size, int maxdelta, int change){
		
		//TODO
		List<String> atoms = new LinkedList<String>();
		
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("C" + i);
		}
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i <= size; i++) {
			atoms.add("T" + i);
		}
			
		Universe universe = new Universe(atoms);
		Bounds bounds = new Bounds(universe);
		TupleFactory factory = universe.factory();

		String lastC  = "C" + (2*size+maxdelta-1);
		String lastN  = "N" + (2*size+maxdelta-1);
		String lastT  = "T" + (size-1);

		bounds.boundExactly(classes, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		//bounds.setTarget(classes, factory.range(factory.tuple("C0"), factory.tuple("C"+(2*size-1))));

		bounds.boundExactly(names, factory.range(factory.tuple("N0"), factory.tuple(lastN)));
		//bounds.setTarget(names, factory.range(factory.tuple("N0"), factory.tuple("N"+(2*size-1))));

		bounds.bound(persistent, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		//bounds.setTarget(persistent, factory.range(factory.tuple("C0"), factory.tuple("C"+(size-1))));

		/*TupleSet class_name_bound = factory.noneOf(2);
		for (int i = 0; i < 2*size; i++) {
			class_name_bound.add(factory.tuple("C"+i,"N"+i));
		}*/
		bounds.bound(class_name,  factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		/*
		//bounds.setTarget(class_name, class_name_bound);*/

		TupleSet parent_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			parent_bound.add(factory.tuple("C"+(i+size),"C"+i));
		}
		for (int i = 1; i < size; i++) {
			parent_bound.add(factory.tuple("C"+i,"C"+(i-1)));
		}
		bounds.boundExactly(parent, parent_bound);
		/*
		bounds.setTarget(parent, parent_bound);*/

		TupleSet attributes_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			attributes_bound.add(factory.tuple("C"+i,"N"+i));
		}
		bounds.boundExactly(attributes,attributes_bound);
		/*
		//bounds.setTarget(attributes, attributes_bound);*/

		TupleSet tables_bound = factory.range(factory.tuple("T0"),factory.tuple(lastT));
		bounds.boundExactly(tables,tables_bound);

		TupleSet table_name_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			if (i < change) {
				table_name_bound.add(factory.tuple("T"+i,"N"+(i+size)));								
			} else {
				table_name_bound.add(factory.tuple("T"+i,"N"+i));				
			}
		}
		bounds.boundExactly(table_name, table_name_bound);

		TupleSet columns_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			for (int k = 0; k <= i; k++) {
				columns_bound.add(factory.tuple("T"+i,"N"+k));
			}
		}
		bounds.boundExactly(columns, columns_bound);

		return bounds;
	}
	
	public Bounds bounds_notargets(int size, int maxdelta, int change){
		
		List<String> atoms = new LinkedList<String>();
		
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("C" + i);
		}
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i <= size; i++) {
			atoms.add("T" + i);
		}
			
		Universe universe = new Universe(atoms);
		Bounds bounds = new Bounds(universe);
		TupleFactory factory = universe.factory();

		String lastC  = "C" + (2*size+maxdelta-1);
		String lastN  = "N" + (2*size+maxdelta-1);
		String lastT  = "T" + (size-1);

		bounds.bound(classes, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		//bounds.setTarget(classes, factory.range(factory.tuple("C0"), factory.tuple("C"+(2*size-1))));

		bounds.bound(names, factory.range(factory.tuple("N0"), factory.tuple(lastN)));
		//bounds.setTarget(names, factory.range(factory.tuple("N0"), factory.tuple("N"+(2*size-1))));

		bounds.bound(persistent, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		//bounds.setTarget(persistent, factory.range(factory.tuple("C0"), factory.tuple("C"+(size-1))));

		bounds.bound(class_name, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		/*TupleSet class_name_bound = factory.noneOf(2);
		for (int i = 0; i < 2*size; i++) {
			class_name_bound.add(factory.tuple("C"+i,"N"+i));
		}
		//bounds.setTarget(class_name, class_name_bound);*/

		bounds.bound(parent, factory.area(factory.tuple("C0","C0"), factory.tuple(lastC,lastC)));
		/*TupleSet parent_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			parent_bound.add(factory.tuple("C"+(i+size),"C"+i));
		}
		for (int i = 1; i < size; i++) {
			parent_bound.add(factory.tuple("C"+i,"C"+(i-1)));
		}
		//bounds.setTarget(parent, parent_bound);*/

		bounds.bound(attributes, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		/*TupleSet attributes_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			attributes_bound.add(factory.tuple("C"+i,"N"+i));
		}
		//bounds.setTarget(attributes, attributes_bound);*/

		TupleSet tables_bound = factory.range(factory.tuple("T0"),factory.tuple(lastT));
		bounds.boundExactly(tables,tables_bound);

		TupleSet table_name_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			if (i < change) {
				table_name_bound.add(factory.tuple("T"+i,"N"+(i+size)));								
			} else {
				table_name_bound.add(factory.tuple("T"+i,"N"+i));				
			}
		}
		bounds.boundExactly(table_name, table_name_bound);

		TupleSet columns_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			for (int k = 0; k <= i; k++) {
				columns_bound.add(factory.tuple("T"+i,"N"+k));
			}
		}
		bounds.boundExactly(columns, columns_bound);

		return bounds;
	}
	public Bounds bounds_simplified(int size, int maxdelta, int change) {
		
		List<String> atoms = new LinkedList<String>();
		
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("C" + i);
		}
		for (int i = 0; i < 2*size+maxdelta; i++) {
			atoms.add("N" + i);
		}
		for (int i = 0; i <= size; i++) {
			atoms.add("T" + i);
		}
			
		Universe universe = new Universe(atoms);
		PardinusBounds bounds = new PardinusBounds(universe);
		TupleFactory factory = universe.factory();

		String lastC  = "C" + (2*size+maxdelta-1);
		String lastN  = "N" + (2*size+maxdelta-1);
		String lastT  = "T" + (size-1);

		bounds.bound(classes, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		bounds.setTarget(classes, factory.range(factory.tuple("C0"), factory.tuple("C"+(2*size-1))));

		bounds.bound(names, factory.range(factory.tuple("N0"), factory.tuple(lastN)));
		bounds.setTarget(names, factory.range(factory.tuple("N0"), factory.tuple("N"+(2*size-1))));

		bounds.bound(persistent, factory.range(factory.tuple("C0"), factory.tuple(lastC)));
		bounds.setTarget(persistent, factory.range(factory.tuple("C0"), factory.tuple("C"+(size-1))));

		bounds.bound(class_name, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		TupleSet class_name_bound = factory.noneOf(2);
		for (int i = 0; i < 2*size; i++) {
			class_name_bound.add(factory.tuple("C"+i,"N"+i));
		}
		bounds.setTarget(class_name, class_name_bound);

		bounds.bound(parent, factory.area(factory.tuple("C0","C0"), factory.tuple(lastC,lastC)));
		TupleSet parent_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			parent_bound.add(factory.tuple("C"+(i+size),"C"+i));
		}
		for (int i = 1; i < size; i++) {
			parent_bound.add(factory.tuple("C"+i,"C"+(i-1)));
		}
		bounds.setTarget(parent, parent_bound);

		bounds.bound(attributes, factory.area(factory.tuple("C0","N0"), factory.tuple(lastC,lastN)));
		TupleSet attributes_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			attributes_bound.add(factory.tuple("C"+i,"N"+i));
		}
		bounds.setTarget(attributes, attributes_bound);

		TupleSet tables_bound = factory.range(factory.tuple("T0"),factory.tuple(lastT));
		bounds.boundExactly(tables,tables_bound);

		TupleSet table_name_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			if (i < change) {
				table_name_bound.add(factory.tuple("T"+i,"N"+(i+size)));								
			} else {
				table_name_bound.add(factory.tuple("T"+i,"N"+i));				
			}
		}
		bounds.boundExactly(table_name, table_name_bound);

		TupleSet columns_bound = factory.noneOf(2);
		for (int i = 0; i < size; i++) {
			for (int k = 0; k <= i; k++) {
				columns_bound.add(factory.tuple("T"+i,"N"+k));
			}
		}
		bounds.boundExactly(columns, columns_bound);

		return bounds;
	}

	public Formula types() {
		return persistent.in(classes).and(
				parent.in(classes.product(classes))).and(
				attributes.in(classes.product(names))).and(
				class_name.in(classes.product(names)));
	}
	
	public Formula lone_parent(){
		Variable c = Variable.unary("c");
		Formula body = c.join(parent).lone();
		return body.forAll(c.oneOf(classes));
	}
	
	public Formula one_name(){
		Variable c = Variable.unary("c");
		Formula body = c.join(class_name).one();
		return body.forAll(c.oneOf(classes));
	}
	
	public Formula unique_names() {
		Variable n = Variable.unary("n");
		Formula body = class_name.join(n).lone();
		return body.forAll(n.oneOf(names));
	}
	
	public Formula acyclic() {
		Variable c = Variable.unary("c");
		Formula body = c.in(c.join(parent.closure())).not();
		return body.forAll(c.oneOf(classes));
	}
	
	public Formula trans() {
		Variable c = Variable.unary("c");
		Variable t = Variable.unary("t");
		Formula body = c.join(class_name).eq(t.join(table_name)).and(c.join(parent.reflexiveClosure()).join(attributes).eq(t.join(columns)));
		Formula to = body.forSome(t.oneOf(tables)).forAll(c.oneOf(persistent));
		Formula from = body.forSome(c.oneOf(persistent)).forAll(t.oneOf(tables));
		return (to.and(from));
	}
	
	public Formula formula() {
		return types().and(unique_names()).and(acyclic()).and(trans()).and(lone_parent()).and(one_name());
	}
	
	
	
	public static long find_restricted(int size, int delta, SATFactory satSolver) {
		Cd2Rdbms model = new Cd2Rdbms();
		Solver solver = new Solver();

		solver.options().setSolver(satSolver);
		solver.options().setBitwidth(1);
		solver.options().setSymmetryBreaking(0);

		Solution sol = solver.solve(model.formula(),model.bounds_restricted(size,0,delta));
		System.out.println(sol);
		
		
		return (sol.stats().translationTime()+sol.stats().solvingTime());
	}
	
	public static long find_notargets(int size, int delta, SATFactory satSolver) {
		Cd2Rdbms model = new Cd2Rdbms();
		Solver solver = new Solver();

		solver.options().setSolver(satSolver);
		solver.options().setBitwidth(1);
		//solver.options().setSymmetryBreaking(0);

		Solution sol = solver.solve(model.formula(),model.bounds_notargets(size,0,delta));
		//System.out.println(sol);
		//System.out.println(sol.stats());
		return (sol.stats().translationTime()+sol.stats().solvingTime());
	}
	
	public static long find(int size, int delta, SATFactory maxSATSolver) {
		Cd2Rdbms model = new Cd2Rdbms();
		Solver solver = new Solver();
//		solver.options().setSolver(SATFactory.externalPMaxSATFactory("/users/Alcino/Documents/workspace/Exemplos/yices","cd2rdbms_"+size+"_"+delta+".wcnf",2));
//		solver.options().setSolver(SATFactory.PMaxSAT4J);
		solver.options().setSolver(maxSATSolver);
		solver.options().setBitwidth(1);
		solver.options().setSymmetryBreaking(0);
//		Solution sol = solver.solve(model.formula(),model.bounds(size,10,delta));
		Solution sol = solver.solve(model.formula(),model.bounds_simplified(size,0,delta));
		System.out.println(sol);
		//System.out.println(sol.stats());
		return (sol.stats().translationTime()+sol.stats().solvingTime());
	}
	
	public static void targetTest(SATFactory maxSATSolver)
	{
		long res[][] = new long[6][16];
		long aux;
		for (int delta=0; delta<=5; delta++) {
			for (int size=6; size<=20; size+=1) {
				System.out.println("Size: "+size);
				System.out.println("Delta: "+delta);
				aux = find(size,delta,maxSATSolver);
				System.out.println("Time:"+aux);
				res[delta][size-5] = aux;				
			}
		}
		for (int i=0; i<16; i++) {
			for (int j=0; j<6; j++) {
				System.out.print(res[j][i]);
				if (j<5) {
					System.out.print("\t");
				} else {
					System.out.println();
				}
			}
		}
	}
	
	
	public static void noTargetTest(SATFactory satSolver)
	{
		long res[][] = new long[6][16];
		long aux;
		for (int delta=0; delta<=5; delta++) {
			for (int size=6; size<=20; size+=1) {
				System.out.println("Size: "+size);
				System.out.println("Delta: "+delta);
				aux = find_notargets(size,delta,satSolver);
				System.out.println("Time:"+aux);
				res[delta][size-5] = aux;				
			}
		}
		for (int i=0; i<16; i++) {
			for (int j=0; j<6; j++) {
				System.out.print(res[j][i]);
				if (j<4) {
					System.out.print("\t");
				} else {
					System.out.println();
				}
			}
		}
	}
	
	public static void restrictedTest(SATFactory satSolver)
	{
		long res[][] = new long[5][16];
		long aux;
		for (int delta=0; delta<=4; delta++) {
			for (int size=5; size<=20; size+=1) {
				System.out.println("Size: "+size);
				System.out.println("Delta: "+delta);
				aux = find_restricted(size,delta,satSolver);
				System.out.println("Time:"+aux);
				res[delta][size-5] = aux;				
			}
		}
		for (int i=0; i<16; i++) {
			for (int j=0; j<5; j++) {
				System.out.print(res[j][i]);
				if (j<4) {
					System.out.print("\t");
				} else {
					System.out.println();
				}
			}
		}
	}
}
