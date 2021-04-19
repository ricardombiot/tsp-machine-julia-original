module PathReader
    using Main.PathsSet.Alias: Km, Step, Color, ActionId

    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.NodeIdentity
    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathNode: Node
    using Main.PathsSet.Owners
    using Main.PathsSet.Owners: OwnersByStep

    using Main.PathsSet.Graphviz

    mutable struct PathSolutionReader
        step :: Step
        route :: Array{Color, 1}
        next_node_id :: Union{NodeId, Nothing}
        owners :: OwnersByStep

        graph :: Graph
        is_origin_join :: Bool
    end

    include("./reader_constructor.jl")
    include("./reader_next_step.jl")
    include("./reader_selection.jl")
    include("./reader_reduce_graph.jl")
    include("./reader_calc_and_plot.jl")

    function read_and_plot!(n :: Color, b :: Km, graph :: Graph, dir :: String, is_origin_join :: Bool = false) :: PathSolutionReader
        path = new(n, b, graph, is_origin_join)
        calc_and_plot!(path, dir)
        return path
    end

    function read!(n :: Color, b :: Km, graph :: Graph, is_origin_join :: Bool = false) :: PathSolutionReader
        path = new(n, b, graph, is_origin_join)
        calc!(path)
        return path
    end

    function load_and_plot!(n :: Color, b :: Km, graph :: Graph, dir :: String, is_origin_join :: Bool = false) :: Tuple{String, PathSolutionReader}
        path = new(n, b, graph, is_origin_join)
        calc_and_plot!(path, dir)
        txt_path = print_path(path)
        txt_path = "Longitud: $(path.step) Path: $txt_path"
        return (txt_path, path)
    end

    function load!(n :: Color, b :: Km, graph :: Graph, is_origin_join :: Bool = false) :: Tuple{String, PathSolutionReader}
        path = new(n, b, graph, is_origin_join)
        calc!(path)
        txt_path = print_path(path)
        txt_path = "Longitud: $(path.step) Path: $txt_path"
        return (txt_path, path)
    end

    function print_path(path :: PathSolutionReader) :: String
        txt = ""
        for color in path.route
            txt *= "$color, "
        end
        return chop(txt, tail = 1)
    end

end
