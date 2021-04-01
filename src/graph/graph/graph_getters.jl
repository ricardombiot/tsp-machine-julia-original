function get_lenght(graph :: Graph) :: Step
    graph.next_step
end

function get_id_origin(graph :: Graph) :: NodeId
    first(graph.table_lines[Step(0)])
end

function get_action_id_origin(graph :: Graph) :: ActionId
    node_id = get_id_origin(graph)
    node = get_node(graph, node_id)

    return node.action_id
end
