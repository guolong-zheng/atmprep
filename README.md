## Replication package for ATR
This is the replication package for ATR: Template-based Repair for Alloy Specifications

### Structure of atr/
- benchmark/       : Alloy specifications used in evaluation

- src/             : source code of ATR

- libs/            : sat solvers libraries

- solvers/         : solvers dynamic link libraries


### Execution Instructions
# Build from source
  1. Requirement:
     - Ubuntu 16.04
     - bash 4.3.48
     - Java 8
     - Maven 3.3.9
  2. Build project use "mvn clean package"
  3. Generate table 2 use "java -Djava.library.path=solvers -cp ./libs/*:./target/atr-1.0-jar-with-dependencies.jar table2"
  4. In directory atr/, run ATR on one model use "java -Djava.library.path=solvers -cp ./libs/*:./target/atr-1.0-jar-with-dependencies.jar repair -f /path/to/model -m #/of/instances -d depth/of/search"
  
     -f: path to the Alloy specification to repair
     
     -m: max number of pairs of counterexamples and instances
     
     -d: depth of ATR search iterations
