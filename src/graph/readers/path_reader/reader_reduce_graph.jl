
function clear_graph_by_owners!(path :: PathSolutionReader)
    # Elimino los no visitados
    #Owners.intersect!(path.graph.owners, path.owners)
    remove_all_nodes_dont_selected_line(path)

    #delete_node_by_color_except_selected!(path)
    path.graph.required_review_ownwers = true
    PathGraph.review_owners_all_graph!(path.graph)
end

function remove_all_nodes_dont_selected_line(path :: PathSolutionReader)
    for node_id in PathGraph.get_line_nodes(path.graph, path.step)
        if node_id != path.next_node_id
            println("Remove node in line... ")
            PathGraph.save_to_delete_node!(path.graph, node_id)
        end
    end

    PathGraph.apply_node_deletes!(path.graph)
end

#=
function review_owners_filter!(graph :: Graph, owners :: OwnersByStep)
    if graph.valid
        for (action_id, table_nodes_action) in graph.table_nodes
            for (node_id, node) in table_nodes_action
                if !PathGraph.filter_by_intersection_owners!(node, owners)
                    PathGraph.save_to_delete_node!(graph, node_id)
                #elseif !PathGraph.filter_by_intersection_owners!(node, graph.owners)
                #    PathGraph.save_to_delete_node!(graph, node_id)
                end
            end
        end

        for (edge_id, edge) in graph.table_edges
            if !PathGraph.filter_by_intersection_owners!(edge, owners)
                PathGraph.delete_edge_by_id!(graph, edge_id)
            #elseif !PathGraph.filter_by_intersection_owners!(edge, graph.owners)
            #    PathGraph.delete_edge_by_id!(graph, edge_id)
            end
        end

    end
end
=#


# hay solapamientos así que mejor eliminarlos
function delete_node_by_color_except_selected!(path :: PathSolutionReader)
    ## Esto no debería ser necesario porque si los owners functionaran bien.

    if path.graph.valid && path.next_node_id != nothing
        node = PathGraph.get_node(path.graph, path.next_node_id)
        if node != nothing
            for node_id in PathGraph.get_nodes_by_color(path.graph, node.color)
                if node_id != node.id
                    PathGraph.save_to_delete_node!(path.graph, node_id)
                end
            end

            PathGraph.apply_node_deletes!(path.graph)
        end
    end
end
#==#
