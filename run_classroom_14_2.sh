for f in benchmark/a4f/classroom/inv14_2/*.als
do
  echo -n $f;
  timeout 60m java -jar atmprep_newer.jar $f
done