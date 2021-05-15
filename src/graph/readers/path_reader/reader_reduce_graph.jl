
function clear_graph_by_owners!(path :: PathSolutionReader)
    # Elimino los no visitados
    if remove_all_nodes_dont_selected_line(path)
        path.graph.required_review_ownwers = true
        PathGraph.review_owners_all_graph!(path.graph)
    end
end

function remove_all_nodes_dont_selected_line(path :: PathSolutionReader)
    nodes_to_delete = 0
    for node_id in PathGraph.get_line_nodes(path.graph, path.step)
        if node_id != path.next_node_id
            #println("[$(path.step)] Remove node in line... $(node_id.key) ")
            PathGraph.save_to_delete_node!(path.graph, node_id)
            nodes_to_delete += 1
        end
    end

    if nodes_to_delete > 0
        PathGraph.apply_node_deletes!(path.graph)
        return true
    else
        return false
    end
end
