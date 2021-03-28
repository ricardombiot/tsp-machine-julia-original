#=
    0
  2   4
  4   2
  6   6
=#
function build_join()
    # Building graphs and join
    n = Color(10)
    b = Km(10)
    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    action_id_s1_4 = GeneratorIds.get_action_id(Color(n), Km(1), Color(4))
    action_id_s2_4 = GeneratorIds.get_action_id(Color(n), Km(2), Color(4))
    action_id_s2_2 = GeneratorIds.get_action_id(Color(n), Km(2), Color(2))
    action_id_s3_6 = GeneratorIds.get_action_id(Color(n), Km(3), Color(6))
    ## Create graph
    graph = PathGraph.new(n, b, Color(0), action_id_s0_0)

    graph_2 = deepcopy(graph)
    PathGraph.up!(graph_2, Color(2), action_id_s1_2)
    PathGraph.up!(graph_2, Color(4), action_id_s2_4)

    graph_4 = deepcopy(graph)
    PathGraph.up!(graph_4, Color(4), action_id_s1_4)
    PathGraph.up!(graph_4, Color(2), action_id_s2_2)

    #No se puede fusionar porque no tienen el mismo action_parent_id
    @test PathGraph.join!(graph_2, graph_4) == false

    PathGraph.up!(graph_2, Color(6), action_id_s3_6)
    PathGraph.up!(graph_4, Color(6), action_id_s3_6)
    # Apply join!
    @test PathGraph.join!(graph_2, graph_4) == true
    graph_join = graph_2

    return graph_join
end

