
function add_node!(graph :: Graph, node :: Node)
    if !haskey(graph.table_nodes, node.action_id)
        graph.table_nodes[node.action_id] = Dict{NodeId, Node}()
    end

    graph.table_nodes[node.action_id][node.id] = node
    add_node_color!(graph, node)
    add_node_in_line!(graph, node)
end

function add_node_in_line!(graph :: Graph, node :: Node)
    if haskey(graph.table_lines, node.step)
        push!(graph.table_lines[node.step], node.id)
    else
        throw("The line $(node.step) dont exist remeber add_line! before")
    end
end

function get_nodes_by_color(graph :: Graph, color :: Color) :: NodesIdSet
    if !haskey(graph.table_color_nodes, color)
        return NodesIdSet()
    end

    return graph.table_color_nodes[color]
end

function add_node_color!(graph :: Graph, node :: Node)
    if !haskey(graph.table_color_nodes, node.color)
        graph.table_color_nodes[node.color] = NodesIdSet()
    end

    push!(graph.table_color_nodes[node.color], node.id)
end


function have_node(graph :: Graph, node_id :: NodeId) :: Bool
    return get_node(graph, node_id) != nothing
end

function get_node(graph :: Graph, node_id :: NodeId) :: Union{Node,Nothing}
    if haskey(graph.table_nodes, node_id.action_id)
        if haskey(graph.table_nodes[node_id.action_id], node_id)
            return graph.table_nodes[node_id.action_id][node_id]
        end
    end

    return nothing
end
