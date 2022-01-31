for f in benchmark/realbugs/*.als
do
  echo -n $f;
  timeout 60m java -jar atmprep_newer.jar $f
done