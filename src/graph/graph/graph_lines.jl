function add_line!(graph :: Graph)
    graph.table_lines[graph.next_step] = NodesIdSet()
end

function get_line_nodes(graph :: Graph, step :: Step) :: NodesIdSet
    if haskey(graph.table_lines, step)
        return graph.table_lines[step]
    else
        return NodesIdSet()
    end
end
