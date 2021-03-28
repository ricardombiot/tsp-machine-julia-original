
function delete_node_by_color!(graph :: Graph, color :: Color)
    if graph.valid
        for node_id in get_nodes_by_color(graph, color)
            save_to_delete_node!(graph, node_id)

            # Lazy optimization
            if !graph.valid
                break
            end
        end

        apply_node_deletes!(graph)
    end
end

function apply_node_deletes!(graph :: Graph)
    if graph.valid
        if !isempty(graph.nodes_to_delete)
            node_id = pop!(graph.nodes_to_delete)
            delete_node!(graph, node_id)

            apply_node_deletes!(graph)
        else
            review_owners!(graph)

            if !isempty(graph.nodes_to_delete)
                apply_node_deletes!(graph)
            end
        end
    end
end

function delete_node!(graph :: Graph, node_id :: NodeId)
    if have_node(graph, node_id) && graph.valid
        node = get_node(graph, node_id)
        make_delete_node!(graph, node)

        apply_node_deletes!(graph)
    end
end

function make_delete_node!(graph :: Graph, node :: Node)
    if graph.valid
        delete_node_of_line!(graph, node)
        delete_node_of_table_colors!(graph, node)
        delete_edges_parents!(graph, node)
        delete_edges_sons!(graph, node)
        delete_node_of_table_nodes!(graph, node)
    end
end

function delete_node_of_line!(graph :: Graph, node :: Node)
    if haskey(graph.table_lines, node.step) && graph.valid
        nodes_in_line = graph.table_lines[node.step]
        if node.id in nodes_in_line
            pop!(nodes_in_line, node.id)

            # Cover by owners
            #if isempty(nodes_in_line)
            #    graph.valid = false
            #end
        end
    end
end

function delete_node_of_table_colors!(graph :: Graph, node :: Node)
    if haskey(graph.table_color_nodes, node.color) && graph.valid
        nodes_color = graph.table_color_nodes[node.color]
        if node.id in nodes_color
            pop!(nodes_color, node.id)
        end
    end
end


function delete_edges_parents!(graph :: Graph, node :: Node)
    if graph.valid
        destine_id = node.id
        for origin_id in node.parents
            if have_edge(graph, origin_id, destine_id)
                delete_edge!(graph, origin_id, destine_id)
            end
        end
    end
end

function delete_edges_sons!(graph :: Graph, node :: Node)
    if graph.valid
        origin_id = node.id
        for destine_id in node.sons
            if have_edge(graph, origin_id, destine_id)
                delete_edge!(graph, origin_id, destine_id)
            end
        end
    end
end

function delete_node_of_table_nodes(graph :: Graph, node :: Node)
    action_group_node = graph.table_nodes[node.action_id]
    delete!(action_group_node, node.id)

    if isempty(action_group_node)
        delete!(graph.table_nodes, node.action_id)
    end
end


function save_to_delete_node!(graph :: Graph, node :: Node)
    pop_owner_in_graph!(graph, node)
    push!(graph.nodes_to_delete, node.id)
end
function save_to_delete_node!(graph :: Graph, node_id :: NodeId)
    if graph.valid
        node = get_node(graph, node_id)

        if node != nothing
            save_to_delete_node!(graph, node)
        end
    end
end
