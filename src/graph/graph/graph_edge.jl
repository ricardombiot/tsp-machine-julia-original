function add_edge!(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId)
    if have_node(graph, origin_id) && have_node(graph, destine_id)
        node_origin = get_node(graph, origin_id)
        node_destine = get_node(graph, destine_id)

        edge = PathEdge.build!(node_origin, node_destine)

        graph.table_edges[edge.id] = edge
    end
end

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



function delete_edge!(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId)
    edge_id = EdgeIdentity.new(origin_id, destine_id)
    delete_edge_by_id!(graph, edge_id)
end

function delete_edge_by_id!(graph :: Graph, edge_id :: EdgeId)
    if have_node(graph, edge_id.origin_id) && have_node(graph, edge_id.destine_id) && have_edge(graph, edge_id.origin_id, edge_id.destine_id)
        delete!(graph.table_edges, edge_id)

        node_origin = get_node(graph, edge_id.origin_id)
        node_destine = get_node(graph, edge_id.destine_id)
        PathEdge.destroy!(node_origin, node_destine)

        if !PathNode.have_parents(node_destine)
            save_to_delete_node!(graph, node_destine)
        end

        if !PathNode.have_sons(node_origin)
            save_to_delete_node!(graph, node_origin)
        end
    end
end
