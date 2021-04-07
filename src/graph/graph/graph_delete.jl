
# $ O(N^4) $
function delete_node_by_color!(graph :: Graph, color :: Color)
    if graph.valid
        # in each step only can produce a action by color (origin node),
        # each action can produce $ O(N) $ nodes by color then
        # $ O(N^2) $ of each color
        for node_id in get_nodes_by_color(graph, color)
            save_to_delete_node!(graph, node_id)

            if !graph.valid
                break
            end
        end

        # $ O(N^4) $ deleting all nodes
        apply_node_deletes!(graph)
    end
end

function save_to_delete_node!(graph :: Graph, node_id :: NodeId)
    if graph.valid
        node = get_node(graph, node_id)

        if node != nothing
            save_to_delete_node!(graph, node)
        end
    end
end
function save_to_delete_node!(graph :: Graph, node :: Node)
    pop_owner_in_graph!(graph, node)
    push!(graph.nodes_to_delete, node.id)
end

function pop_owner_in_graph!(graph :: Graph, node_owner :: Node)
    if graph.valid
        Owners.pop!(graph.owners, node_owner.step, node_owner.id)
        graph.required_review_ownwers = true
        make_validation_graph_by_owners!(graph)
    end
end

function make_validation_graph_by_owners!(graph :: Graph)
    graph.valid = graph.owners.valid
end

# $ O(N^4) $
function apply_node_deletes!(graph :: Graph)
    # It will be execute less than $ O(N^3) $ delete total nodes
    # after will be detected that graph is unvalid.
    if graph.valid
        if !isempty(graph.nodes_to_delete)
            node_id = pop!(graph.nodes_to_delete)

            # $ O(N) $
            delete_node!(graph, node_id)

            graph.required_review_ownwers = true
            apply_node_deletes!(graph)
        end
    end
end
