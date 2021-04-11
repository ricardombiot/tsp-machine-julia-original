include("./../src/main.jl")
using Serialization
using Test
using Dates



function check_have_hamiltonian_circuit_graf(graf :: Grafo) :: Tuple{Bool, Millisecond}
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)

    time = now()
    HalMachine.execute!(machine)
    time_execute = now() - time
    println("Execute in $time_execute ms")
    graph = SolutionGraphReader.get_one_solution_graph(machine)

    b = Km(graf.n)
    (tour, path) = PathReader.load!(graf.n, b, graph)
    is_valid_length = path.step == graf.n+1

    optimal = Weight(graf.n)
    checker = PathChecker.new(graf, path, optimal)
    is_valid_path = PathChecker.check!(checker)

    is_valid = is_valid_length && is_valid_path
    return (is_valid, time_execute)
end


function check_hamiltonian_grafs(directory)
    cd(directory)
    lista_serialize_grafs = readdir()

    total_time_execute = Millisecond(0)
    total_grafs = 0
    total_ok = 0
    for file_graf in lista_serialize_grafs
        total_grafs += 1
        graf = deserialize(file_graf)

        (is_valid, time_execute) = check_have_hamiltonian_circuit_graf(graf)
        if is_valid
            println("$file_graf [OK]")
            total_ok += 1
            total_time_execute += time_execute
        else
            println("$file_graf [FAIL]")
            #@test false
        end
    end


    procetage_valids = (total_ok / total_grafs) * 100
    avg_time_execute_machine = total_time_execute / Millisecond(total_ok)
    return (total_grafs, total_ok, procetage_valids, avg_time_execute_machine )
end


time = now()
dir = "./grafs5"
(total_grafs, total_ok, ratio_valids, avg_time_execute_machine) = check_hamiltonian_grafs(dir)
time_test = now() - time
str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_test))

println("######################")
println("TOTAL: $total_grafs")
println("TOTAL OK: $total_ok")
println("DETECTION RATE: $(ratio_valids)%")
println("TOTAL TIME TEST: $(str_time_test)")
println("AVG TIME MACHINE EXECUTION: $(avg_time_execute_machine) ms")


#=
println("## Valid hamiltonian circuit detection: $(ratio_valids)% ")
println("## Avg time execution: $(avg_time_execute_machine) ms ")
println("## Total time test: $(time_test) min ")
=#
