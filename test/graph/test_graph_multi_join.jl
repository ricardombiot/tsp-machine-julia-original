#=
    0
  2   4    8
  4   2    5
  6   6    6
=#
function build_multi_join()
    # Building graphs and join
    n = Color(10)
    b = Km(10)
    action_id_s0_0 = GeneratorIds.get_action_id(Color(n), Km(0), Color(0))
    action_id_s1_2 = GeneratorIds.get_action_id(Color(n), Km(1), Color(2))
    action_id_s1_4 = GeneratorIds.get_action_id(Color(n), Km(1), Color(4))
    action_id_s1_8 = GeneratorIds.get_action_id(Color(n), Km(1), Color(8))

    action_id_s2_4 = GeneratorIds.get_action_id(Color(n), Km(2), Color(4))
    action_id_s2_2 = GeneratorIds.get_action_id(Color(n), Km(2), Color(2))
    action_id_s2_5 = GeneratorIds.get_action_id(Color(n), Km(2), Color(5))

    action_id_s3_6 = GeneratorIds.get_action_id(Color(n), Km(3), Color(6))
    ## Create graph
    graph = PathGraph.new(n, b, Color(0), action_id_s0_0)

    graph_2 = deepcopy(graph)
    PathGraph.up!(graph_2, Color(2), action_id_s1_2)
    PathGraph.up!(graph_2, Color(4), action_id_s2_4)

    graph_4 = deepcopy(graph)
    PathGraph.up!(graph_4, Color(4), action_id_s1_4)
    PathGraph.up!(graph_4, Color(2), action_id_s2_2)

    graph_8 = deepcopy(graph)
    PathGraph.up!(graph_8, Color(8), action_id_s1_8)
    PathGraph.up!(graph_8, Color(5), action_id_s2_5)

    PathGraph.up!(graph_2, Color(6), action_id_s3_6)
    PathGraph.up!(graph_4, Color(6), action_id_s3_6)
    PathGraph.up!(graph_8, Color(6), action_id_s3_6)


    graph_join = deepcopy(graph_2)
    PathGraph.join!(graph_join, graph_4)
    PathGraph.join!(graph_join, graph_8)

    return graph_join
end


function test_remove_partial()
    n = Color(10)
    b = Km(10)
    action_id_s4_2 = GeneratorIds.get_action_id(Color(n), Km(4), Color(2))
    graph_join = build_multi_join()
    PathGraph.up!(graph_join, Color(2), action_id_s4_2)
    @test graph_join.valid == true
end

test_remove_partial()
