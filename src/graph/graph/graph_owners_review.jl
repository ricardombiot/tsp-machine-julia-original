
# Maximum theoretical $ O(N^{10}) $
# Most probable less than N stages: $ O(N^8) $
# $ O(Stages) * O(N^7) $
function review_owners_all_graph!(graph :: Graph)
    recursive_review_owners_all_graph!(graph, 1)
end

function save_max_review_stages!(graph :: Graph, stage :: Int64)
    #=
    if stage > graph.n
        println("-> Expensive review more than N.")
    elseif stage >= 1
        println("-> Stages: $stage >= 1.")
    end
    =#
    graph.max_review_stages = max(graph.max_review_stages, stage)
end

# Theoretical Maximum Cost of execution $ O(N^7) * O(stages) $
function recursive_review_owners_all_graph!(graph :: Graph, stage :: Int64)
    # Theoretical:
    # If we would execute it after remove each node $ O(N^3) * O(N^7) = O(N^10) $
    # but in the practise we execute it at least deleting all nodes of a color
    # each delete node can produce a propation deleting, and before of delete all nodes of
    # graph will detected this situation with the owners.

    # It is important see that the number of executions dependes of the deletes stages required
    # to be valid or invalid graph, that at the same time depends of the instance
    # but in all cases follow a polynomial function.
    # -yes, polynomial expensive function, but polynomial be-
    if graph.valid && graph.required_review_ownwers
        save_max_review_stages!(graph, stage)

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
1. filter_by_intersection_owners!
2. filter_by_sons_intersection_owners!
3. filter_by_incoherence_colors!
4. review_sons_filtering_by_parents_interection_owners!
$ O(N^7) $
=#
function review_owners_nodes_and_relationships!(graph :: Graph)
    # $ O(N) * O(N^2) * O(N^4) = O(N^7) $
    if graph.valid && graph.required_review_ownwers
        step = graph.next_step - Step(1)
        stop_while = false
        # $ O(N) steps $
        while !stop_while
            # $ O(N^2) $ nodes by step
            for node_id in graph.table_lines[Step(step)]
                node = get_node(graph, node_id)
                # $ O(N^3) $
                if filter_by_intersection_owners!(node, graph.owners)
                    save_to_delete_node!(graph, node_id)
                # $ O(N^4) $
                elseif filter_by_sons_intersection_owners!(graph, node)
                    save_to_delete_node!(graph, node_id)
                # $ O(N^3) $
                elseif filter_by_incoherence_colors!(graph, node)
                    save_to_delete_node!(graph, node_id)
                end
            end

            # $ O(N^6) $
            review_sons_filtering_by_parents_interection_owners!(graph, step)

            if step == Step(0) || !graph.valid
                stop_while = true
            else
                step -= Step(1)
            end
        end
    end
end

# $ O(N^3) $
function filter_by_intersection_owners!(node :: Node, owners :: OwnersByStep) :: Bool
    # with fixed binary set $ O(step) * O(N^2) / 128b $ (nodes by step)
    PathNode.intersect_owners!(node, owners)

    return !node.owners.valid
end


# $ O(N^6) $
# Date inclusion 7/5/2021
function review_sons_filtering_by_parents_interection_owners!(graph :: Graph, step :: Step)
    last_step = graph.next_step - Step(1)
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
function filter_by_incoherence_colors!(graph :: Graph, node :: Node) :: Bool
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
