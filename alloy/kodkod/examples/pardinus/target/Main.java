package kodkod.examples.pardinus.target;

import kodkod.engine.satlab.SATFactory;

/**
 * Target-oriented model finding tests.
 * @author Tiago Guimarães, Alcino Cunha, Nuno Macedo // [HASLab] target-oriented model finding
 */
public class Main {

	public static void main(String[] args) {
		//aquecimento:
		Graph.graph(30, 3, SATFactory.PMaxSAT4J);
		
//		//Test Graph
		System.out.println("=============Graph=====================");
//		System.out.println("no targets Yices");
//		Graph.notarget(SATFactory.Yices);
//		Graph.graph_notarget(20, 3, SATFactory.DefaultSAT4J);
//		System.out.println("no targets SAT4J");
//		Graph.notarget(SATFactory.DefaultSAT4J);
//		System.out.println("targets Yices");
//		Graph.target(SATFactory.PMaxYices);
		System.out.println("targets SAT4J");
		Graph.graph(30, 3, SATFactory.PMaxSAT4J);
		Graph.target(SATFactory.PMaxSAT4J);
		
		//test Cd2Rdbms
		System.out.println("=============Cd2Rdbms=====================");
		
		/*
		System.out.println("no targets SAT4J");
		Cd2Rdbms.find_notargets(7, 1, SATFactory.DefaultSAT4J);
		Cd2Rdbms.noTargetTest(SATFactory.DefaultSAT4J);
		
		System.out.println("no targets Yices");
		Cd2Rdbms.find_notargets(7, 1, OurSATFactory.Yices);
		Cd2Rdbms.noTargetTest(OurSATFactory.Yices);
		*/
		/*
		System.out.println("targets Yices");
		Cd2Rdbms.find(7, 1, OurSATFactory.YicesMAXSAT);
		Cd2Rdbms.targetTest(OurSATFactory.YicesMAXSAT);
		 */
		
		//Cd2Rdbms.targetTest(OurSATFactory.PMaxSAT4J);
		
		
//		System.out.println("targets Inc SAT4J");
//		Cd2Rdbms.find(7, 1, SATFactory.IncrementalSAT4J);
//		Cd2Rdbms.targetTest(SATFactory.IncrementalSAT4J);
		
		Cd2Rdbms.find(7, 1, SATFactory.PMaxSAT4J);
//		Cd2Rdbms.targetTest(OurSATFactory.PMaxSAT4J);
		/*
		//with guessing
		Cd2Rdbms.restrictedTest(OurSATFactory.Yices);
		Cd2Rdbms.restrictedTest(OurSATFactory.DefaultSAT4J);
		*/
		
		//System.out.println(Cd2Rdbms.find(15, 3, OurSATFactory.YicesMAXSAT));
		//System.out.println(Cd2Rdbms.find(20, 5, OurSATFactory.YicesMAXSAT));
		//Cd2Rdbms.targetTest(OurSATFactory.YicesMAXSAT);
		
	
		//System.out.println(Graph.graph(100, 5, OurSATFactory.YicesMAXSAT));
	}

}
