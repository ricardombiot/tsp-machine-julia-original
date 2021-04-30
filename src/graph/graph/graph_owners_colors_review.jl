function review_owners_colors!(graph :: Graph)
    # $ O(N) $ steps
    for step in Step(0):Step(graph.next_step-1)
        if haskey(graph.table_lines, step)
            nodes = graph.table_lines[step]
            # $ O(N^2) $  nodes by step
            for node_id in nodes
                if have_incoherence_color(graph, node_id)
                    save_to_delete_node!(graph, node_id)
                end
            end
        end
    end

    #apply_node_deletes!(graph)
end

function have_incoherence_color(graph :: Graph, node_id :: NodeId) :: Bool
    set_of_all_colors = SetColors()
    set_conflict_colors = SetColors()
    node = get_node(graph, node_id)

    for step in Step(0):Step(graph.next_step-1)
        colors_step = load_all_colors_node_step(graph, step, node)

        if controller_incoherence_fixed_color_in_more_than_one_step!(graph.n, step, set_conflict_colors, colors_step)
            #println("Filter by k$(node_id.key) fixed color incoherence")
            return true
        end

        if controller_incoherence_enough_color!(graph.n, step, set_of_all_colors, colors_step)
            #println("Filter by k$(node_id.key) enough colors incoherence")
            return true
        end
    end

    return false
end

function controller_incoherence_enough_color!(n :: Color, step :: Step, set_of_all_colors :: SetColors,  colors_step :: SetColors) :: Bool
    union!(set_of_all_colors, colors_step)
    number_of_possible_colors = length(set_of_all_colors)
    # No puedo filter el nodo join
    number_color_required_step = Int64(min(n, step+1))
    if number_of_possible_colors < number_color_required_step
        return true
    else
        return false
    end
end

function controller_incoherence_fixed_color_in_more_than_one_step!(n :: Color, step :: Step, set_conflict_colors :: SetColors,  colors_step :: SetColors) :: Bool
    if length(colors_step) == 1 && n > step+1
        if issubset(colors_step, set_conflict_colors)
            return true
        else
            union!(set_conflict_colors, colors_step)
        end
    end

    return false
end

function load_all_colors_node_step(graph :: Graph, step :: Step, node :: Node) :: SetColors
    colors :: SetColors = SetColors()

    for node_id in graph.table_lines[step]
        if Owners.have(node.owners, step, node_id)
            node_owner = PathGraph.get_node(graph, node_id)
            push!(colors, node_owner.color)
        end
    end

    return colors
end
