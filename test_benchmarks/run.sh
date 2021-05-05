# Example
#julia --project=./../ ./../test_benchmarks/test_executor.jl ./complete_graphs/singlecore/config_simple.yaml
# sh run.sh ./complete_graphs/singlecore/config_simple.yaml
julia --project=./../ ./../test_benchmarks/test_executor.jl $1
