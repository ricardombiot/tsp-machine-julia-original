function parents_to_text(node :: Node) :: String
    parents_txt = ""
    for (node_id, edge_id) in node.parents
        node_id_txt = NodeIdentity.to_string(node_id)
        parents_txt *= "$(node_id_txt),"
    end

    return chop(parents_txt, tail = 1)
end

function sons_to_text(node :: Node) :: String
    sons_txt = ""
    for (node_id, edge_id) in node.sons
        node_id_txt = NodeIdentity.to_string(node_id)
        sons_txt *= "$(node_id_txt),"
    end

    return chop(sons_txt, tail = 1)
end


function node_edge_to_dot(graph :: Graph, edge :: Edge) :: String
    id_origin_txt = NodeIdentity.to_string(edge.id.origin_id,"_")
    id_destino_txt = NodeIdentity.to_string(edge.id.destine_id,"_")

    node_origin = "step_$(id_origin_txt)"
    node_destine = "step_$(id_destino_txt)"

    edge_txt = "$node_origin -> $node_destine;"

    return "$edge_txt \n"
end
