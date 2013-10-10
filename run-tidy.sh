echo Running tidy > tidy-out.txt
for f in *.html ; do
  echo "--------------------------------------------------" >> tidy-out.txt
  echo $f >> tidy-out.txt
  tidy -config ../tidy-config.txt $f >> tidy-out.txt 2>&1
  if [ $? -eq 2 ] ; then
    echo "FAILED" >> tidy-out.txt
  fi
done
