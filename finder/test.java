import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ConstList;
import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;
import edu.mit.csail.sdg.alloy4compiler.ast.Sig;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.translator.*;

import java.io.*;
import java.util.*;

public class test {

    public static void main(String args[]) throws IOException {
      //  File folder = new File("realbugs/");
      //  for (File f : folder.listFiles()) {
      //      String path = f.getPath();
            String path = "benchmark/taco/sll-contains-3.als";
            CompModule world = null;
            try {
                world = CompUtil.parseEverything_fromFile(A4Reporter.NOP, null, path);
            } catch (Err err) {
                err.printStackTrace();
            }
            ConstList<Command> commands = world.getAllCommands();
            A4Options opt = new A4Options();
            opt.solver = A4Options.SatSolver.SAT4J;
            int total = 0;
            for (Command cmd : commands) {
                String p = "output/sll-contains.als" ;//+ f.getName().toString();
                //String p = "testsuites/bemplFaulty.als";
                BufferedWriter bf = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(p, true)));
                total = genTest(bf, world, cmd, 10, total);
            }

//        for (Command cmd : commands) {
//            if(cmd.check) {
//                wrongSol = TranslateAlloyToKodkod.execute_command(A4Reporter.NOP, world.getAllSigs(), cmd, opt);
//                if(!wrongSol.satisfiable()) {
//                    System.out.println("assertion is not violated");
//                    return;
//                }
//            }
//            else {
//                correctSol = TranslateAlloyToKodkod.execute_command(A4Reporter.NOP, world.getAllSigs(), cmd, opt);
//            }
//        }

            //Compare.compare(correctSol, wrongSol);
      //  }
    }

    public static void printSigs(CompModule world, Command cmd) {
        A4Options opt = new A4Options();
        opt.solver = A4Options.SatSolver.SAT4J;
        A4Solution sol = null;
        try {
            sol = TranslateAlloyToKodkod.execute_command(A4Reporter.NOP, world.getAllSigs(), cmd, opt);
        } catch (Err err) {
            err.printStackTrace();
        }

        for (Sig sig : sol.getAllReachableSigs()) {
            System.out.println(sig + " " + sol.eval(sig));
            System.out.println("\t" + sig.getFields());
        }

    }

    public static int genTest(BufferedWriter bf, CompModule world, Command cmd, int num, int total) {
        A4Options opt = new A4Options();
        opt.solver = A4Options.SatSolver.SAT4J;
        A4Solution sol = null;
        try {
            sol = TranslateAlloyToKodkod.execute_command(A4Reporter.NOP, world.getAllSigs(), cmd, opt);
        } catch (Err err) {
            err.printStackTrace();
        }

        int count = 0;

        while (sol.satisfiable() && count < num) {
            Map<String, Set<String>> type2sig = new HashMap<>();
            count++;
            StringBuilder rel = new StringBuilder();
            StringBuilder del = new StringBuilder();

            for (Sig sig : sol.getAllReachableSigs()) {
                if (sig == Sig.SIGINT || sig == Sig.SEQIDX)
                    continue;
                if (sig == Sig.UNIV) {
                    A4TupleSet a4Tuples = sol.eval(sig);
                    for (A4Tuple tuple : a4Tuples) {
                        if (tuple.type().toString().contains("Int")) {
                            continue;
                        }
                        Set<String> ins = type2sig.get(tuple.type().toString());
                        if (ins == null)
                            ins = new HashSet<>();
                        ins.add(strip(tuple.toString()));
                        type2sig.put(tuple.type().toString(), ins);
                    }
                }

                if (!isBuiltin(sig)) {
                    A4TupleSet sigTuples = sol.eval(sig);
                    if (sigTuples.size() == 0)
                        rel.append("no " + strim(sig.label) + "\n");
                    else
                        rel.append(strim(sig.label) + " = ");
                    Iterator<A4Tuple> it = sigTuples.iterator();
                    while (it.hasNext()) {
                        A4Tuple sigTuple = it.next();
                        if (it.hasNext())
                            rel.append(strip(sigTuple.toString()) + " + ");
                        else
                            rel.append(strip(sigTuple.toString()) + "\n");
                    }

                    for (Sig.Field field : sig.getFields()) {
                        A4TupleSet fieldTuples = sol.eval(field);
                        if (fieldTuples.size() == 0)
                            rel.append("no " + field.label + "\n");
                        else {
                            rel.append(field.label + " = ");
                            Iterator<A4Tuple> itf = fieldTuples.iterator();
                            while (itf.hasNext()) {
                                A4Tuple fieldTuple = itf.next();
                                if (itf.hasNext())
                                    rel.append(strip(fieldTuple.toString()) + " + ");
                                else
                                    rel.append(strip(fieldTuple.toString()) + "\n");
                            }
                        }
                    }
                }
            }

            type2sig.forEach((k, v) -> {
                del.append("some disj ");
                Iterator<String> it = v.iterator();
                while (it.hasNext()) {
                    String s = it.next();
                    if (it.hasNext())
                        del.append(s + ", ");
                    else
                        del.append(s);
                }
                del.append(": " + strim(k) + " {");
            });
            del.append("\n");

            StringBuilder sb = new StringBuilder();
            sb.append("pred test" + (count + total) + "{\n" + del.toString() + rel.toString());
            type2sig.forEach((k, v) -> {
                sb.append("}");
            });
            sb.append("\n}\nrun test" + (count + total) + " for " + (cmd.overall > 0 ? cmd.overall : 20) + " expect " + (cmd.check ? "0" : "1") + "\n");
            //System.out.print(sb.toString());
            try {
                bf.write(sb.toString());
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                sol = sol.next();
            } catch (Err err) {
                err.printStackTrace();
            }
        }
        try {
            bf.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        total += count;
        return total;
    }

    public static String strim(String name) {
        if (name.contains("}"))
            return name.substring(name.indexOf("/") + 1, name.indexOf("}"));
        else
            return name.substring(name.indexOf("/") + 1);
    }

    public static String strip(String name) {
        while (name.contains("$"))
            name = name.substring(0, name.indexOf("$")) + name.substring(name.indexOf("$") + 1);
        return name;
    }

    public static void writeAls(String content, String fname, boolean append) {
        File file = new File(fname);
        BufferedWriter bf = null;
        try {
            bf = new BufferedWriter(new FileWriter(file, append));
            bf.write(content);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bf != null)
                try {
                    bf.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
    }

    public static boolean isBuiltin(Sig sig) {
        return sig == Sig.UNIV || sig == Sig.GHOST || sig == Sig.NONE || sig == Sig.SEQIDX || sig == Sig.SIGINT || sig == Sig.STRING;
    }

}
