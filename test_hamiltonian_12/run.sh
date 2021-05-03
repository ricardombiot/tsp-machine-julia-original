for n in {4..5}
do
	sh run_generator.sh $n
	sh run_test.sh $n | tee ./data/report$n.txt
done
