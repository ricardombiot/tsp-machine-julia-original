function have_edge(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId) :: Bool
    get_edge(graph, origin_id, destine_id) != nothing
end

function get_edge(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId) :: Union{Edge, Nothing}
    edge_id = EdgeIdentity.new(origin_id, destine_id)
    return get_edge(graph, edge_id)
end

function get_edge(graph :: Graph, edge_id :: EdgeId) :: Union{Edge, Nothing}
    if haskey(graph.table_edges, edge_id)
        return graph.table_edges[edge_id]
    end

    return nothing
end
