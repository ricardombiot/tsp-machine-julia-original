function add_node_as_owner(graph :: Graph, node :: Node)
    # Add node in the
    #Owners.push!(graph.owners, node.step, node.id)
    #Owners.push!(node.owners, node.step, node.id)
end


#=
No es necesaria porque se inicializa con owners
function add_owners_new_node!(graph :: Graph, node :: Node)
    PathNode.init_owners!(node, graph.table_lines)
end
=#

#=
function add_owners_new_edge!(graph :: Graph, edge :: Edge)
    node_origin = get_node(graph, edge.id.origin_id)
    EdgeRelation.init_owners_by_parent!(edge, node_origin.owners)
end
=#


function push_owner_in_graph!(graph :: Graph, node_owner :: Node)
    Owners.push!(graph.owners, node_owner.step, node_owner.id)
end

function pop_owner_in_graph!(graph :: Graph, node_owner :: Node)
    if graph.valid
        Owners.pop!(graph.owners, node_owner.step, node_owner.id)
        make_validation_graph_by_owners!(graph)
    end
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


#=
Realizamos una interection mutable de los sets de owners, con la intención de evitar
que los sets de owners contengan ids de nodos que no existen actualmente en graph.

Si posteriormente se demuestra que esos owners son correctos entonces, se acaban recuperando
al realizar un join con otro graph.

La idea detras de esto es mantener la coherencia en la información, no podemos tener un owner
que no existe.
=#
function review_owners!(graph :: Graph)
    if graph.valid
        for (action_id, table_nodes_action) in graph.table_nodes
            for (node_id, node) in table_nodes_action
                if !filter_by_intersection_owners!(node, graph)
                    save_to_delete_node!(graph, node_id)
                end
            end
        end

        for (edge_id, edge) in graph.table_edges
            if !filter_by_intersection_owners!(edge, graph)
                delete_edge_by_id!(graph, edge_id)
            end
        end
    end
end


function filter_by_intersection_owners!(node :: Node, graph :: Graph) :: Bool
    PathNode.intersect_owners!(node, graph)

    return node.owners.valid
end

function filter_by_intersection_owners!(edge :: Node, graph :: Graph) :: Bool
    PathEdge.intersect_owners!(edge, graph)

    return edge.owners.valid
end
