###### NOTICE: CODE GENERATE #######
#  CAUTION DONT EDIT FILE          #
####################################

import YAML
using Test
using Dates
include("./../src/main.jl")
include("./benchmark_funcs.jl")
include("./benchmark_space.jl")
include("./asymptotic/size_n3/test_builder.jl")

run_memory_inspector("./reports")
main_executor("./reports", ARGS)
stop_memory_inspector("./reports")

###### NOTICE: CODE GENERATE #######
#  CAUTION DONT EDIT FILE          #
####################################
