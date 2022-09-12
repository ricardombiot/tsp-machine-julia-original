# Theoretical Maximum: $ O(N^3) $
# Init case: $ O(1) $
function add_node!(graph :: Graph, node :: Node)
    if !haskey(graph.table_nodes, node.action_id)
        graph.table_nodes[node.action_id] = Dict{NodeId, Node}()
    end

    graph.table_nodes[node.action_id][node.id] = node
    add_node_color!(graph, node)
    add_node_in_line!(graph, node)

    push_owner_myself_as_owner_of_me!(node)

    # $ O(N^3) $
    push_node_as_new_owner!(graph, node)
    push_owner_in_graph!(graph, node)
end

function add_node_color!(graph :: Graph, node :: Node)
    if !haskey(graph.table_color_nodes, node.color)
        graph.table_color_nodes[node.color] = NodesIdSet()
    end

    push!(graph.table_color_nodes[node.color], node.id)
end

function add_node_in_line!(graph :: Graph, node :: Node)
    if haskey(graph.table_lines, node.step)
        push!(graph.table_lines[node.step], node.id)
    end
end

function push_owner_myself_as_owner_of_me!(node :: Node)
    PathNode.push_owner!(node, node)
end

# $ O(Steps) * O(N^2) = O(N^3) $ maximum number of nodes in graph
function push_node_as_new_owner!(graph :: Graph, node_owner :: Node)
    # The cost will be proportional to length of graph then
    # graph.step * $ O(N^2) $ by step, until $ O(N^3) $

    # $ O(N) $ steps * $ O(N) $ actions by step
    for (action_id, table_nodes_action) in graph.table_nodes
        # $ O(N) $ nodes by action
        for (node_id, node) in table_nodes_action
            PathNode.push_owner!(node, node_owner)
        end
    end
end

function push_owner_in_graph!(graph :: Graph, node_owner :: Node)
    Owners.push!(graph.owners, node_owner.step, node_owner.id)
end
