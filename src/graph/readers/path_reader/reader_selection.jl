function fixed_next!(path :: PathSolutionReader)
    node = PathGraph.get_node(path.graph, path.next_node_id)
    path.next_node_id = selected_next(path, node)

    println("[$(path.step)] Selected: $(path.next_node_id.key)")
end

function selected_next(path :: PathSolutionReader, node :: Node) :: Union{NodeId,Nothing}
    if path.graph.valid
        if !isempty(node.sons)
            (node_id, edge_id) = first(node.sons)
            return node_id
        end

        return nothing
    else
        return nothing
    end
end
