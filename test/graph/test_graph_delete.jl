function test_lazy_delete_nodes()
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


    PathGraph.save_to_delete_node!(graph, node2_id)
    @test graph.valid == false
    PathGraph.save_to_delete_node!(graph, node4_id)

    ## It isnt valid then this wont execute deletions.
    PathGraph.apply_node_deletes!(graph)
    @test isempty(graph.nodes_to_delete) == false

    # Lazy detection unvalid graph before deletions
    @test graph.nodes_to_delete == NodesIdSet([node2_id])

    @test graph.table_lines[Step(0)] == NodesIdSet([node0_id])
    @test graph.table_lines[Step(1)] == NodesIdSet([node2_id])
    @test graph.table_lines[Step(2)] == NodesIdSet([node4_id])
end


function test_lazy_delete_nodes_by_color()
    n = Color(6)
    b = Km(6)
    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    action_id_s2_4 = GeneratorIds.get_action_id(Color(n), Km(2), Color(4))
    action_id_s3_2 = GeneratorIds.get_action_id(Color(n), Km(3), Color(2))
    ## Create graph
    graph = PathGraph.new(n, b, Color(0), action_id_s0_0)
    PathGraph.up!(graph, Color(2), action_id_s1_2)
    PathGraph.up!(graph, Color(4), action_id_s2_4)

    # Make delete by color of action_id_s1_2
    # We wait make the graph unvalid.
    PathGraph.up!(graph, Color(2), action_id_s2_4)
    @test graph.next_step == Step(4)
    @test graph.valid == false
    @test isempty(graph.nodes_to_delete) == false

    ## Testing
    node0_id = NodeIdentity.new(n, b, Step(0), action_id_s0_0)
    node2_id = NodeIdentity.new(n, b, Step(1), action_id_s1_2, action_id_s0_0)
    node4_id = NodeIdentity.new(n, b, Step(2), action_id_s2_4, action_id_s1_2)

    # Lazy detection unvalid graph before deletions
    @test graph.nodes_to_delete == NodesIdSet([node2_id])

    @test graph.table_lines[Step(0)] == NodesIdSet([node0_id])
    @test graph.table_lines[Step(1)] == NodesIdSet([node2_id])
    @test graph.table_lines[Step(2)] == NodesIdSet([node4_id])
end

test_lazy_delete_nodes()
test_lazy_delete_nodes_by_color()
