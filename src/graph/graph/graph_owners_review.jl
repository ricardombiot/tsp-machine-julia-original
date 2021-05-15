
# Maximum theoretical $ O(N^9/128) $
# Most probable during construction less than $ O(N^6/128) * O(N) $
# Complete graphs during construction $ O(N^6/128) * O(1) $
# $ O(stages) * O(N^6/128) $
# $ O(Stages) * O(N^7) $
function review_owners_all_graph!(graph :: Graph)
    recursive_review_owners_all_graph!(graph, 1)
end

# $ O(Stages) * O(N^7) $
function recursive_review_owners_all_graph!(graph :: Graph, stage :: Int64)
    if stage > graph.n
        println("-> Expensive review more than N.")
    elseif stage > 2
        println("-> Expensive review more than 2 ( $stage > 2 ).")
    end

    # Maximum cost of execute $ O(N^6/128) * O(stages) $
    # Theoretical If we would been execute it after remove each node $ O(N^3) * O(N^6/128) $
    # but in the practise we execute it at least deleting all nodes of a color
    # each delete node can produce a propation deleting, and before of delete all graph will be
    # detected the owners like invalid then wont produce none deletion.

    # In the practise the executions dependes of the deletes stages required
    # in complete graphs is require one stage but in others graphs can required more stages
    # to be valid or invalid but in all cases is a polynomial (yes, expensive but polynomial)
    if graph.valid && graph.required_review_ownwers
        #review_owners_colors!(graph)
        #apply_node_deletes!(graph)

        # $ O(N^3) $
        rebuild_owners(graph)
        # $ O(N^7) $
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
$ O(N^7) $
=#
function review_owners_nodes_and_relationships!(graph :: Graph)
    # $ O(step) * O(N^2) * O(N^3/128) = O(N^6/128) $
    # $ O(N) * O(N^2) * O(N^4) = O(N^7) $
    if graph.valid && graph.required_review_ownwers
        step = Step(graph.next_step-1)
        stop_while = false
        # $ O(N) steps $
        while !stop_while
            # $ O(N^2) $ nodes by step
            for node_id in graph.table_lines[Step(step)]
                node = get_node(graph, node_id)
                # $ O(N^3/128) $
                if filter_by_intersection_owners!(node, graph.owners)
                    save_to_delete_node!(graph, node_id)
                # $ O(N^4) $
                elseif filter_by_sons_intersection_owners!(graph, node)
                    save_to_delete_node!(graph, node_id)
                # $ O(N^3) $
                elseif filter_by_incoherence_colors(graph, node)
                    save_to_delete_node!(graph, node_id)
                end
            end

            # $ O(N^6) $
            review_sons_filtering_by_parents_interection_owners!(graph, step)

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


# $ O(N^6) $
# Date inclusion 7/5/2021
function review_sons_filtering_by_parents_interection_owners!(graph :: Graph, step :: Step)
    last_step = Step(graph.next_step-1)
    if step != last_step && graph.valid
        # $ O(N^2) $ nodes by step
        for node_id in graph.table_lines[Step(step)]
            node = get_node(graph, node_id)

            if node.owners.valid
                # $ O(N^4) $
                if filter_by_parents_intersection_owners!(graph, node)
                    #println("Filter by parents intersection")
                    save_to_delete_node!(graph, node_id)
                end
            end
        end
    end
end
# $ O(N^4) $
function filter_by_sons_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    last_step = Step(graph.next_step-1)
    if node.step != last_step
        owners_sons_union :: Union{OwnersByStep,Nothing} = nothing

        # $ O(N) $
        for (son_node_id, edge_id) in node.sons
            son_node = get_node(graph, son_node_id)

            if son_node.owners.valid
                if owners_sons_union == nothing
                    owners_sons_union = deepcopy(son_node.owners)
                else
                    # $ O(N) Steps * O(N^2) = O(N^3) $
                    Owners.union!(owners_sons_union, son_node.owners)
                end
            end
        end

        if owners_sons_union == nothing
            return true
        elseif owners_sons_union.valid
            # $ O(N^3) $
            PathNode.intersect_owners!(node, owners_sons_union)
            if !node.owners.valid
                return true
            else
                # $ O(N) $
                if node.step != Step(0)
                    remove_parents_edges_arent_owner_node!(graph, node)
                end

                return false
            end
        else
            return false
        end
    else
        return false
    end
end



# $ O(N^4) $
function filter_by_parents_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    first_step = Step(0)
    if node.step != first_step
        owners_parents_union :: Union{OwnersByStep,Nothing} = nothing

        # $ O(N) $
        for (parent_node_id, edge_id) in node.parents
            parent_node = get_node(graph, parent_node_id)

            if parent_node.owners.valid
                if owners_parents_union == nothing
                    owners_parents_union = deepcopy(parent_node.owners)
                else
                    # $ O(N) Steps * O(N^2) = O(N^3) $
                    Owners.union!(owners_parents_union, parent_node.owners)
                end
            end
        end

        if owners_parents_union == nothing
            return true
        elseif owners_parents_union.valid
            # $ O(N^3) $
            PathNode.intersect_owners!(node, owners_parents_union)
            if !node.owners.valid
                return true
            else
                # $ O(N) $
                if node.step != Step(0)
                    remove_sons_edges_arent_owner_node!(graph, node)
                end

                return false
            end
        else
            return false
        end
    else
        return false
    end
end

# $ O(N^3) $
function filter_by_incoherence_colors(graph :: Graph, node :: Node) :: Bool
    set_of_all_colors = SetColors()
    set_conflict_colors = SetColors()

    # $ O(Step) = O(N) $
    for step in Step(0):Step(graph.next_step-1)
        # $ O(N^2) $
        colors_step = load_all_colors_node_step_at_review_owners(graph, step, node)

        # $ O(N) $
        if controller_incoherence_fixed_color_in_more_than_one_step!(graph.n, step, set_conflict_colors, colors_step)
            return true
        end
        # $ O(N) $
        if controller_incoherence_enough_color!(graph.n, step, set_of_all_colors, colors_step)
            return true
        end
    end

    return false
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


function remove_sons_edges_arent_owner_node!(graph :: Graph, node :: Node)
    # $ O(N) $
    for (destine_id, edge_id) in node.sons
        node_son = get_node(graph, destine_id)
        if !PathNode.have_owner(node, node_son)
            delete_edge_by_id!(graph, edge_id)
        end
    end
end
