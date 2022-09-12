# O(N^2)
function load_all_colors_node_step_at_review_owners(graph :: Graph, step :: Step, node :: Node) :: SetColors
    colors :: SetColors = SetColors()

    # $ O(N^2) $
    for node_id in graph.table_lines[step]
        if Owners.have(node.owners, step, node_id)
            node_owner = PathGraph.get_node(graph, node_id)

            if node_owner.owners.valid
                push!(colors, node_owner.color)
            end
        end
    end

    return colors
end

# $ O(N) $
function controller_incoherence_enough_color!(n :: Color, step :: Step, set_of_all_colors :: SetColors,  colors_step :: SetColors) :: Bool
    # $ O(N) $
    union!(set_of_all_colors, colors_step)
    number_of_possible_colors = length(set_of_all_colors)
    # I shouldn´t filter the return to origin node
    number_color_required_step = Int64(min(n, step+1))
    if number_of_possible_colors < number_color_required_step
        return true
    else
        return false
    end
end

# $ O(N) $
function controller_incoherence_fixed_color_in_more_than_one_step!(n :: Color, step :: Step, set_conflict_colors :: SetColors,  colors_step :: SetColors) :: Bool
    if length(colors_step) == 1 && n > step+1
        # colors_step only have one color
        # $ O(N) $ (can remplace by one check)
        if issubset(colors_step, set_conflict_colors)
            return true
        else
        # $ O(N) $ (can remplace by one insert)
            union!(set_conflict_colors, colors_step)
        end
    end

    return false
end
