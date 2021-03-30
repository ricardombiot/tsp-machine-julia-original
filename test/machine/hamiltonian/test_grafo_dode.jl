
function test_dode_calc()
   graf = GrafGenerator.dodecaedro()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calc. Dode...")
   HalMachine.execute!(machine)

   println("## Plot alguna solution.. ")
   graph = SolutionGraphReader.get_one_solution_graph(machine)
   Graphviz.to_png(graph,"sol_alguna_owners","./machine/hamiltonian/visual_graphs/grafo_dode")

   println("## Search solution.. ")
   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(20)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
end

test_dode_calc()
