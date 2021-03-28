function add_node_as_owner(graph :: Graph, node :: Node)
    # Add node in the
    #Owners.push!(graph.owners, node.step, node.id)
    #Owners.push!(node.owners, node.step, node.id)
end


#=
No es necesaria porque se inicializa con owners
function add_owners_new_node!(graph :: Graph, node :: Node)
    PathNode.init_owners!(node, graph.table_lines)
end
=#

#=
function add_owners_new_edge!(graph :: Graph, edge :: Edge)
    node_origin = get_node(graph, edge.id.origin_id)
    EdgeRelation.init_owners_by_parent!(edge, node_origin.owners)
end
=#

function push_owner_in_graph!(graph :: Graph, node_owner :: Node)
    Owners.push!(graph.owners, node_owner.step, node_owner.id)
end

function pop_owner_in_graph!(graph :: Graph, node_owner :: Node)
    Owners.pop!(graph.owners, node_owner.step, node_owner.id)
end

function push_node_as_new_owner!(graph :: Graph, node_owner :: Node)
    push_owner_in_graph!(graph, node_owner)

    for (action_id, table_nodes_action) in graph.table_nodes
        for (node_id, node) in table_nodes_action
            PathNode.push_owner!(node, node_owner)
        end
    end

    for (edge_id, edge) in graph.table_edges
        PathEdge.push_owner!(edge, node_owner)
    end
end