function test_join()
    n = Color(10)
    b = Km(10)

    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    action_id_s1_4 = GeneratorIds.get_action_id(Color(n), Km(1), Color(4))
    action_id_s2_4 = GeneratorIds.get_action_id(Color(n), Km(2), Color(4))
    action_id_s2_2 = GeneratorIds.get_action_id(Color(n), Km(2), Color(2))
    action_id_s3_6 = GeneratorIds.get_action_id(Color(n), Km(3), Color(6))

    node00_id = NodeIdentity.new(n, b, action_id_s0_0)
    node12_id = NodeIdentity.new(n, b, action_id_s1_2, action_id_s0_0)
    node14_id = NodeIdentity.new(n, b, action_id_s1_4, action_id_s0_0)

    node24_id = NodeIdentity.new(n, b, action_id_s2_4, action_id_s1_2)
    node22_id = NodeIdentity.new(n, b, action_id_s2_2, action_id_s1_4)

    node36_22_id = NodeIdentity.new(n, b, action_id_s3_6, action_id_s2_2)
    node36_24_id = NodeIdentity.new(n, b, action_id_s3_6, action_id_s2_4)

    ## Join
    graph_join = build_join()

    ## Edges

    edge_00_12 = PathGraph.get_edge(graph_join, node00_id, node12_id)
    @test edge_00_12.id.origin_id == node00_id
    @test edge_00_12.id.destine_id == node12_id

    edge_00_14 = PathGraph.get_edge(graph_join, node00_id, node14_id)
    @test edge_00_14.id.origin_id == node00_id
    @test edge_00_14.id.destine_id == node14_id

    edge_12_24 = PathGraph.get_edge(graph_join, node12_id, node24_id)
    @test edge_12_24.id.origin_id == node12_id
    @test edge_12_24.id.destine_id == node24_id

    edge_14_22 = PathGraph.get_edge(graph_join, node14_id, node22_id)
    @test edge_14_22.id.origin_id == node14_id
    @test edge_14_22.id.destine_id == node22_id

    edge_22_36 = PathGraph.get_edge(graph_join, node22_id, node36_22_id)
    @test edge_22_36.id.origin_id == node22_id
    @test edge_22_36.id.destine_id == node36_22_id

    edge_24_36 = PathGraph.get_edge(graph_join, node24_id, node36_24_id)
    @test edge_24_36.id.origin_id == node24_id
    @test edge_24_36.id.destine_id == node36_24_id

    # testing nodes

    @test PathGraph.get_nodes_by_color(graph_join, Color(0)) == NodesIdSet([node00_id])
    @test PathGraph.get_nodes_by_color(graph_join, Color(2)) == NodesIdSet([node12_id, node22_id])
    @test PathGraph.get_nodes_by_color(graph_join, Color(4)) == NodesIdSet([node14_id, node24_id])
    @test PathGraph.get_nodes_by_color(graph_join, Color(6)) == NodesIdSet([node36_22_id, node36_24_id])


    node00 = PathGraph.get_node(graph_join, node00_id)
    @test PathNode.have_parents(node00) == false
    @test PathNode.have_sons(node00) == true
    @test haskey(node00.sons, node12_id) == true
    @test node00.sons[node12_id] == edge_00_12.id
    @test haskey(node00.sons, node14_id) == true
    @test node00.sons[node14_id] == edge_00_14.id

    node12 = PathGraph.get_node(graph_join, node12_id)
    @test PathNode.have_parents(node12) == true
    @test haskey(node12.parents, node00_id) == true
    @test node12.parents[node00_id] == edge_00_12.id
    @test PathNode.have_sons(node12) == true
    @test haskey(node12.sons, node24_id) == true
    @test node12.sons[node24_id] == edge_12_24.id

    node14 = PathGraph.get_node(graph_join, node14_id)
    @test PathNode.have_parents(node14) == true
    @test haskey(node14.parents, node00_id) == true
    @test node14.parents[node00_id] == edge_00_14.id
    @test PathNode.have_sons(node14) == true
    @test haskey(node14.sons, node22_id) == true
    @test node14.sons[node22_id] == edge_14_22.id

    node24 = PathGraph.get_node(graph_join, node24_id)
    @test PathNode.have_parents(node24) == true
    @test haskey(node24.parents, node12_id) == true
    @test node24.parents[node12_id] == edge_12_24.id
    @test PathNode.have_sons(node24) == true
    @test haskey(node24.sons, node36_24_id) == true
    @test node24.sons[node36_24_id] == edge_24_36.id

    node22 = PathGraph.get_node(graph_join, node22_id)
    @test PathNode.have_parents(node22) == true
    @test haskey(node22.parents, node14_id) == true
    @test node22.parents[node14_id] == edge_14_22.id
    @test PathNode.have_sons(node22) == true
    @test haskey(node22.sons, node36_22_id) == true
    @test node22.sons[node36_22_id] == edge_22_36.id

    node36_22 = PathGraph.get_node(graph_join, node36_22_id)
    @test PathNode.have_parents(node36_22) == true
    @test haskey(node36_22.parents, node22_id) == true
    @test node36_22.parents[node22_id] == edge_22_36.id
    @test PathNode.have_sons(node36_22) == false

    node36_24 = PathGraph.get_node(graph_join, node36_24_id)
    @test PathNode.have_parents(node36_24) == true
    @test haskey(node36_24.parents, node24_id) == true
    @test node36_24.parents[node24_id] == edge_24_36.id
    @test PathNode.have_sons(node36_24) == false

    #= Check Owners =#

    # node00_id
    @test Owners.have(graph_join.owners, Step(0), node00_id)
    list_all_nodes = [node00, node12, node14, node24, node22, node36_22, node36_24]
    for node in list_all_nodes
        PathNode.have_owner(node, Step(0), node00_id)
    end

    list_all_edges = [edge_00_12, edge_00_14, edge_12_24, edge_14_22, edge_22_36, edge_24_36]
    for edge in list_all_edges
        PathEdge.have_owner(edge, Step(0), node00_id)
    end

    # node12_id
    @test Owners.have(graph_join.owners, Step(1), node12_id)
    list_nodes = [node00, node12, node24, node36_24]
    for node in list_nodes
        PathNode.have_owner(node, Step(1), node12_id)
    end

    list_edges = [edge_00_12, edge_12_24, edge_24_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(1), node12_id)
    end

    # node24_id
    @test Owners.have(graph_join.owners, Step(2), node24_id)
    list_nodes = [node00, node12, node24, node36_24]
    for node in list_nodes
        PathNode.have_owner(node, Step(2), node24_id)
    end

    list_edges = [edge_00_12, edge_12_24, edge_24_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(2), node24_id)
    end

    # node24_id
    @test Owners.have(graph_join.owners, Step(3), node36_24_id)
    list_nodes = [node00, node12, node24, node36_24]
    for node in list_nodes
        PathNode.have_owner(node, Step(3), node36_24_id)
    end

    list_edges = [edge_00_12, edge_12_24, edge_24_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(3), node36_24_id)
    end


    # node14_id
    @test Owners.have(graph_join.owners, Step(1), node14_id)
    list_nodes = [node00, node14, node22, node36_22]
    for node in list_nodes
        PathNode.have_owner(node, Step(1), node14_id)
    end

    list_edges = [edge_00_12, edge_14_22, edge_22_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(1), node14_id)
    end

    # node22_id
    @test Owners.have(graph_join.owners, Step(2), node22_id)
    list_nodes = [node00, node14, node22, node36_22]
    for node in list_nodes
        PathNode.have_owner(node, Step(2), node22_id)
    end

    list_edges = [edge_00_12, edge_14_22, edge_22_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(2), node22_id)
    end

    # node36_22_id
    @test Owners.have(graph_join.owners, Step(3), node36_22_id)
    list_nodes = [node00, node14, node22, node36_22]
    for node in list_nodes
        PathNode.have_owner(node, Step(3), node36_22_id)
    end

    list_edges = [edge_00_12, edge_14_22, edge_22_36]
    for edge in list_edges
        PathEdge.have_owner(edge, Step(3), node36_22_id)
    end

end

test_join()
