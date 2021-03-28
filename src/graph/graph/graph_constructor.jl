
function new(n :: Color, b :: Km, color_origin :: Color, action_id :: ActionId)
    next_step = Step(0)
    owners = new_graph_owners(n, b)

    table_nodes = Dict{ActionId, Dict{NodeId, Node}}()
    table_color_nodes = Dict{Color, NodesIdSet}()
    table_lines = Dict{Step, NodesIdSet}()
    table_edges = Dict{EdgeId, Edge}()
    nodes_to_delete = NodesIdSet()

    valid = true
    action_parent_id = nothing

    graph = Graph(n, b, next_step, color_origin, owners,
            table_nodes, table_edges,
            table_lines, table_color_nodes,
            action_parent_id,
            nodes_to_delete, valid)

    init!(graph, action_id)
    return graph
end

function new_graph_owners(n :: Color, b :: Km) :: OwnersByStep
    bbnn = Int64(b^2*n^2)
    return Owners.new(bbnn)
end

function init!(graph :: Graph, action_id :: ActionId)
    node = PathNode.new(graph.n, graph.b, graph.next_step, graph.color_origin, graph.owners , action_id, nothing)
    add_line!(graph)
    graph.next_step += 1
    graph.action_parent_id = action_id
    add_node!(graph, node)
end
