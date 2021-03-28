function test_init_graph()
    n = Color(10)
    b = Km(20)
    node_id = NodeIdentity.new(n, b, ActionId(1), nothing)

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
    #==#
end


test_init_graph()
