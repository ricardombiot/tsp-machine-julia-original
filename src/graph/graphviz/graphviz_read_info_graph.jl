function get_list_actions_id_by_step(graph :: Graph) :: Dict{Step, Array{ActionId, 1}}
    dist_lines = Dict{Step, Array{ActionId, 1}}()
    for (step, nodes) in graph.table_lines
        list_actions_id = Array{ActionId, 1}()
        for node_id in nodes
            node = PathGraph.get_node(graph, node_id)
            push!(list_actions_id, node.action_id)
        end

        dist_lines[step] = list_actions_id
    end

    return dist_lines
end
