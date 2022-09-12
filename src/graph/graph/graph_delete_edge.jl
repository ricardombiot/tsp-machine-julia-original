

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

        # when origin node have edge then is becauses isnt the last step
        if !PathNode.have_sons(node_origin)
            save_to_delete_node!(graph, node_origin)
        end
    end
end
