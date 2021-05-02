
function test_dode_calc_and_plot()
   graf = GrafGenerator.dodecaedro()
   time = now()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)


   println("## Calc. Dode...")
   HalMachine.execute!(machine)

   #println("## Plot join solution.. ")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   directory = "./machine/hamiltonian/visual_graphs/grafo_dode_reading"
   Graphviz.to_png(graph_join,"graph_join_solutions", directory)

   println("## Search solution and plot.. ")
   b = Km(graf.n)
   (tour, path) = PathReader.load_and_plot!(graf.n, b, graph_join, directory, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(20)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)

   time_execute = now() - time
   str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_execute))
   println("TIME EXECUTION: $str_time_test")
end

test_dode_calc_and_plot()
