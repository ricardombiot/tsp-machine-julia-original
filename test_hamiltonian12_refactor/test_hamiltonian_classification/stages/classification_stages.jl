module ClassificationStages
    using Main.PathsSet.Alias: Color, Km

    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.Graf: Grafo

    using Main.PathsSet.HalMachine
    using Main.PathsSet.TSPMachine
    using Main.PathsSet.TSPBruteForce

    using Main.PathsSet.SolutionGraphReader

    using Dates

    mutable struct DataClassification
        n :: Color
        path_tsp_machine :: String
        path_hal_machine :: String
        path_tsp_brute :: String

        total :: Int64
        total_ok :: Int64
        total_time_tsp_machine :: Base.Threads.Atomic{Int64}
        total_time_hal_machine :: Base.Threads.Atomic{Int64}
        total_time_tsp_brute :: Base.Threads.Atomic{Int64}
        counter :: Base.Threads.Atomic{Int64}

        avg_time_tsp_machine :: Float64
        avg_time_hal_machine :: Float64
        avg_time_tsp_brute :: Float64

        rate_ok :: Float64
        rate_tsp_verificate :: Float64
    end

    function get_root_data_path() :: String
        "./../../../../test_hamiltonian12/data/"
    end

    include("./methods/classification_results.jl")
    include("./methods/classification_utils.jl")
    include("./machines/classification_tsp_machine.jl")
    include("./machines/classification_hal_machine.jl")
    include("./machines/classification_force_brute.jl")

    include("./stage_init.jl")
    include("./stage_classification.jl")
    include("./stage_verification.jl")

    function run!(base_path :: String, n :: Color)
        data = stage_init(base_path, n)

        println("### Classication ###")
        stage_classification!(data)

        println("### Verification ###")
        state_verification!(data)

        println("## Summary Test ##")
        println("Graf. N: $(data.n)")
        println("TOTAL: $(data.total)")
        println("TOTAL OK: $(data.total_ok)")
        println("RATE: $(data.rate_ok)%")
        println("RATE TSP VERIFICATE: $(data.rate_tsp_verificate)%")
        println("## Times ##")
        println("Avg. TSP Machine: $(data.avg_time_tsp_machine) ms")
        println("Avg. Hal Machine: $(data.avg_time_hal_machine) ms")
        println("Avg. Force Machine: $(data.avg_time_tsp_brute) ms")
    end

end
