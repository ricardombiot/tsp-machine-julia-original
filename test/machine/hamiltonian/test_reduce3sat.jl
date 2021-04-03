function create_grafo_reduce3sat()
   # (x1 + x2 + !x3) * (!x2 + x3 + x4) * (x1 + !x2 + x4)
   # Example: https://opendsa-server.cs.vt.edu/ODSA/Books/Everything/html/threeSAT_to_hamiltonianCycle.html
   n = Color(29)
   g = Graf.new(n)

   Graf.add!(g, Color(0), Color(1))
   Graf.add!(g, Color(0), Color(6))

   Graf.add!(g, Color(1), Color(2))
   Graf.add!(g, Color(1), Color(7))
   Graf.add!(g, Color(1), Color(12))
   Graf.add!(g, Color(1), Color(26))

   Graf.add!(g, Color(2), Color(1))
   Graf.add!(g, Color(2), Color(3))

   Graf.add!(g, Color(3), Color(2))
   Graf.add!(g, Color(3), Color(4))

   Graf.add!(g, Color(4), Color(3))
   Graf.add!(g, Color(4), Color(5))

   Graf.add!(g, Color(5), Color(4))
   Graf.add!(g, Color(5), Color(6))
   Graf.add!(g, Color(5), Color(28))

   Graf.add!(g, Color(6), Color(5))
   Graf.add!(g, Color(6), Color(12))
   Graf.add!(g, Color(6), Color(7))

   Graf.add!(g, Color(7), Color(8))
   Graf.add!(g, Color(7), Color(13))
   Graf.add!(g, Color(7), Color(18))
   Graf.add!(g, Color(7), Color(26))

   Graf.add!(g, Color(8), Color(7))
   Graf.add!(g, Color(8), Color(9))

   Graf.add!(g, Color(9), Color(8))
   Graf.add!(g, Color(9), Color(10))

   Graf.add!(g, Color(10), Color(9))
   Graf.add!(g, Color(10), Color(11))
   Graf.add!(g, Color(10), Color(27))

   Graf.add!(g, Color(11), Color(10))
   Graf.add!(g, Color(11), Color(12))

   Graf.add!(g, Color(12), Color(11))
   Graf.add!(g, Color(12), Color(13))
   Graf.add!(g, Color(12), Color(18))
   Graf.add!(g, Color(12), Color(28))

   Graf.add!(g, Color(13), Color(14))
   Graf.add!(g, Color(13), Color(19))
   Graf.add!(g, Color(13), Color(24))

   Graf.add!(g, Color(14), Color(13))
   Graf.add!(g, Color(14), Color(15))
   Graf.add!(g, Color(14), Color(26))

   Graf.add!(g, Color(15), Color(14))
   Graf.add!(g, Color(15), Color(16))
   Graf.add!(g, Color(15), Color(27))

   Graf.add!(g, Color(16), Color(15))
   Graf.add!(g, Color(16), Color(17))

   Graf.add!(g, Color(17), Color(16))
   Graf.add!(g, Color(17), Color(18))

   Graf.add!(g, Color(18), Color(17))
   Graf.add!(g, Color(18), Color(19))
   Graf.add!(g, Color(18), Color(24))

   Graf.add!(g, Color(19), Color(20))
   Graf.add!(g, Color(19), Color(25))

   Graf.add!(g, Color(20), Color(19))
   Graf.add!(g, Color(20), Color(21))

   Graf.add!(g, Color(21), Color(20))
   Graf.add!(g, Color(21), Color(22))
   Graf.add!(g, Color(21), Color(27))

   Graf.add!(g, Color(22), Color(21))
   Graf.add!(g, Color(22), Color(23))

   Graf.add!(g, Color(23), Color(22))
   Graf.add!(g, Color(23), Color(24))
   Graf.add!(g, Color(23), Color(28))

   Graf.add!(g, Color(24), Color(23))
   Graf.add!(g, Color(24), Color(25))

   Graf.add!(g, Color(25), Color(0))

   Graf.add!(g, Color(26), Color(2))
   Graf.add!(g, Color(26), Color(8))
   Graf.add!(g, Color(26), Color(13))

   Graf.add!(g, Color(27), Color(9))
   Graf.add!(g, Color(27), Color(16))
   Graf.add!(g, Color(27), Color(22))

   Graf.add!(g, Color(28), Color(6))
   Graf.add!(g, Color(28), Color(11))
   Graf.add!(g, Color(28), Color(24))

   return g
end

function test_hal_grafo_reduce3sat()
   graf = create_grafo_reduce3sat()
   dir = "./machine/hamiltonian/visual_graphs/grafo_reduce3sat/fails"

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calculating Graph Reduce3sat")
   HalMachine.execute!(machine)
   #=
   println("## Graph parent")
   graph = SolutionGraphReader.get_one_solution_graph(machine)
   graph_join = graph
   Graphviz.to_png(graph_join,"graph_parent","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")
   =#

   println("## Building join")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)
   println("## Plot join")
   Graphviz.to_png(graph_join,"graph_join","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")

   graph_join.required_review_ownwers = true
   PathGraph.review_owners_all_graph!(graph_join)
   println("## Plot join: after review")
   Graphviz.to_png(graph_join,"graph_join_review","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")


   limit = UInt128(5)
   b = Km(graf.n)
   println("## Searching paths")
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, dir)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)



   #println(graph)
   #println("## Building join")
   #graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   #println("## Plot join")
   #Graphviz.to_png(graph_join,"graph_join","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")

   #=
   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)



   limit = UInt128(10)
   b = Km(graf.n)
   println("## Searching paths")
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, dir)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   println("## Cheking paths")
   optimal = Weight(graf.n)
   @test PathChecker.check_all!(graf, reader_exp.paths_solution, optimal)
   =#   #==#
end



test_hal_grafo_reduce3sat()
