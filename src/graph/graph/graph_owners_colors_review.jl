function clear_owners_by_conflict_colors!(graph :: Graph)
    review_owners_colors!(graph)

    if !isempty(graph.nodes_to_delete)
        graph.required_review_ownwers = true
        apply_node_deletes!(graph)
    end
end

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

                #if !have_enough_color(graph, node_id)
                    #println("STEP: $step Filter $(node_id.key) by enough review colors")
                #    save_to_delete_node!(graph, node_id)
                #end

                #=
                if have_conflict_color(graph, node_id)
                    println("Filter by review colors")
                    save_to_delete_node!(graph, node_id)
                end
                =#
            end
        end
    end

    apply_node_deletes!(graph)
end

function have_conflict_color(graph :: Graph, node_id :: NodeId) :: Bool
    set_of_conflict_colors = SetColors()
    node = get_node(graph, node_id)

    for step in Step(0):Step(graph.next_step-1)
        conflict_color = load_conflict_colors_node_step(graph, step, node)

        #if node_id.key == 4109
        #    println("STEP: $step COLOR: $conflict_color")
        #end

        if conflict_color != nothing
            if conflict_color in set_of_conflict_colors
                return true
            else
                push!(set_of_conflict_colors, conflict_color)
            end
        end
    end

    return false
end

function load_conflict_colors_node_step(graph :: Graph, step :: Step, node :: Node) :: Union{Color, Nothing}

    color_conflict :: Union{Color, Nothing} = nothing
    counter_owners :: Int64 = 0
    for node_id in graph.table_lines[step]
        if Owners.have(node.owners, step, node_id)
            node_owner = PathGraph.get_node(graph, node_id)
            # If have more than one different color
            if color_conflict != node_owner.color
                counter_owners += 1
            end

            if counter_owners > 1
                return nothing
            else
                color_conflict = node_owner.color
            end
        end
    end

    if counter_owners == 1
        return color_conflict
    end
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


function have_enough_color(graph :: Graph, node_id :: NodeId) :: Bool
    set_of_all_colors = SetColors()
    node = get_node(graph, node_id)

    for step in Step(0):Step(graph.next_step-1)
        colors_step = load_all_colors_node_step(graph, step, node)

        union!(set_of_all_colors, colors_step)

        number_of_possible_colors = length(set_of_all_colors)
        # No puedo filter el nodo join
        number_color_required_step = Int64(min(graph.n, step+1))
        if number_of_possible_colors < number_color_required_step
            #println("$number_of_possible_colors < $(step+1)")
            return false
        end
    end

    return true
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


#=

function review_owners_colors!(graph :: Graph)
    dict_conflicts = Dict{NodeId, SetColors}()
    # if exist have bool = false then havent conflict
    # if exist have a color is the unique color, then is conflict
    #dict_step_conflict :: Dict{NodeId, Union{Color, Bool}}


    # $ O(N) $ steps
    for step in Step(0):Step(graph.next_step-1)
        #println("")
        dict_step_conflict = Dict{NodeId, Union{Color, Nothing}}()

        if haskey(graph.table_lines, step)
            nodes = graph.table_lines[step]
            # $ O(N^2) $  nodes by step

            if step == Step(0)
                println("Step: 0")
                println(nodes)
            end

            for node_id in nodes
                #println("STEP: $step node_id: $node_id")
                node = get_node(graph, node_id)
                color_checked = node.color

                if color_checked == Color(0) && step == Step(0)
                    println("ORIGIN")
                end

                show = 0
                # $ O(N^3) $ Para todos los nodos
                for step_target in Step(0):Step(graph.next_step-1)
                    if haskey(graph.table_lines, step_target)
                        nodes_target = graph.table_lines[step_target]
                        for node_id_target in nodes_target
                            node_target = get_node(graph, node_id_target)
                            if PathNode.have_owner(node_target, node)
                                if node_id_target.key == 4109 && node_id.key == 1
                                    println("Is owner de origin")
                                end
                            #if Owners.have(node_target.owners, step, node_id)
                                if haskey(dict_step_conflict, node_id_target)
                                    #println("$(dict_step_conflict[node_id_target])")
                                    if color_checked == Color(0) && step == Step(0)
                                        println("aqui no puede llegar en origin")
                                    end

                                    if dict_step_conflict[node_id_target] != color_checked
                                        dict_step_conflict[node_id_target] = nothing
                                    end
                                else
                                    if node_id_target.key == 4109
                                        println("Color checker $color_checked in step $step")
                                    end
                                    dict_step_conflict[node_id_target] = color_checked
                                end
                            end

                            if node_id_target.key == 4109 && show == 0
                                if haskey(dict_conflicts, node_id_target)
                                    set_colors_conflict = dict_conflicts[node_id_target]
                                    println("step:: $step [$(node_id_target.key)] SetColors...  $(set_colors_conflict)")
                                else
                                    println("step:: $step no tiene colores conflictivos")
                                end
                                show = 1
                            end

                        end
                    end
                end


                #=
                for (action_id, nodes_by_id) in graph.table_nodes
                    for (node_id_target, node_target) in nodes_by_id
                        if Owners.have(node_target.owners, step, node_id)
                            #println("Owner... $(node_id_target.key)")

                        end
                    end
                end
                =#

            end




            for (node_id_target, conflict_color) in dict_step_conflict
                if conflict_color != nothing
                    if haskey(dict_conflicts, node_id_target)


                        set_colors_conflict = dict_conflicts[node_id_target]
                        #println("[$(node_id_target.key)] SetColors...  $(set_colors_conflict)")
                        if conflict_color in set_colors_conflict
                            # Si solo hay un color, en mas de un paso entonces es incorrecto.
                            println("Filter by review colors")
                            save_to_delete_node!(graph, node_id)
                        else
                            if node_id_target.key == 4109
                                println("Save color conflict... $(node_id_target.key) - $conflict_color")
                            end
                            #println("Save color conflict... $(node_id_target.key) - $conflict_color")
                            push!(dict_conflicts[node_id_target], conflict_color)
                        end

                        if node_id_target.key == 4109
                            println("[$(node_id_target.key)] SetColors...  $(set_colors_conflict)")
                        end
                    else
                        #println("Save color conflict... $(node_id_target.key) - $conflict_color")
                        dict_conflicts[node_id_target] = SetColors([conflict_color])
                    end
                end
            end


        end

    end
end

=#
