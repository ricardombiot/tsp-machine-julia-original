
function log_owners_write(graph :: Graph, name :: String, path :: String )
    input_file = "$path/$(name).txt"
    txt = log_to_string_nodes_owners(graph)
    open(input_file, "w") do io
        print(io, txt)
    end
end

function log_to_string_nodes_owners(graph :: Graph) :: String
    txt = ""
    txt *= "Graph Owners"
    txt *= Owners.to_string_list(graph.owners)
    txt *= "\n\n"

    for (step, nodes) in graph.table_lines
        txt *= "LINE $step \n"
        for node_id in nodes
            node = get_node(graph, node_id)
            txt *= "OWNERS NODE: $(node.step), $(node.color)"
            txt *= "\n"
            txt *= Owners.to_string_list(node.owners)
            txt *= "\n"
        end
        txt *= "\n"
    end

    return txt
end
