for f in benchmark/a4f/production/*.als
do
  echo -n $f;
  timeout 60m java -jar atmprep_new.jar $f
done
