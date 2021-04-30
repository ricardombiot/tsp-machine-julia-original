module ISetOfPaths
    using Main.PathsSet.Alias: Color, SetColors, Km, Step, UniqueNodeKey, ActionId

    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.NodeIdentity: NodeId, NodesIdSet
    using Main.PathsSet.PathNode: Node

    using Main.PathsSet.PathReader
    using Main.PathsSet.PathReader: PathSolutionReader

    function new(n :: Color, b :: Km, color_origin :: Color, action_id :: ActionId) :: Graph
        PathGraph.new(n, b, color_origin, action_id)
    end

    function get_lenght(graph :: Graph) :: Step
        PathGraph.get_lenght(graph)
    end

    function isempty(graph :: Graph) :: Bool
        !graph.valid
    end

    function visit!(graph :: Graph, color :: Color, action_id :: ActionId) :: Graph
        PathGraph.up!(graph, color, action_id)
    end

    function force_visit!(graph :: Graph, color :: Color, action_id :: ActionId) :: Graph
        PathGraph.make_up!(graph, color, action_id)
    end

    function join!(graph :: Graph, inmutable_graph_join :: Graph) :: Bool
        PathGraph.join!(graph, inmutable_graph_join)
    end

    function read_one_path(graph :: Graph, is_origin_join :: Bool = false) :: PathSolutionReader
        path = PathReader.new(graph.n, graph.b, graph, is_origin_join)
        PathReader.calc!(path)
        return path
    end

    function to_string_one_path(path :: PathSolutionReader) :: String
        PathReader.to_string_path(path)
    end

    function read_collection_paths(graph :: Graph, limit :: UInt128 , is_origin_join :: Bool = false) :: PathSolutionExpReader
        reader_exp = PathExpReader.new(graph.n, graph.b, graph, limit, is_origin_join, "")
        PathExpReader.calc!(reader_exp)

        return reader_exp
    end

    function print_collection_paths(reader_exp :: PathSolutionExpReader)
        PathExpReader.print_solutions(reader_exp)
    end

    function get_length_collection_paths(reader_exp) :: PathSolutionExpReader
        PathExpReader.get_total_solutions_found(reader_exp)
    end

end
