using Test
include("./../src/main.jl")

#=
@time @testset "PathsSet" begin
    include("test_hello.jl")
end


@time @testset "FBSet" begin
    include("./fbset/test_fbset.jl")
    include("./fbset/test_fixed_binary_set128.jl")
    include("./fbset/test_fbset_sequence.jl")
end


@time @testset "Graphs" begin
    include("./graph/components/test_node_identify.jl")
    include("./graph/components/test_owners_set.jl")
    include("./graph/components/test_owners.jl")
    include("./graph/components/test_node.jl")
    include("./graph/components/test_edge.jl")

    include("./graph/test_graph.jl")
    include("./graph/test_graph_delete.jl")
    include("./graph/test_graph_joins.jl")
    include("./graph/test_graph_multi_join.jl")
end


@time @testset "Actions" begin
    include("./actions/test_actions.jl")
    include("./actions/test_database_actions.jl")
    include("./actions/test_database_actions_disk.jl")
    include("./actions/test_controller_disk.jl")
end


@time @testset "Utils" begin
    include("./utils/test_generator_ids.jl")
end


=#

@time @testset "Machine" begin
    #=
    @testset "Program(Grafo)" begin
        include("machine/components/grafo/test_graf.jl")
        include("machine/components/grafo/test_tsplib.jl")
        include("machine/components/grafo/test_graf_writer.jl")
    end

    @testset "Timeline" begin
        include("machine/components/timeline/test_timeline_cell.jl")
        include("machine/components/timeline/test_timeline_table.jl")
    end
    =#

    #=
    @testset "TimelineDisk" begin
        include("machine/components/timeline/test_timeline_table_disk.jl")
    end

    @testset "Jumper" begin
        include("machine/components/jumper/test_jumper.jl")
    end
    =#


    @testset "Hamiltonian" begin
        #include("machine/hamiltonian/test_grafo_simple.jl")
        #include("machine/hamiltonian/test_grafo_doc_example.jl")
        #include("machine/hamiltonian/test_grafo_dir_example.jl")
        include("machine/hamiltonian/test_hal_machine.jl")
        #include("machine/hamiltonian/test_hal_machine_non_solution.jl")

        #include("machine/hamiltonian/test_grafo_dode.jl")
        #include("machine/hamiltonian/test_grafo_dode_exp.jl")

        #include("machine/hamiltonian/test_grafo_dode_reading_plot.jl")


        # ONLY FOR DEBUGING
        #include("machine/hamiltonian/test_grafo_dode_steps.jl")
    end


    @testset "Hamiltonian-reduce3sat" begin
        #include("machine/hamiltonian/reduce3sat/test_reduce3sat.jl")

        #include("machine/hamiltonian/reduce3sat/test_reduce3sat_steps.jl")
        #include("machine/hamiltonian/reduce3sat/test_reduce3sat_steps_unvalid.jl")
        #include("machine/hamiltonian/reduce3sat/test_reduce3sat_undirected.jl")
    end

    @testset "Subset-Sum" begin
        #include("machine/subset_sum/test_sum_program.jl")
        #include("machine/subset_sum/test_sum_machine.jl")
        #include("subset_sum/test_subset_sum.jl")
    end

    @testset "TSP" begin
        #include("machine/tsp/test_tsp_machine.jl")
        #include("machine/tsp/test_tsp_machine_completo.jl")
        #include("machine/tsp/test_tsp_machine_parallel_completo.jl")
    end

    @testset "TSP_disk" begin
        #include("machine/tsp_disk/test_tsp_machine_disk.jl")
    end

    @testset "TSPBruteForce" begin
        #include("machine/tsp_brute_force/test_brute_force.jl")
        #include("machine/tsp_brute_force/test_brute_force_complete.jl")
        #include("machine/tsp_brute_force/test_brute_force_non_solution.jl")
        #include("machine/tsp_brute_force/test_brute_force_dode.jl")
    end


end
