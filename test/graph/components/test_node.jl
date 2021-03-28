function test_node()
    n = Color(10)
    b = Km(20)
    bbnn = UniqueNodeKey(b^2*n^2)
    owners_graph = Owners.new(bbnn)
    node0 = PathNode.new(n, b, Step(0), Color(0), owners_graph, ActionId(1))

    @test node0.id.action_id == ActionId(1)
    @test node0.id.action_parent_id == ActionId(1)
    @test node0.color == Color(0)
    @test node0.step == Step(0)
    @test isempty(node0.parents)
    @test isempty(node0.sons)

    @test PathNode.is_root(node0)
end

function test_node_parents_and_sons()
    n = Color(10)
    b = Km(20)
    bbnn = UniqueNodeKey(b^2*n^2)
    owners_graph = Owners.new(bbnn)

    action_id_node0 = GeneratorIds.get_action_id(n, Km(0), Color(0))
    node0 = PathNode.new(n, b, Step(0), Color(0), owners_graph, action_id_node0)

    @test node0.id.action_id == ActionId(1)
    @test node0.id.action_parent_id == ActionId(1)
    @test node0.color == Color(0)
    @test node0.step == Step(0)
    @test isempty(node0.parents)
    @test isempty(node0.sons)

    action_id_node1 = GeneratorIds.get_action_id(n, Km(1), Color(1))
    node1 = PathNode.new(n, b, Step(1), Color(1), owners_graph, action_id_node1, action_id_node0)

    @test node1.id.action_id == action_id_node1
    @test node1.id.action_parent_id == action_id_node0
    @test node1.color == Color(1)
    @test node1.step == Step(1)
    @test isempty(node1.parents)
    @test isempty(node1.sons)


    origin = node0.id
    destine = node1.id
    edge_id = EdgeIdentity.new(origin, destine)

    PathNode.add_parent!(node1, node0)
    @test PathNode.have_parents(node1) == true
    @test PathNode.have_sons(node1) == false
    @test node1.parents[origin] == edge_id

    PathNode.add_son!(node0, node1)
    @test PathNode.have_parents(node0) == false
    @test PathNode.have_sons(node0) == true
    @test node0.sons[destine] == edge_id
end

test_node()
test_node_parents_and_sons()
