function up!(graph :: Graph, color :: Color, action_id :: ActionId)
    delete_node_by_color!(graph, color)
    review_owners_all_graph!(graph)
    make_up!(graph, color, action_id)
end

function make_up!(graph :: Graph, color :: Color, action_id :: ActionId)
    last_step = graph.next_step - 1
    node = new_node(graph, color, action_id)
    graph.action_parent_id = action_id
    add_line!(graph)
    add_node!(graph, node)

    for parent_id in graph.table_lines[last_step]
        add_edge!(graph, parent_id, node.id)
    end

    push_node_as_new_owner!(graph, node)
    graph.next_step += 1
end

function add_edge!(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId)
    if have_node(graph, origin_id) && have_node(graph, destine_id)
        node_origin = get_node(graph, origin_id)
        node_destine = get_node(graph, destine_id)

        edge = PathEdge.build!(node_origin, node_destine)

        graph.table_edges[edge.id] = edge
    end
end

function push_node_as_new_owner!(graph :: Graph, node_owner :: Node)
    for (action_id, table_nodes_action) in graph.table_nodes
        for (node_id, node) in table_nodes_action
            PathNode.push_owner!(node, node_owner)
        end
    end
end
