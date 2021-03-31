
function test_dode_calc()
   graf = GrafGenerator.dodecaedro()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calc. Dode...")
   HalMachine.execute!(machine)

   #println("## Plot join solution.. ")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)
   #Graphviz.to_png(graph_join,"graph_join_solutions","./machine/hamiltonian/visual_graphs/grafo_dode")

   println("## Search all solutions.. ")
   dir = "./machine/hamiltonian/visual_graphs/exp_dode"
   limit = UInt128(10)
   b = Km(graf.n)
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, dir)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total")
   #=b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(20)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)=#

end


test_dode_calc()
