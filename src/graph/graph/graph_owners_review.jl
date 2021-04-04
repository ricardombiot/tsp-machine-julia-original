
function review_owners_all_graph!(graph)
    if graph.valid && graph.required_review_ownwers
        rebuild_owners(graph)
        #review_owners!(graph)
        #review_relationship_owners!(graph)
        review_owners_nodes_and_relationships!(graph)

        graph.required_review_ownwers = false
        if graph.valid && !isempty(graph.nodes_to_delete)
            #println("ReReview_owners !!")
            graph.required_review_ownwers = true
            apply_node_deletes!(graph)
            review_owners_all_graph!(graph)
        end
    end
end

function rebuild_owners(graph :: Graph)
    owners_new = Owners.empty_derive(graph.owners)
    for step in Step(0):Step(graph.next_step-1)
        if haskey(graph.table_lines, step)
            nodes = graph.table_lines[step]
            for node_id in nodes
                Owners.push!(owners_new, step, node_id)
            end
        end
    end

    graph.owners = owners_new
    make_validation_graph_by_owners!(graph)
end

#=
Down to top
1. Make the intersection of graph owners, with the owners of each node
In others words, we will delete the node owners that dont exist now in the graph.

Target: Avoid that the owners of nodes are incoherent with the actual nodes of graph.

2. If a node only have a Son (all set of paths use this son node).
Make intersect between the owners of parent node and the unique son.

Target: We want avoid the existence of incoherent relationships into a paths,
between the parent and son.

Nota: All this incoherents can be produce in the join process.
=#
function review_owners_nodes_and_relationships!(graph :: Graph)
    if graph.valid && graph.required_review_ownwers
        step = Step(graph.next_step-1)
        stop_while = false
        while !stop_while
            for node_id in graph.table_lines[Step(step)]
                node = get_node(graph, node_id)
                if filter_by_intersection_owners!(node, graph.owners)
                    save_to_delete_node!(graph, node_id)
                elseif filter_by_unique_son_intersection_owners!(graph, node)
                    save_to_delete_node!(graph, node_id)
                end
            end

            if step == Step(0) || !graph.valid
                stop_while = true
            else
                step -= 1
            end
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
        #println("review_owners!")
        for (action_id, table_nodes_action) in graph.table_nodes
            for (node_id, node) in table_nodes_action
                if filter_by_intersection_owners!(node, graph.owners)
                    #println("-> save_node_to_delete")
                    save_to_delete_node!(graph, node_id)
                end
            end
        end


    end
end


function review_relationship_owners!(graph :: Graph)
    if graph.valid && graph.required_review_ownwers
        for (action_id, table_nodes_action) in graph.table_nodes
            for (node_id, node) in table_nodes_action
                if filter_by_unique_son_intersection_owners!(graph, node)
                    #println("-> delete node unique son incoherent")
                    save_to_delete_node!(graph, node_id)
                end
            end
        end
    end
end


function filter_by_intersection_owners!(node :: Node, owners :: OwnersByStep) :: Bool
    PathNode.intersect_owners!(node, owners)

    return !node.owners.valid
end

function filter_by_intersection_owners!(edge :: Edge, owners :: OwnersByStep) :: Bool
    PathEdge.intersect_owners!(edge, owners)

    return !edge.owners.valid
end

#=
IDEA: Si solo voy a un hijo entonces, es un color fijo dentro del camino,
los owners que tenga no pueden contenter solapamientos incoherentes con el padre.
=#
function filter_by_unique_son_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    total_sons = length(node.sons)
    have_unique_son = total_sons == 1
    if have_unique_son
        edge_id = first(values(node.sons))
        son_node_id = edge_id.destine_id
        son_node = get_node(graph, son_node_id)

        PathNode.intersect_owners!(node, son_node.owners)

        return !node.owners.valid
    else
        return false
    end
end
