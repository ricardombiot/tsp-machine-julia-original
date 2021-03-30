module PathReader
    using Main.PathsSet.Alias: Km, Step, Color, ActionId

    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.NodeIdentity
    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathNode: Node
    using Main.PathsSet.Owners
    using Main.PathsSet.Owners: OwnersByStep

    mutable struct PathSolutionReader
        step :: Step
        route :: Array{Color, 1}
        next_node_id :: Union{NodeId, Nothing}
        owners :: OwnersByStep

        graph :: Graph
    end

    include("./reader_constructor.jl")
    include("./reader_next_step.jl")
    include("./reader_selection.jl")
    include("./reader_reduce_graph.jl")


    function load!(n :: Color, b :: Km, graph :: Graph) :: String
        path = new(n, b, graph :: Graph)
        calc!(path)
        txt_path = print_path(path)
        return "Longitud: $(path.step) Path: $txt_path"
    end

    function print_path(path :: PathSolutionReader) :: String
        txt = ""
        for color in path.route
            txt *= "$color, "
        end
        return chop(txt, tail = 1)
    end

end
