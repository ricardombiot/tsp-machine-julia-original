include("./../../src/main.jl")
using Dates

function write_result!(path :: String, id :: Int64, txt_solutions :: String, txt_time :: String)
        path_file_solutions = "$(path)/$(id)_solutions.txt"
        path_file_time = "$(path)/$(id)_time.txt"


        open(path_file_solutions, "w") do io
            write(io, txt_solutions)
        end

        open(path_file_time, "w") do io
            write(io, txt_time)
        end
end

function execute_tsp_machine_parallel(graf :: Grafo, n :: Color, id :: Int64, path_results :: String)
        color_origin = Color(0)
        b_km = Km(n*10)
        machine = TSPMachine.new(graf, b_km, color_origin)

        time = now()
        TSPMachineParallel.execute!(machine)
        time_execute = now() - time

        if SolutionGraphReader.have_solution(machine)

                graph_join = SolutionGraphReader.get_graph_join_origin(machine)

                limit = factorial(n-1)
                reader_exp = PathExpReader.new(graf.n, b_km, graph_join, limit, true)
                PathExpReader.calc!(reader_exp)

                txt_solutions = PathExpReader.to_string_solutions(reader_exp)
                println(txt_solutions)

                txt_time = "$time_execute"
                write_result!(path_results, id, txt_solutions, txt_time)
        else
                txt_time = "$time_execute"
                write_result!(path_results, id, "NON-HAMILTONIAN", txt_time)
        end

        println("TSPMachine [$id] in $time_execute")
end

function execute_tsp_brute_parallel(graf :: Grafo, n :: Color, id :: Int64, path_results :: String)
        color_origin = Color(0)
        b_km = Km(n*10)

        color_origin = Color(0)
        machine = TSPBruteForceParallel.new(graf, b_km, color_origin, true)
        time = now()
        TSPBruteForceParallel.execute!(machine)
        time_execute = now() - time

        if TSPBruteForceParallel.have_solution(machine)
                txt_solutions = TSPBruteForceParallel.to_string_solutions(machine)
                println(txt_solutions)

                txt_time = "$time_execute"
                write_result!(path_results, id, txt_solutions, txt_time)
        else
                txt_time = "$time_execute"
                write_result!(path_results, id, "NON-HAMILTONIAN", txt_time)
        end

        println("TSPBrute [$id] in $time_execute")
end

function main(args)
        n = parse(UInt128,popfirst!(args))
        total = parse(Int64,popfirst!(args))


        path_graphs = "./../../../../test_tsp_vs_brute_noncomplete/data/grafs$n"

        base_path = "./data/results$n"
        path_tsp_machine = prepare_folders_results(base_path, "tsp_machine_parallel")
        path_tsp_brute = prepare_folders_results(base_path, "tsp_brute")

        ## Repeted the id: 0 (avoid julia fisrt execution time)
        id = 0
        graf = GrafGenerator.read_tsplib_file("$id",path_graphs,".tsp")
        execute_tsp_machine_parallel(graf, n, id, path_tsp_machine)
        execute_tsp_brute_parallel(graf, n, id, path_tsp_brute)

        for id in 0:total-1
                graf = GrafGenerator.read_tsplib_file("$id",path_graphs,".tsp")
                execute_tsp_machine_parallel(graf, n, id, path_tsp_machine)
                execute_tsp_brute_parallel(graf, n, id, path_tsp_brute)
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

    return base_path
end

main(ARGS)
