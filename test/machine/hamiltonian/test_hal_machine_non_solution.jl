
function test_create_machine_k_non_solution(n :: Color)
    graf = GrafGenerator.not_hamiltonian_one_node_with_one_edge(n)

    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)

    println("Start execution... k$n ")
    time_execution = @timev HalMachine.execute!(machine)
    println("Time execution  k$n: $time_execution ")
    #=
    graph_join = SolutionGraphReader.get_graph_join_origin(machine)
    Graphviz.to_png(graph_join,"join_graph_non_solution_k$n","./machine/hamiltonian/visual_graphs/non_solution")

    b = Km(n)
    (tour, path) = PathReader.load!(n, b, graph_join, true)
    println(tour)
    =#

    @test SolutionGraphReader.have_solution(machine) == false
end


function test_machine_k_non_solution_step_by_step()
   n = Color(8)
   graf = GrafGenerator.not_hamiltonian_one_node_with_one_edge(n)
   dir = "./machine/hamiltonian/visual_graphs/non_solution_step_by_step"

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calc. step by step...")
   for step_dont_display in 1:7
      HalMachine.make_step!(machine)
   end

   for step in 1:2
      HalMachine.make_step!(machine)
      line = TableTimeline.get_line(machine.timeline, machine.actual_km)
      for (origin, cell) in line
          for action_id in cell.parents
             println("Origin/ActId: $origin / $action_id")
             action = HalMachine.get_action(machine, action_id)

             graph = Actions.get_max_graph(action)
              graph_state = graph.valid

             file_name = "action_$(action_id)_$(graph_state)"
             println("file: $file_name")
             if file_name == "action_63_true"
                PathGraph.review_owners_colors!(graph)
             end

             Graphviz.to_png(graph,file_name,dir)

             #b = Km(n)
             #(tour, path) = PathReader.load!(n, b, graph, true)
             #println(tour)

          end
      end
   end


end


#test_machine_k_non_solution_step_by_step()

for n in 4:10
   test_create_machine_k_non_solution(Color(n))
end
