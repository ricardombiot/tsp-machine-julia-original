function join!(graph :: Graph, inmutable_graph_join :: Graph) :: Bool
    if is_valid_join(graph, inmutable_graph_join)
        graph_join = deepcopy(inmutable_graph_join)

        union_owners!(graph, graph_join)
        join_nodes!(graph, graph_join)
        join_lines!(graph, graph_join)
        join_color_nodes!(graph, graph_join)
        join_edges!(graph, graph_join)

        return true
    else
        return false
    end
end


function join_nodes!(graph :: Graph, graph_join :: Graph)
    for (action_id, dict) in graph_join.table_nodes
        if !haskey(graph.table_nodes, action_id)
            graph.table_nodes[action_id] = dict
        else
            actual_dict = graph.table_nodes[action_id]
            for (node_id, node) in dict
                if !haskey(actual_dict, node_id)
                    actual_dict[node_id] = node
                else
                    actual_node = actual_dict[node_id]
                    PathNode.join!(actual_node, node)
                end
            end
        end
    end
end

function join_lines!(graph :: Graph, graph_join :: Graph)
    for (step, nodes) in graph_join.table_lines
        union!(graph.table_lines[step], nodes)
    end
end

function join_color_nodes!(graph :: Graph, graph_join :: Graph)
    for (color, nodes) in graph_join.table_color_nodes
        if !haskey(graph.table_color_nodes, color)
            graph.table_color_nodes[color] = NodesIdSet()
        end

        union!(graph.table_color_nodes[color], nodes)
    end
end

function join_edges!(graph :: Graph, graph_join :: Graph)
    for (edge_id, edge) in graph_join.table_edges
        if !haskey(graph.table_edges, edge_id)
            graph.table_edges[edge_id] = edge
        else
            PathEdge.join!(graph.table_edges[edge_id], edge)
        end
    end
end

function is_valid_join(graph :: Graph, graph_join :: Graph)
    is_eq_step = graph.next_step == graph_join.next_step
    is_eq_origin = graph.color_origin == graph_join.color_origin
    is_both_valid = graph.valid && graph_join.valid
    is_eq_action_parent = graph.action_parent_id == graph_join.action_parent_id

    is_both_valid && is_eq_step && is_eq_origin && is_eq_action_parent
end
