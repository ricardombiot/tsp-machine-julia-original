function calc!(path :: PathSolutionReader)
    if next_step!(path)
        calc!(path)
    else
        close_path(path)
    end
end

function close_path(path :: PathSolutionReader)
    if !path.is_origin_join
        push!(path.route, path.graph.color_origin)
        path.step += 1
    end
end

function next_step!(path :: PathSolutionReader) :: Bool
    if path.next_node_id != nothing
        push_step!(path)
        fixed_next!(path)
        clear_graph_by_owners!(path)
        return true
    else
        return false
    end
end

function is_finished(path :: PathSolutionReader)
    path.next_node_id == nothing
end


function push_step!(path :: PathSolutionReader)
    node = PathGraph.get_node(path.graph, path.next_node_id)

    push!(path.route, node.color)
    Owners.push!(path.owners, path.step, path.next_node_id)

    println("[$(path.step)] Push step: $(path.next_node_id.key) ($(node.color))")
    path.step += 1
end
