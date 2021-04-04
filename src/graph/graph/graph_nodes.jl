function get_nodes_by_color(graph :: Graph, color :: Color) :: NodesIdSet
    if !haskey(graph.table_color_nodes, color)
        return NodesIdSet()
    end

    return graph.table_color_nodes[color]
end

function have_node(graph :: Graph, node_id :: NodeId) :: Bool
    return get_node(graph, node_id) != nothing
end

function get_node(graph :: Graph, node_id :: NodeId) :: Union{Node,Nothing}
    if haskey(graph.table_nodes, node_id.action_id)
        if haskey(graph.table_nodes[node_id.action_id], node_id)
            return graph.table_nodes[node_id.action_id][node_id]
        end
    end

    return nothing
end

#=function push_owner_myself_as_owner_of_me!(node :: Node)
    PathNode.push_owner!(node, node)
end
=#
