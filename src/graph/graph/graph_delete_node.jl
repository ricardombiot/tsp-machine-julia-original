
function delete_node!(graph :: Graph, node_id :: NodeId)
    if have_node(graph, node_id) && graph.valid
        node = get_node(graph, node_id)
        make_delete_node!(graph, node)

        apply_node_deletes!(graph)
    end
end

function make_delete_node!(graph :: Graph, node :: Node)
    if graph.valid
        delete_node_of_line!(graph, node)
        delete_node_of_table_colors!(graph, node)
        delete_edges_parents!(graph, node)
        delete_edges_sons!(graph, node)
        delete_node_of_table_nodes!(graph, node)
    end
end

function delete_node_of_line!(graph :: Graph, node :: Node)
    if haskey(graph.table_lines, node.step) && graph.valid
        nodes_in_line = graph.table_lines[node.step]
        if node.id in nodes_in_line
            pop!(nodes_in_line, node.id)
        end
    end
end

function delete_node_of_table_colors!(graph :: Graph, node :: Node)
    if haskey(graph.table_color_nodes, node.color) && graph.valid
        nodes_color = graph.table_color_nodes[node.color]
        if node.id in nodes_color
            pop!(nodes_color, node.id)
        end
    end
end


function delete_edges_parents!(graph :: Graph, node :: Node)
    if graph.valid
        destine_id = node.id
        for (origin_id, edge_id) in node.parents
            delete_edge_by_id!(graph, edge_id)
        end
    end
end

function delete_edges_sons!(graph :: Graph, node :: Node)
    if graph.valid
        origin_id = node.id
        for (destine_id, edge_id)  in node.sons
            delete_edge_by_id!(graph, edge_id)
        end
    end
end

function delete_node_of_table_nodes!(graph :: Graph, node :: Node)
    action_group_node = graph.table_nodes[node.action_id]
    delete!(action_group_node, node.id)

    if isempty(action_group_node)
        delete!(graph.table_nodes, node.action_id)
    end
end
