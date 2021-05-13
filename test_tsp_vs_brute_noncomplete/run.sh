#!/bin/sh

TOTAL_GRAF=100

FILE_TIMES_TSP_MACHINE="./data/times_tsp_machine.csv"
FILE_TIMES_TSP_BRUTE="./data/times_tsp_brute.csv"

for n in {4..6}
do
	sh run_generator.sh $n $TOTAL_GRAF
	sh run_test.sh $n $TOTAL_GRAF
	sh run_check.sh $n $TOTAL_GRAF

	FILE_CHECK_RATE="./data/results$n/check_rate.txt"
	value=`cat $FILE_CHECK_RATE`

	if test "$value" = "100.0"
	then
		FILE_CHECK_TIMES_TSP_MACHINE="./data/results$n/check_times_tsp_machine.csv"
		FILE_CHECK_TIMES_TSP_BRUTE="./data/results$n/check_times_tsp_brute.csv"

		cat $FILE_CHECK_TIMES_TSP_MACHINE >> $FILE_TIMES_TSP_MACHINE
		cat $FILE_CHECK_TIMES_TSP_BRUTE >> $FILE_TIMES_TSP_BRUTE
	else
		echo "Error in N=[$n] rate is not 100%"
 fi

done
