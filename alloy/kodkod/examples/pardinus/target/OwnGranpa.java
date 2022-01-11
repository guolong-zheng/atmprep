package kodkod.examples.pardinus.target;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import kodkod.ast.*;
import kodkod.ast.operator.*;
import kodkod.instance.*;
import kodkod.engine.*;
import kodkod.engine.ExtendedSolver.SolutionIterator;
import kodkod.engine.config.ExtendedOptions;
import kodkod.engine.config.TargetOptions.TMode;
import kodkod.engine.satlab.SATFactory;

/**
 * Target-oriented model finding example: own grampa.
 * @author Tiago Guimarães, Alcino Cunha, Nuno Macedo // [HASLab] target-oriented model finding
 */
public final class OwnGranpa {

	public static void main(String[] args) throws Exception {


		Relation _nxt = Relation.nary("Int/next", 2);
		Relation _int = Relation.unary("Int");
		Relation _str = Relation.unary("String");
		Relation w = Relation.unary("W");
		Relation m = Relation.unary("M");
		Relation p_f = Relation.nary("f", 2);
		Relation p_m = Relation.nary("m", 2);
		Relation w_h = Relation.nary("h", 2);
		Relation m_w = Relation.nary("w", 2);

		List<String> atomlist = Arrays.asList(
				"M$0", "M$1", "W$0", "W$1"//, "W$2"
				);

		Universe universe = new Universe(atomlist);
		TupleFactory factory = universe.factory();
		PardinusBounds bounds = new PardinusBounds(universe);

		TupleSet _nxtupper = factory.noneOf(2);
		bounds.boundExactly(_nxt, _nxtupper);

		TupleSet _intupper = factory.noneOf(1);
		bounds.boundExactly(_int, _intupper);

		TupleSet _strupper = factory.noneOf(1);
		bounds.boundExactly(_str, _strupper);

		TupleSet w_upper = factory.noneOf(1);
		w_upper.add(factory.tuple("W$0"));
		w_upper.add(factory.tuple("W$1"));
//		w_upper.add(factory.tuple("W$2"));
		bounds.boundExactly(w, w_upper);
		bounds.setWeight(w, 4);


		TupleSet m_upper = factory.noneOf(1);
		m_upper.add(factory.tuple("M$0"));
		m_upper.add(factory.tuple("M$1"));
		bounds.boundExactly(m, m_upper);
		bounds.setWeight(m, 4);
		
		TupleSet p_f_upper = factory.noneOf(2);
		p_f_upper.add(factory.tuple("W$0").product(factory.tuple("M$0")));
		p_f_upper.add(factory.tuple("W$0").product(factory.tuple("M$1")));
		p_f_upper.add(factory.tuple("W$1").product(factory.tuple("M$0")));
		p_f_upper.add(factory.tuple("W$1").product(factory.tuple("M$1")));
//		p_f_upper.add(factory.tuple("W$2").product(factory.tuple("M$0")));
//		p_f_upper.add(factory.tuple("W$2").product(factory.tuple("M$1")));
		p_f_upper.add(factory.tuple("M$0").product(factory.tuple("M$0")));
		p_f_upper.add(factory.tuple("M$0").product(factory.tuple("M$1")));
		p_f_upper.add(factory.tuple("M$1").product(factory.tuple("M$0")));
		p_f_upper.add(factory.tuple("M$1").product(factory.tuple("M$1")));
		bounds.bound(p_f, p_f_upper);

		TupleSet p_f_target = factory.noneOf(2);
//		p_f_target.add(factory.tuple("W$0").product(factory.tuple("M$1")));
//		p_f_target.add(factory.tuple("M$0").product(factory.tuple("M$1")));
		bounds.setTarget(p_f, p_f_target);
		bounds.setWeight(p_f, 3);


		TupleSet p_m_upper = factory.noneOf(2);
		p_m_upper.add(factory.tuple("W$0").product(factory.tuple("W$0")));
		p_m_upper.add(factory.tuple("W$0").product(factory.tuple("W$1")));
//		p_m_upper.add(factory.tuple("W$0").product(factory.tuple("W$2")));
		p_m_upper.add(factory.tuple("W$1").product(factory.tuple("W$0")));
		p_m_upper.add(factory.tuple("W$1").product(factory.tuple("W$1")));
//		p_m_upper.add(factory.tuple("W$1").product(factory.tuple("W$2")));
//		p_m_upper.add(factory.tuple("W$2").product(factory.tuple("W$0")));
//		p_m_upper.add(factory.tuple("W$2").product(factory.tuple("W$1")));
//		p_m_upper.add(factory.tuple("W$2").product(factory.tuple("W$2")));
		p_m_upper.add(factory.tuple("M$0").product(factory.tuple("W$0")));
		p_m_upper.add(factory.tuple("M$0").product(factory.tuple("W$1")));
//		p_m_upper.add(factory.tuple("M$0").product(factory.tuple("W$2")));
		p_m_upper.add(factory.tuple("M$1").product(factory.tuple("W$0")));
		p_m_upper.add(factory.tuple("M$1").product(factory.tuple("W$1")));
//		p_m_upper.add(factory.tuple("M$1").product(factory.tuple("W$2")));
		bounds.bound(p_m, p_m_upper);

		TupleSet p_m_target = factory.noneOf(2);
//		p_m_target.add(factory.tuple("M$1").product(factory.tuple("W$2")));
		p_m_target.add(factory.tuple("M$0").product(factory.tuple("W$1")));
		p_m_target.add(factory.tuple("W$1").product(factory.tuple("W$0")));
		bounds.setTarget(p_m, p_m_target);
		bounds.setWeight(p_m, 3);
		
		
		TupleSet w_h_upper = factory.noneOf(2);
		w_h_upper.add(factory.tuple("W$0").product(factory.tuple("M$0")));
		w_h_upper.add(factory.tuple("W$0").product(factory.tuple("M$1")));
		w_h_upper.add(factory.tuple("W$1").product(factory.tuple("M$0")));
		w_h_upper.add(factory.tuple("W$1").product(factory.tuple("M$1")));
//		w_h_upper.add(factory.tuple("W$2").product(factory.tuple("M$0")));
//		w_h_upper.add(factory.tuple("W$2").product(factory.tuple("M$1")));
		bounds.bound(w_h, w_h_upper);
		bounds.setWeight(w_h, 1);

		TupleSet w_h_target = factory.noneOf(2);
		w_h_target.add(factory.tuple("W$1").product(factory.tuple("M$1")));
//		w_h_target.add(factory.tuple("W$2").product(factory.tuple("M$0")));
		bounds.setTarget(w_h, w_h_target);

		TupleSet m_w_upper = factory.noneOf(2);
		m_w_upper.add(factory.tuple("M$0").product(factory.tuple("W$0")));
		m_w_upper.add(factory.tuple("M$0").product(factory.tuple("W$1")));
//		m_w_upper.add(factory.tuple("M$0").product(factory.tuple("W$2")));
		m_w_upper.add(factory.tuple("M$1").product(factory.tuple("W$0")));
		m_w_upper.add(factory.tuple("M$1").product(factory.tuple("W$1")));
//		m_w_upper.add(factory.tuple("M$1").product(factory.tuple("W$2")));
		bounds.bound(m_w, m_w_upper);
		bounds.setWeight(m_w, 1);

		
		TupleSet m_w_target = factory.noneOf(2);
		m_w_target.add(factory.tuple("M$1").product(factory.tuple("W$1")));
//		m_w_target.add(factory.tuple("M$0").product(factory.tuple("W$2")));
		bounds.setTarget(m_w, m_w_target);

		Formula x10=w.intersection(m).no();
		
		Variable x14=Variable.unary("this");
		Decls x13=x14.oneOf(w);
		Expression x17=x14.join(w_h);
		Formula x16=x17.lone();
		Formula x18=x17.in(m);
		Formula x15=x16.and(x18);
		Formula x12=x15.forAll(x13);
		
		Formula x19=(w_h.join(Expression.UNIV)).in(w);
		
		Variable x24=Variable.unary("this");
		Decls x23=x24.oneOf(m);
		Expression x27=x24.join(m_w);
		Formula x26=x27.lone();
		Formula x28=x27.in(w);
		Formula x25=x26.and(x28);
		Formula x22=x25.forAll(x23);
		
		Formula x29=(m_w.join(Expression.UNIV)).in(m);
		
		Variable x33=Variable.unary("this");
		Expression x34=w.union(m);
		Decls x32=x33.oneOf(x34);
		Expression x37=x33.join(p_f);
		Formula x36=x37.lone();
		Formula x38=x37.in(m);
		Formula x35=x36.and(x38);
		Formula x31=x35.forAll(x32);
		
		Expression x40=p_f.join(Expression.UNIV);
		Formula x39=x40.in(x34);

		Variable x43=Variable.unary("this");
		Decls x42=x43.oneOf(x34);
		Expression x46=x43.join(p_m);
		Formula x45=x46.lone();
		Formula x47=x46.in(w);
		Formula x44=x45.and(x47);
		Formula x41=x44.forAll(x42);
		
		Formula x48=(p_m.join(Expression.UNIV)).in(x34);
		
		Variable x52=Variable.unary("p");
		Decls x51=x52.oneOf(x34);
		Expression x57=p_m.union(p_f);
		Expression x56=x57.closure();
		Expression x55=x52.join(x56);
		Formula x54=x52.in(x55);
		Formula x53=x54.not();
		Formula x50=x53.forAll(x51);
		
		Expression x59=w_h.transpose();
		Formula x58=m_w.eq(x59);
		
		Expression x62=m_w.union(w_h);
		Expression x64=p_m.union(p_f);
		Expression x63=x64.closure();
		Expression x61=x62.intersection(x63);
		Formula x60=x61.no();
		
		Formula x65=_nxt.eq(_nxt);
		Formula x66=_int.eq(_int);
		Formula x67=_str.eq(_str);
		Formula x68=w.eq(w);
		Formula x69=m.eq(m);
		Formula x70=p_f.eq(p_f);
		Formula x71=p_m.eq(p_m);
		Formula x72=w_h.eq(w_h);
		Formula x73=m_w.eq(m_w);
		Formula family=Formula.compose(FormulaOperator.AND, x10, x12, x19, x22, x29, x31, x39, x41, x48, x50, x58, x60, x65, x66, x67, x68, x69, x70, x71, x72, x73);

		HashMap<String,Integer> ws = new HashMap<String,Integer>();
		ws.put("f", 3);
		ws.put("m", 3);
		ws.put("M", 4);
		ws.put("W", 4);
		ws.put("w", 1);
		ws.put("h", 1);
		ws.put("Int/next", 1);
		ws.put("Int", 1);
		ws.put("String", 1);


		ExtendedOptions opt = new ExtendedOptions();
		opt.setSolver(SATFactory.externalPMaxYices("/Users/nmm/Documents/Work/Programming/AlloyExplore/kodextension/lib/yices-1.0.38/bin/yices", "owngrandpa.wcnf", 2000, "-d","-e","-ms","-mw",""+2000));
//		opt.setSolver(SATFactory.PMaxSAT4J);
		opt.setBitwidth(1);
		opt.setSymmetryBreaking(0);
		opt.setNoOverflow(true);
		ExtendedSolver solver = new ExtendedSolver(opt);
		SolutionIterator sols = (SolutionIterator) solver.solveAll(family,bounds);
		opt.setTargetMode(TMode.CLOSE);
		Solution sol = sols.next(ws);
		//System.out.println(sol.stats());
		System.out.println(sol);
		for (int i = 0; i<1;i++) {
			sol = sols.next(ws);
			System.out.println(sol);
		}

	}



}
