julia --project=./../ --threads 1 ./../test_build_grafs/check_hamiltonian.jl $1 | tee ./reports/report_$1.txt
