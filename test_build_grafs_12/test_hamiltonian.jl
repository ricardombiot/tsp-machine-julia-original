include("./../src/main.jl")

function write_result_is_hamiltonian!(path :: String, id :: Int64, is_hamiltonian :: Bool)
    if is_hamiltonian
        path_file = "$(path)/hamiltonian/$(id)"
    else
        path_file = "$(path)/non-hamiltonian/$(id)"
    end

    if !isfile(path_file)
        shell_command = `touch $(path_file)`
        run(shell_command)
    end
end

function read_result(path :: String, id :: Int64) :: String
    path_hal_file = "$(path)/hamiltonian/$(id)"
    path_nonhal_file = "$(path)/non-hamiltonian/$(id)"

    if isfile(path_hal_file) && !isfile(path_nonhal_file)
        return "HAMILTONIAN"
    elseif !isfile(path_hal_file) && isfile(path_nonhal_file)
        return "NON-HAMILTONIAN"
    else
        return "ERROR"
    end
end

function test_clasification_hal_machine(n :: Color, id :: Int64, path_results :: String)
    path = "./../../../../test_build_grafs_12/data/grafs$n/hcp"
    graf = GrafGenerator.read_tsplib_file("$id",path,".hcp")

    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    HalMachine.execute!(machine)

    is_hamiltonian = SolutionGraphReader.have_solution(machine)
    write_result_is_hamiltonian!(path_results, id, is_hamiltonian)

    #=
    if is_hamiltonian
        println("HalMachine: El grafo $id, hamiltoniano [TRUE]")
    else
        println("HalMachine: El grafo $id, hamiltoniano [FALSE]")
    end
    =#
end

function test_clasification_tsp_machine(n :: Color, id :: Int64, path_results :: String)
    path = "./../../../../test_build_grafs_12/data/grafs$n/tsp"
    graf = GrafGenerator.read_tsplib_file("$id",path,".tsp")

    color_origin = Color(0)
    b_km = Km(n)
    machine = TSPMachine.new(graf, b_km, color_origin)
    TSPMachine.execute!(machine)

    is_hamiltonian = SolutionGraphReader.have_solution(machine)
    write_result_is_hamiltonian!(path_results, id, is_hamiltonian)

    #=
    if is_hamiltonian
        println("TSPMachine: El grafo $id, hamiltoniano [TRUE]")
    else
        println("TSPMachine: El grafo $id, hamiltoniano [FALSE]")
    end
    =#
end


function test_clasification_tsp_brute_force(n :: Color, id :: Int64, path_results :: String)
    path = "./../../../../test_build_grafs_12/data/grafs$n/tsp"
    graf = GrafGenerator.read_tsplib_file("$id",path,".tsp")

    color_origin = Color(0)
    b_km = Km(n)
    machine = TSPBruteForce.new(graf, b_km, color_origin)
    TSPBruteForce.execute!(machine)

    is_hamiltonian = TSPBruteForce.have_solution(machine)
    write_result_is_hamiltonian!(path_results, id, is_hamiltonian)

    #=
    if is_hamiltonian
        println("BruteForceMachine: El grafo $id, hamiltoniano [TRUE]")
    else
        println("BruteForceMachine: El grafo $id, hamiltoniano [FALSE]")
    end
    =#
end

function main(args)
     n = parse(UInt128,first(args))

     base_path = "./data/results$n"
     path_tsp_machine = prepare_folders_results(base_path, "tsp_machine")
     path_hal_machine = prepare_folders_results(base_path, "hal_machine")
     path_tsp_brute = prepare_folders_results(base_path, "tsp_brute")

     println("### Classication ###")

     total = Int64(2^((n*(n-1))/2))
     Threads.@threads for id in 0:total-1
         test_clasification_tsp_machine(n, id, path_tsp_machine)
         test_clasification_hal_machine(n, id, path_hal_machine)
         test_clasification_tsp_brute_force(n, id, path_tsp_brute)
     end

     println("### Verification ###")

     total_ok = 0
     total_tsp_verficate = 0
     for id in 0:total-1
         result_tsp = read_result(path_tsp_machine, id)
         result_hal = read_result(path_hal_machine, id)

         result_brute = read_result(path_tsp_brute, id)
         verificate_tsp = result_tsp == result_brute

         if result_tsp == result_hal && result_tsp != "ERROR"
             total_ok += 1

             if verificate_tsp
                 total_tsp_verficate += 1
             end
         else
             println("Error $id")
         end
     end

     rate = (total_ok / total) * 100
     rate_tsp_verificate = (total_tsp_verficate/ total) * 100

     println("## Summary Test##")
     println("Graf. N: $n")
     println("TOTAL: $total")
     println("TOTAL OK: $total_ok")
     println("RATE: $rate%")
     println("RATE TSP VERIFICATE: $rate_tsp_verificate%")


end

function prepare_folders_results(base_path :: String, name_algorithm :: String) :: String
    if !isdir(base_path)
        mkdir(base_path)
    end

    base_path = "$base_path/$name_algorithm"

    if !isdir(base_path)
        mkdir(base_path)
    end

    path_hamiltonian = "$base_path/hamiltonian"
    if !isdir(path_hamiltonian)
        mkdir(path_hamiltonian)
    end

    path_non_hamiltonian = "$base_path/non-hamiltonian"
    if !isdir(path_non_hamiltonian)
        mkdir(path_non_hamiltonian)
    end

    return base_path
end

main(ARGS)
