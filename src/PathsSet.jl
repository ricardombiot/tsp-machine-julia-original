module PathsSet

    include("utils/alias.jl")
    include("utils/generator_ids.jl")

    include("fbset/FBSet128.jl")
    include("fbset/FBSet.jl")

    include("graph/components/node_identity/node_identity.jl")
    include("graph/components/edge_identity/edge_identity.jl")
    include("graph/components/owners/owners_set.jl")
    include("graph/components/owners/owners.jl")
    include("graph/components/node/node.jl")
    include("graph/components/edge/edge.jl")
    include("graph/graph/path_graph.jl")
    include("graph/graphviz/graphviz.jl")
    include("graph/readers/path_reader/path_reader.jl")
    include("graph/readers/path_exp_reader/path_exp_reader.jl")


    include("actions/actions.jl")
    include("actions/database_actions.jl")
    include("actions/database_actions_disk.jl")
    include("actions/database_interface.jl")
    include("actions/database_memory_controller.jl")
    include("actions/execute.jl")

    include("machine/grafo/graf.jl")
    include("machine/grafo/graf_generator.jl")

    include("machine/timeline/timeline_cell.jl")
    include("machine/timeline/timeline_table.jl")

    include("machine/hamiltonian/hal_machine.jl")

    include("machine/readers/imachine.jl")
    include("machine/readers/solution_graph_reader.jl")
    include("machine/readers/path_checker.jl")

end # module
