import YAML
using Dates
include("./../src/main.jl")
include("./benchmark_funcs.jl")
include("./benchmark_space.jl")

function main(args)
    config_file = first(args)
    data = YAML.load_file(config_file)

    base_reports_path="./reports"

    name_test= data["name_test"]
    name_mode= data["name_mode"]
    name_config = data["name_config"]
    singlecore= data["singlecore"]
    threads= data["threads"]

    dynamic_test_builder = "./$name_test/$name_mode/test_builder.jl"

    open("test_executor_codegenerate.jl", "w") do io

           write(io, "###### NOTICE: CODE GENERATE #######" * "\n")
           write(io, "#  CAUTION DONT EDIT FILE          #" * "\n")
           write(io, "####################################" * "\n\n")

           write(io, "import YAML" * "\n")
           write(io, "using Test" * "\n")
           write(io, "using Dates" * "\n")
           write(io, "include(\"./../src/main.jl\")" * "\n")
           write(io, "include(\"./benchmark_funcs.jl\")" * "\n")
           write(io, "include(\"./benchmark_space.jl\")" * "\n")
           write(io, "include(\"$dynamic_test_builder\")" * "\n\n")
           write(io, "run_memory_inspector(\"$base_reports_path\")"* "\n")
           write(io, "main_executor(\"$base_reports_path\", ARGS)"* "\n")
           write(io, "stop_memory_inspector(\"$base_reports_path\")"* "\n\n")

           write(io, "###### NOTICE: CODE GENERATE #######" * "\n")
           write(io, "#  CAUTION DONT EDIT FILE          #" * "\n")
           write(io, "####################################" * "\n")
    end;

    if singlecore
        mycommand = `julia --project=./../ ./../test_benchmarks/test_executor_codegenerate.jl $args`
    else
        mycommand = `julia --project=./../ --threads $threads ./../test_benchmarks/test_executor_codegenerate.jl $args`
    end

    println(mycommand)
    run(mycommand)
    #using TestBuilder


    build_space_report!(base_reports_path, name_test, name_mode, name_config)
end

main(ARGS)
