function test_init_graph()
    n = Color(10)
    b = Km(20)
    node_id = NodeIdentity.new(n, b, Step(0), ActionId(1), nothing)

    ## Create graph
    graph = PathGraph.new(n, b, Color(0), ActionId(1))

    ## testing
    @test graph.next_step == Step(1)
    @test graph.table_color_nodes[Color(0)] == NodesIdSet([node_id])
    @test graph.table_lines[Step(0)] == NodesIdSet([node_id])


    node0 = graph.table_nodes[ActionId(1)][node_id]
    @test node0.id == node_id
    @test node0.id.action_id == ActionId(1)
    @test node0.id.action_parent_id == ActionId(1)
    @test node0.color == Color(0)
    @test node0.step == Step(0)
    @test isempty(node0.parents)
    @test isempty(node0.sons)

    @test PathNode.have_owner(node0, Step(0), node_id)
    @test Owners.have(graph.owners, Step(0), node_id)
end

function test_up_graph()
    n = Color(10)
    b = Km(20)
    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    ## Create graph
    graph = PathGraph.new(n, b, Color(0), action_id_s0_0)

    PathGraph.make_up!(graph, Color(2), action_id_s1_2)
    @test graph.next_step == Step(2)

    ## Testing
    node0_id = NodeIdentity.new(n, b, Step(0), action_id_s0_0)
    node2_id = NodeIdentity.new(n, b, Step(1), action_id_s1_2, action_id_s0_0)

    @test graph.table_color_nodes[Color(0)] == NodesIdSet([node0_id])
    @test graph.table_lines[Step(0)] == NodesIdSet([node0_id])

    @test graph.table_color_nodes[Color(2)] == NodesIdSet([node2_id])
    @test graph.table_lines[Step(1)] == NodesIdSet([node2_id])

    origin_id = node0_id
    destine_id = node2_id

    id_edge = EdgeIdentity.new(origin_id, destine_id)

    edge = graph.table_edges[id_edge]
    @test edge.id.origin_id == origin_id
    @test edge.id.destine_id == destine_id

    edge = PathGraph.get_edge(graph, node0_id, node2_id)
    @test edge.id.origin_id == origin_id
    @test edge.id.destine_id == destine_id

    ## Check parents & Sons

    node0 = PathGraph.get_node(graph, node0_id)
    @test PathNode.have_parents(node0) == false
    @test PathNode.have_sons(node0) == true
    @test haskey(node0.sons, node2_id) == true
    @test node0.sons[node2_id] == id_edge

    node2 = PathGraph.get_node(graph, node2_id)
    @test PathNode.have_parents(node2) == true
    @test haskey(node2.parents, node0_id) == true
    @test node2.parents[node0_id] == id_edge
    @test PathNode.have_sons(node2) == false

    ## Check owners

    @test Owners.have(graph.owners, Step(0), node0_id)
    @test PathNode.have_owner(node0, Step(0), node0_id)
    @test PathNode.have_owner(node2, Step(0), node0_id)
    #@test PathEdge.have_owner(edge, Step(0), node0_id)

    @test Owners.have(graph.owners, Step(1), node2_id)
    @test PathNode.have_owner(node0, Step(1), node2_id)
    @test PathNode.have_owner(node2, Step(1), node2_id)
    #@test PathEdge.have_owner(edge, Step(1), node2_id)

end


function test_second_up()
    n = Color(6)
    b = Km(6)
    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    action_id_s2_4 = GeneratorIds.get_action_id(Color(n), Km(2), Color(4))
    ## Create graph
    graph = PathGraph.new(n, b, Color(0), action_id_s0_0)
    PathGraph.make_up!(graph, Color(2), action_id_s1_2)
    PathGraph.make_up!(graph, Color(4), action_id_s2_4)
    @test graph.next_step == Step(3)

    ## Testing
    node0_id = NodeIdentity.new(n, b, Step(0), action_id_s0_0)
    node2_id = NodeIdentity.new(n, b, Step(1), action_id_s1_2, action_id_s0_0)
    node4_id = NodeIdentity.new(n, b, Step(2), action_id_s2_4, action_id_s1_2)

    ## Edges

    edge_02 = PathGraph.get_edge(graph, node0_id, node2_id)
    @test edge_02.id.origin_id == node0_id
    @test edge_02.id.destine_id == node2_id

    edge_24 = PathGraph.get_edge(graph, node2_id, node4_id)
    @test edge_24.id.origin_id == node2_id
    @test edge_24.id.destine_id == node4_id

    ## Nodes

    node0 = PathGraph.get_node(graph, node0_id)
    @test PathNode.have_parents(node0) == false
    @test PathNode.have_sons(node0) == true
    @test haskey(node0.sons, node2_id) == true
    @test node0.sons[node2_id] == edge_02.id

    node2 = PathGraph.get_node(graph, node2_id)
    @test PathNode.have_parents(node2) == true
    @test haskey(node2.parents, node0_id) == true
    @test node2.parents[node0_id] == edge_02.id
    @test PathNode.have_sons(node2) == true
    @test haskey(node2.sons, node4_id) == true
    @test node2.sons[node4_id] == edge_24.id

    node4 = PathGraph.get_node(graph, node4_id)
    @test PathNode.have_parents(node4) == true
    @test haskey(node4.parents, node2_id) == true
    @test node4.parents[node2_id] == edge_24.id
    @test PathNode.have_sons(node4) == false


    ## Check Owners

    @test Owners.have(graph.owners, Step(0), node0_id)
    @test PathNode.have_owner(node0, Step(0), node0_id)
    @test PathNode.have_owner(node2, Step(0), node0_id)
    @test PathNode.have_owner(node4, Step(0), node0_id)
    #@test PathEdge.have_owner(edge_02, Step(0), node0_id)
    #@test PathEdge.have_owner(edge_24, Step(0), node0_id)

    @test Owners.have(graph.owners, Step(1), node2_id)
    @test PathNode.have_owner(node0, Step(1), node2_id)
    @test PathNode.have_owner(node2, Step(1), node2_id)
    @test PathNode.have_owner(node4, Step(1), node2_id)
    #@test PathEdge.have_owner(edge_02, Step(1), node2_id)
    #@test PathEdge.have_owner(edge_24, Step(1), node2_id)

    @test Owners.have(graph.owners, Step(2), node4_id)
    @test PathNode.have_owner(node0, Step(2), node4_id)
    @test PathNode.have_owner(node2, Step(2), node4_id)
    @test PathNode.have_owner(node4, Step(2), node4_id)
    #@test PathEdge.have_owner(edge_02, Step(2), node4_id)
    #@test PathEdge.have_owner(edge_24, Step(2), node4_id)

end


test_init_graph()
test_up_graph()
test_second_up()
