
function clear_graph_by_owners!(path :: PathSolutionReader)
    # Elimino los no visitados
    remove_all_nodes_dont_selected_line(path)
    path.graph.required_review_ownwers = true
    PathGraph.review_owners_all_graph!(path.graph)
end

function remove_all_nodes_dont_selected_line(path :: PathSolutionReader)
    for node_id in PathGraph.get_line_nodes(path.graph, path.step)
        if node_id != path.next_node_id
            #println("Remove node in line... ")
            PathGraph.save_to_delete_node!(path.graph, node_id)
        end
    end

    PathGraph.apply_node_deletes!(path.graph)
end
