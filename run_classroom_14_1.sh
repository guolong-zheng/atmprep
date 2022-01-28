for f in benchmark/a4f/classroom/inv14_1/*.als
do
  echo -n $f;
  timeout 60m java -jar atmprep_newer.jar $f
done