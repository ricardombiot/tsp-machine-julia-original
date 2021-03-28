using Test
include("./../src/main.jl")

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
end

@time @testset "Utils" begin
    include("./utils/test_generator_ids.jl")
end
