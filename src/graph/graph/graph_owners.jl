function push_node_as_new_owner!(graph :: Graph, node_owner :: Node)
    for (action_id, table_nodes_action) in graph.table_nodes
        for (node_id, node) in table_nodes_action
            PathNode.push_owner!(node, node_owner)
        end
    end
end

function pop_owner_in_graph!(graph :: Graph, node_owner :: Node)
    if graph.valid
        Owners.pop!(graph.owners, node_owner.step, node_owner.id)
        graph.required_review_ownwers = true
        make_validation_graph_by_owners!(graph)
    end
end

function make_validation_graph_by_owners!(graph :: Graph)
    graph.valid = graph.owners.valid
end
