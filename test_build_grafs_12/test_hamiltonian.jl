include("./../src/main.jl")

function write_result_is_hamiltonian!(path :: String, id :: Int64, is_hamiltonian :: Bool)
    if is_hamiltonian
        path_action_file = "$(path)/hamiltonian/$(id)"
    else
        path_action_file = "$(path)/non-hamiltonian/$(id)"
    end

    if !isfile(path_action_file)
        shell_command = `touch $(path_action_file)`
        run(shell_command)
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

    if is_hamiltonian
        println("TSPMachine: El grafo $id, hamiltoniano [TRUE]")
    else
        println("TSPMachine: El grafo $id, hamiltoniano [FALSE]")
    end
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

    if is_hamiltonian
        println("HalMachine: El grafo $id, hamiltoniano [TRUE]")
    else
        println("HalMachine: El grafo $id, hamiltoniano [FALSE]")
    end
end

    #=
function read_directory(directory :: String, extenstion :: String, graf_start :: Int64 = -1, graf_end :: Int64 = -1)
    cd(directory)
    if graf_start == -1
        lista_grafs = readdir()
    else
        lista_grafs = Array{String, 1}()
        for name in graf_start:graf_end
            path = "./$(name)$(extenstion)"
            if !isfile(path)
                break
            end

            push!(lista_grafs, path)
        end
    end

    return lista_grafs
end
=#

function main(args)
     n = parse(UInt128,first(args))

     base_path = "./data/results$n"
     path_tsp_machine = prepare_folders_results(base_path, "tsp_machine")
     path_hal_machine = prepare_folders_results(base_path, "hal_machine")


     total = Int64(2^((n*(n-1))/2))
     for id in 0:total-1
         test_clasification_tsp_machine(n, id, path_tsp_machine)
         test_clasification_hal_machine(n, id, path_hal_machine)
     end

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
