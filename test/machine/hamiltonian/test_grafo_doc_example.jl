function create_grafo()
   n = Color(4)
   g = Graf.new(n)

   Graf.add_bidirectional!(g, Color(0), Color(1))
   Graf.add_bidirectional!(g, Color(0), Color(3))

   Graf.add_bidirectional!(g, Color(1), Color(3))
   Graf.add_bidirectional!(g, Color(1), Color(2))

   Graf.add_bidirectional!(g, Color(2), Color(3))

   return g
end

function test_join_graph_solution_grafo_doc_example()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)


   Graphviz.to_png(graph_join,"join_solution","./machine/hamiltonian/visual_graphs/grafo_doc")

   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
end

test_join_graph_solution_grafo_doc_example()
