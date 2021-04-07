
# Maximum theoretical $ O(N^9/128) $
# Most probable during construction less than $ O(N^6/128) * O(N) $ 
# Complete graphs during construction $ O(N^6/128) * O(1) $
# $ O(N^6/128) * O(stages) $
function review_owners_all_graph!(graph :: Graph)
    recursive_review_owners_all_graph!(graph, 1)
end

function recursive_review_owners_all_graph!(graph :: Graph, stage :: Int64)
    # Maximum cost of execute $ O(N^6/128) * O(stages) $
    # Theoretical If we would been execute it after remove each node $ O(N^3) * O(N^6/128) $
    # but in the practise we execute it at least deleting all nodes of a color
    # each delete node can produce a propation deleting, and before of delete all graph will be 
    # detected the owners like invalid then wont produce none deletion.

    # In the practise the executions dependes of the deletes stages required
    # in complete graphs is require one stage but in others graphs can required more stages
    # to be valid or invalid but in all cases is a polynomial (yes, expensive but polynomial)
    if graph.valid && graph.required_review_ownwers
        # $ O(N^3) $
        rebuild_owners(graph)
        # $ O(N^6/128) $
        review_owners_nodes_and_relationships!(graph)

        graph.required_review_ownwers = false
        if graph.valid && !isempty(graph.nodes_to_delete)
            graph.required_review_ownwers = true
            apply_node_deletes!(graph)
            recursive_review_owners_all_graph!(graph, stage + 1)
        end
    end
end

# $ O(N^3) $
function rebuild_owners(graph :: Graph)
    owners_new = Owners.empty_derive(graph.owners)
    # $ O(N) $ steps
    for step in Step(0):Step(graph.next_step-1)
        if haskey(graph.table_lines, step)
            nodes = graph.table_lines[step]
            # $ O(N^2) $  nodes by step
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

$ O(N^6/128) $
=#
function review_owners_nodes_and_relationships!(graph :: Graph)
    # $ O(step) * O(N^2) * O(N^3/128) = O(N^6/128) $
    if graph.valid && graph.required_review_ownwers
        step = Step(graph.next_step-1)
        stop_while = false
        # $ O(N steps) $
        while !stop_while
            # $ O(N^2) $ nodes by step
            for node_id in graph.table_lines[Step(step)]
                node = get_node(graph, node_id)
                # $ O(N^3/128) $
                if filter_by_intersection_owners!(node, graph.owners)
                    save_to_delete_node!(graph, node_id)
                # $ O(N^3/128) $
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

# $ O(N^3/128) $
function filter_by_intersection_owners!(node :: Node, owners :: OwnersByStep) :: Bool
    # with fixed binary set $ O(step) * O(N^2) / 128b $ (nodes by step)
    PathNode.intersect_owners!(node, owners)

    return !node.owners.valid
end

#=
IDEA: Si solo voy a un hijo entonces, es un color fijo dentro del camino,
los owners que tenga no pueden contenter solapamientos incoherentes con el padre.

$ O(N^3/128) $
=#
function filter_by_unique_son_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    # $ O(N) $
    total_sons = length(node.sons)
    have_unique_son = total_sons == 1
    if have_unique_son
        edge_id = first(values(node.sons))
        son_node_id = edge_id.destine_id
        son_node = get_node(graph, son_node_id)

        # $ O(N^3/128) $
        PathNode.intersect_owners!(node, son_node.owners)

        if node.owners.valid
            # $ O(N) $
            remove_parents_edges_arent_owner_node!(graph, node)
            return false
        else
            return true
        end
    else
        return false
    end
end

function remove_parents_edges_arent_owner_node!(graph :: Graph, node :: Node)
    # $ O(N) $
    for (origin_id, edge_id) in node.parents
        node_parent = get_node(graph, origin_id)
        if !PathNode.have_owner(node, node_parent)
            delete_edge_by_id!(graph, edge_id)
        end
    end
end
