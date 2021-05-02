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
    #println("Execute in $time_execute ms")
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

function read_directory(directory :: String, graf_start :: Int64 = -1, graf_end :: Int64 = -1)
    cd(directory)
    if graf_start == -1
        lista_serialize_grafs = readdir()
    else
        lista_serialize_grafs = Array{String, 1}()
        for name in graf_start:graf_end
            path = "./$name.graf"
            if !isfile(path)
                break
            end

            push!(lista_serialize_grafs, path)
        end
    end
    return lista_serialize_grafs
end

function log_each1k(total_ok, total_grafs, total_time_execute)
    if rem(total_grafs, 1000) == 0
        log_name = Int64(total_grafs / 1000)

        ratio_valids = (total_ok / total_grafs) * 100
        avg_time_execute_machine = total_time_execute / Millisecond(total_ok)

        println("## LOG $(log_name)k ##")
        println("TOTAL: $total_grafs")
        println("TOTAL OK: $total_ok")
        println("DETECTION RATE: $(ratio_valids)%")
    end
end

function check_hamiltonian_grafs(lista_serialize_grafs)

    total_time_execute = Millisecond(0)
    total_grafs = 0
    total_ok = 0
    for file_graf in lista_serialize_grafs
        total_grafs += 1
        graf = deserialize(file_graf)

        (is_valid, time_execute) = check_have_hamiltonian_circuit_graf(graf)
        if is_valid
            #println("$file_graf [OK]")
            total_ok += 1
            total_time_execute += time_execute
        else
            println("$file_graf [FAIL]")
            #@test false
        end

        log_each1k(total_ok, total_grafs, total_time_execute)
    end


    ratio_valids = (total_ok / total_grafs) * 100
    avg_time_execute_machine = total_time_execute / Millisecond(total_ok)
    return (total_grafs, total_ok, ratio_valids, avg_time_execute_machine )
end

function main(args)
    n = first(args)

    time = now()
    dir = "./data/grafs$n"
    println("Directory: $dir")
    #list_grafs = read_directory(dir, 0, 10)
    max = 100000
    list_grafs = read_directory(dir, 0, max-1)
    (total_grafs, total_ok, ratio_valids, avg_time_execute_machine) = check_hamiltonian_grafs(list_grafs)
    time_test = now() - time
    str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_test))

    println("######################")
    println("Grafs Nodes: $n")
    println("TOTAL: $total_grafs")
    println("TOTAL OK: $total_ok")
    println("DETECTION RATE: $(ratio_valids)%")
    println("TOTAL TIME TEST: $(str_time_test)")
    println("AVG TIME MACHINE EXECUTION: $(avg_time_execute_machine) ms")

end

main(ARGS)
