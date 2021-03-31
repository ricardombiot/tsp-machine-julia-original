function push_owner_in_graph!(graph :: Graph, node_owner :: Node)
    Owners.push!(graph.owners, node_owner.step, node_owner.id)
end

function pop_owner_in_graph!(graph :: Graph, node_owner :: Node)
    if graph.valid
        Owners.pop!(graph.owners, node_owner.step, node_owner.id)
        make_validation_graph_by_owners!(graph)
    end
end

function union_owners!(graph :: Graph, graph_join :: Graph)
    Owners.union!(graph.owners, graph_join.owners)
end

function make_validation_graph_by_owners!(graph :: Graph)
    graph.valid = graph.owners.valid
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


function review_owners_all_graph!(graph)
    if graph.valid && graph.required_review_ownwers
        review_owners!(graph)

        if graph.valid && !isempty(graph.nodes_to_delete)
            graph.required_review_ownwers = true
            apply_node_deletes!(graph)
            review_owners_all_graph!(graph)
        end
    end
end



#=
Realizamos una interection mutable de los sets de owners, con la intención de evitar
que los sets de owners contengan ids de nodos que no existen actualmente en graph.

Si posteriormente se demuestra que esos owners son correctos entonces, se acaban recuperando
al realizar un join con otro graph.

La idea detras de esto es mantener la coherencia en la información, no podemos tener un owner
que no existe.
=#
function review_owners!(graph :: Graph)
    if graph.valid && graph.required_review_ownwers
        println("review_owners!")
        for (action_id, table_nodes_action) in graph.table_nodes
            for (node_id, node) in table_nodes_action    
                if !filter_by_intersection_owners!(node, graph.owners)
                    #println("-> save_node_to_delete")
                    save_to_delete_node!(graph, node_id)
                end
            end
        end

        for (edge_id, edge) in graph.table_edges
            if !filter_by_intersection_owners!(edge, graph.owners)
                #println("-> delete_id")
                delete_edge_by_id!(graph, edge_id)
            end
        end

        graph.required_review_ownwers = false
    end
end


function filter_by_intersection_owners!(node :: Node, owners :: OwnersByStep) :: Bool
    PathNode.intersect_owners!(node, owners)

    return node.owners.valid
end

function filter_by_intersection_owners!(edge :: Edge, owners :: OwnersByStep) :: Bool
    PathEdge.intersect_owners!(edge, owners)

    return edge.owners.valid
end

#=
Evitar que al realizar joins nodos tengan owners con el mismo color.

function remove_equal_color_owners_node!(graph :: Graph)
    if graph.valid
        for (color, set_nodes) in graph.table_color_nodes
            for selected_node_id in set_nodes
                selected_node = get_node(graph, selected_node_id)
                for target_node_id in set_nodes
                    if selected_node_id != target_node_id

                        target_node = get_node(graph, target_node_id)
                        if PathNode.have_owner(selected_node, target_node)
                            PathNode.pop_owner!(selected_node, target_node)

                            for (node_id, edge_id) in selected_node.sons
                                edge = get_edge(graph, edge_id)

                                PathEdge.pop_owner!(edge, target_node)
                            end
                        end
                    end
                end
            end
        end

    end
end
=#
