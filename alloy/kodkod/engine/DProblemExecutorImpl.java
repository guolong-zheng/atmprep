/* 
 * Kodkod -- Copyright (c) 2005-present, Emina Torlak
 * Pardinus -- Copyright (c) 2013-present, Nuno Macedo, INESC TEC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package kodkod.engine;

import java.util.Iterator;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.atomic.AtomicInteger;

import kodkod.ast.Formula;
import kodkod.engine.config.ExtendedOptions;
import kodkod.engine.config.Options;
import kodkod.engine.config.Reporter;
import kodkod.engine.decomp.DMonitorImpl;
import kodkod.engine.decomp.DProblem;
import kodkod.engine.decomp.IProblem;
import kodkod.instance.PardinusBounds;

/**
 * An implementation of parallel strategy decomposed problem executor designed
 * to retrieve SAT solutions. Supports a hybrid mode that pairs the integrated
 * problems with an amalgamated problem. Iteration is performed over all the SAT
 * integrated problems or the amalgamated problem. Is UNSAT if every integrated
 * problem is UNSAT or the amalagamated problem.
 * 
 * @param <S>
 *            The solver that will be used to handle integrated problems.
 *
 * @see kodkod.engine.DProblemExecutor
 * @author Eduardo Pessoa, Nuno Macedo // [HASLab] decomposed model finding
 */
public class DProblemExecutorImpl<S extends AbstractSolver<PardinusBounds, ExtendedOptions>>
		extends DProblemExecutor<S> {

	/** a buffer for solutions, popped by the hasNext test */
	private Solution buffer;

	/** the number of effectively running solvers */
	private final AtomicInteger running = new AtomicInteger(0);

	/** the queue of found SAT solutions (or poison) */
	private final BlockingQueue<Solution> solution_queue = new LinkedBlockingQueue<Solution>(2);

	/** whether the amalgamated problem will be launched */
	private final boolean hybrid;

	/** the amalgamated problem, if in hybrid mode */
	private DProblem<S> amalgamated;

	/**
	 * Constructs an effective decomposed problem executor for a decomposed
	 * model finding problem and the number of desired parallel solvers.
	 * 
	 * The formula and bounds will only be decomposed by a slicer further down
	 * the process.
	 * 
	 * @param rep
	 *            a monitor for the decomposed process.
	 * @param formula
	 *            the formula to be solved.
	 * @param bounds
	 *            the bounds of the problem.
	 * @param solver1
	 *            the solver for the partial problem.
	 * @param solver2
	 *            the solver for the integrated problem.
	 * @param n
	 *            the number of solver threads.
	 * @param hybrid
	 *            whether to run in hybrid mode.
	 */
	public DProblemExecutorImpl(Reporter rep, Formula formula,
			PardinusBounds bounds, ExtendedSolver solver1,
			S solver2, int n, boolean hybrid) {
		super(new DMonitorImpl(rep), formula, bounds, solver1, solver2, n);
		this.hybrid = hybrid;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	synchronized public void end(DProblem<S> sol) {
		if (Thread.currentThread().isInterrupted())
			return;
		try {
			// if the amalgamated terminates...
			if (!(sol instanceof IProblem)) {
				// store the sat or unsat solution
				solution_queue.put(sol.getSolution());
//				running.set(1);
				monitor.amalgamatedWon();
//				 terminate the integrated problems
//				if (!executor.isTerminated())
//					terminate();
				// if sat, iterate and launch
				if (sol.sat()) {
					amalgamated = sol.next();
					executor.execute(amalgamated);
				} else {
					running.decrementAndGet();
				}
			}
			// if an integrated terminates...
			else {
				// if it is sat...
				if (sol.sat()) {
					// store the sat solution
					solution_queue.put(sol.getSolution());
					// terminate the amalgamated problem
					if (hybrid && amalgamated.isAlive() && !monitor.isAmalgamated()) {
						amalgamated.interrupt();
						running.decrementAndGet();
					}
					// iterate and launch
					if (sol.hasNext() && !monitor.isAmalgamated())
						executor.execute(sol.next());
					else
						running.decrementAndGet();
				}
				// if it is unsat...
				else {
					running.decrementAndGet();
					// if last running integrated...
					if (running.get() == 0 && !monitor.isAmalgamated()) {
						if (monitor.isConfigsDone())
							// store the unsat solution
							solution_queue.put(sol.getSolution());
						else 
							launchBatch(false);
					}
				}
			}
			monitor.newSolution(sol);
		} catch (InterruptedException | IllegalThreadStateException e1) {
			e1.printStackTrace();
			// was interrupted in the meantime
		} catch (RejectedExecutionException e) {
			// was shutdown in the meantime
		}
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	public void failed(Throwable e) {
		solver_partial.options().reporter().warning("Integrated solver failed.");
		if (Options.isDebug())
			solver_partial.options().reporter().debug(e.getLocalizedMessage());
		running.decrementAndGet();
		// if last running integrated...
		if (monitor.isConfigsDone()
				&& (running.get() == 0 || (amalgamated != null && running
						.get() == 1))) {
			try {
				solution_queue.put(poison());
				terminate();
			} catch (InterruptedException e1) {
				// was interrupted in the meantime
			}
		}
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void run() {

		// if hybrid mode, launch the amalgamated problem
		if (hybrid) {
			DProblem<S> amalg = new DProblem<S>(this);
			executor.execute(amalg);
			running.incrementAndGet();
			amalgamated = amalg;
		} 

		launchBatch(true);
	}
	Iterator<Solution> configs = solver_partial.solveAll(formula, bounds);
	
	void launchBatch(boolean first) {
		int size = 50;
		
		BlockingQueue<DProblem<S>> problem_queue = new LinkedBlockingQueue<DProblem<S>>(size);

		// collects a batch of configurations
		while (configs.hasNext() && problem_queue.size() < size) {
			Solution config = configs.next();

			if (config.unsat()) {
				// when there is no configuration no solver will ever
				// callback so it must be terminated here
				if (first)
					try {
						// get the stats from the unsat
						monitor.newConfig(config);
						terminate();
						solution_queue.put(config);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
			} else {
				monitor.newConfig(config);
				DProblem<S> problem = new IProblem<S>(config, this);
				problem_queue.add(problem);
			}
			first = false;
		}
		// launches a batch of integrated problems
		while (!problem_queue.isEmpty() && !executor.isShutdown()) {
			DProblem<S> problem = problem_queue.remove();
			try {
				executor.execute(problem);
			} catch (RejectedExecutionException e) {
				// if it was shutdown in the meantime
			}
			running.incrementAndGet();
		}
		monitor.configsDone(configs.hasNext());
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Solution next() throws InterruptedException {
		Solution sol;
		if (buffer != null) {
			sol = buffer;
			buffer = null;
		} else {
			sol = solution_queue.take();
		}
		monitor.gotNext(false);
		// if UNSAT, terminate execution
		if (!sol.sat())
			terminate();
		return sol;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean hasNext() throws InterruptedException {
		// buffer is needed because hasNext can't test for emptyness, must wait
		// for an output
		if (buffer != null)
			return true;
		if (!executor.isShutdown() && running.get() == 0 && !monitor.isConfigsDone() && !monitor.isAmalgamated())
			launchBatch(false);
			
		if (monitor.isConfigsDone() && running.get() == 0)
			return !solution_queue.isEmpty();
		// if there are integrated problems still running, can't just test for
		// emptyness must wait for the next output
		buffer = solution_queue.take();
		return true;
	}
}
