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
