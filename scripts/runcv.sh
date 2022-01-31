for f in benchmark/a4f/cv/*.als
do
  echo -n $f;
  timeout 60m java -jar atmprep.jar $f
done