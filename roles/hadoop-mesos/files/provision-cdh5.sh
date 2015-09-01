mv bin bin-mapreduce2
mv examples examples-mapreduce2
ln -s bin-mapreduce1 bin
ln -s examples-mapreduce1 examples
pushd etc
mv hadoop hadoop-mapreduce2
ln -s hadoop-mapreduce1 hadoop
popd
pushd share/hadoop
rm mapreduce
ln -s mapreduce1 mapreduce
popd