using Test
include("./../src/main.jl")

#=
@time @testset "PathsSet" begin
    include("test_hello.jl")
end

@time @testset "FBSet" begin
    include("./fbset/test_fbset.jl")
    include("./fbset/test_fixed_binary_set128.jl")
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
end

=#
@time @testset "Machine" begin
    @testset "Program(Grafo)" begin
        include("machine/grafo/test_graf.jl")
        include("machine/grafo/test_tsplib.jl")
    end

    @testset "Timeline" begin
        include("machine/timeline/test_timeline_cell.jl")
        include("machine/timeline/test_timeline_table.jl")
    end

    @testset "Hamiltonian" begin
        include("machine/hamiltonian/test_grafo_simple.jl")
        include("machine/hamiltonian/test_hal_machine.jl")
    end
end



@time @testset "Utils" begin
    include("./utils/test_generator_ids.jl")
end
