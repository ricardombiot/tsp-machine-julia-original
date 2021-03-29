function to_dot(graph :: Graph) :: String

    dot_content_txt = ""

    for (step, list_actions) in get_list_actions_id_by_step(graph)
        def_nodes = ""
        for action_id in list_actions
            def_nodes *= action_id_to_dot(graph, action_id) *"\n"
        end

        dot_content_txt *= "
        subgraph cluster_$step {
        style=filled;
        color=lightgrey;
        node [style=filled,color=white];
        $def_nodes
        fontsize=\"10\"
        label = \"Line $step\";
        }\n"
    end


    for (edge_id, edge) in graph.table_edges
        dot_content_txt *= node_edge_to_dot(graph, edge)
    end

    dot_txt = "digraph G {\n"
    dot_txt *= info_graph_to_dot(graph, dot_content_txt)
    dot_txt *= "}"
end

function info_graph_to_dot(graph :: Graph, content :: String) :: String
    dot_txt = "subgraph cluster_info {"
    #labels_txt = ""
    #dot_txt *= "label = \"$labels_txt\"\n";
    dot_txt *= content
    dot_txt *= "}"

    return dot_txt
end

function action_id_to_dot(graph :: Graph, action_id :: ActionId) :: String
    dot_txt ="subgraph cluster_act_$action_id {\n"
    dot_txt *= "label = \"Action: $action_id\"";
    for (NodeId, node) in graph.table_nodes[action_id]
        color = node.color
        sons_nodes_txt = sons_to_text(node)
        parents_nodes_txt = parents_to_text(node)

        id_txt = NodeIdentity.to_string(node.id,"_")
        node_id_txt = NodeIdentity.to_string(node.id)
        name = "step_$(id_txt)"
        node_label_html = "<$color<BR /><FONT POINT-SIZE=\"8\">ID: $node_id_txt</FONT>"
        node_label_html *= "<BR /><FONT POINT-SIZE=\"8\">Parents: $parents_nodes_txt</FONT>"
        node_label_html *= "<BR /><FONT POINT-SIZE=\"8\">Sons: $sons_nodes_txt</FONT>"
        node_label_html *= ">"
        node_definition =  "$name [label=$node_label_html]"

        dot_txt *= node_definition*"\n"
    end
    dot_txt *= "}"

    return dot_txt
end
