# Maximum theoretical $ O(N^10) $
# Most probable less than: $ O(N^8) $
function up!(graph :: Graph, color :: Color, action_id :: ActionId)
    # $ O(N^4) $ deleting all nodes
    delete_node_by_color!(graph, color)

    # Maximum theoretical $ O(N^{10}) $
    # Most probable less than N stages: $ O(N^8) $
    # $ O(Stages) * O(N^7) $
    review_owners_all_graph!(graph)

    # $ O(N^3) $
    make_up!(graph, color, action_id)
end

# $ O(N^3) $
function make_up!(graph :: Graph, color :: Color, action_id :: ActionId)
    last_step = graph.next_step - 1
    node = new_node(graph, color, action_id)
    graph.action_parent_id = action_id
    add_line!(graph)
    # $ O(N^3) $
    add_node!(graph, node)

    # $ O(N) $
    add_all_nodes_last_step_as_parents!(graph, node, last_step)

    graph.next_step += 1
end

# $ O(N) $
function add_all_nodes_last_step_as_parents!(graph :: Graph, node :: Node, last_step :: Step)
    # $ O(N) - Origin - Itself $ then $ O(N-2) $ parents by node
    for parent_id in graph.table_lines[last_step]
        add_edge!(graph, parent_id, node.id)
    end
end

function add_edge!(graph :: Graph, origin_id :: NodeId, destine_id :: NodeId)
    if have_node(graph, origin_id) && have_node(graph, destine_id)
        node_origin = get_node(graph, origin_id)
        node_destine = get_node(graph, destine_id)

        edge = PathEdge.build!(node_origin, node_destine)

        graph.table_edges[edge.id] = edge
    end
end
