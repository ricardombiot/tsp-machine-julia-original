function fixed_next!(path :: PathSolutionReader, node :: Node)
    path.next_node_id = selected_next(path, node)
end

function selected_next(path :: PathSolutionReader, node :: Node) :: Union{NodeId,Nothing}
    if !isempty(node.sons)
        (node_id, edge_id) = first(node.sons)
        return node_id
    end

    return nothing
end
