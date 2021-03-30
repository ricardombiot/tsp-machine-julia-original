function new(n :: Color, b :: Km, graph :: Graph, is_origin_join :: Bool = false)
    step = Step(0)
    route = Array{Color, 1}()

    next_node_id = get_fisrt_node_id(n, b, graph)
    owners = get_init_owners(graph)
    graph_copy = deepcopy(graph)

    path = PathSolutionReader(step, route, next_node_id, owners, graph_copy, is_origin_join)

    return path
end

function get_fisrt_node_id(n :: Color, b :: Km, graph :: Graph) :: NodeId
    action_id_init = PathGraph.get_action_id_origin(graph)
    return NodeIdentity.new(n, b, action_id_init, nothing)
end

function get_init_owners(graph :: Graph) :: OwnersByStep
    return Owners.empty_derive(graph.owners)
end
