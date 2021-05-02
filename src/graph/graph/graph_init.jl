function init!(graph :: Graph, action_id :: ActionId)
    node = new_node(graph, graph.color_origin, action_id)
    add_line!(graph)
    graph.next_step += 1
    graph.action_parent_id = action_id
    add_node!(graph, node)
end

function new_node(graph :: Graph, color_up :: Color, action_id :: ActionId) :: Node
    return PathNode.new(graph.n, graph.b, graph.next_step, color_up, graph.owners, action_id, graph.action_parent_id)
end

function add_line!(graph :: Graph)
    graph.table_lines[graph.next_step] = NodesIdSet()
end
