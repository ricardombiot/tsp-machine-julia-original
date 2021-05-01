function create_grafo()
   n = Color(4)
   g = Graf.new(n)

   Graf.add!(g, Color(0), Color(1), Weight(1))
   Graf.add!(g, Color(1), Color(2), Weight(1))
   Graf.add!(g, Color(2), Color(3), Weight(1))
   Graf.add!(g, Color(3), Color(0), Weight(1))

   Graf.add!(g, Color(0), Color(3), Weight(10))
   Graf.add!(g, Color(3), Color(2), Weight(10))
   Graf.add!(g, Color(2), Color(1), Weight(10))
   Graf.add!(g, Color(1), Color(0), Weight(10))

   return g
end

function test_join_graph_solution_grafo_dir_example()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   limit = UInt128(2)
   b = Km(graf.n)
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, "")
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   optimal = Weight(graf.n)
   @test PathChecker.check_all!(graf, reader_exp.paths_solution, optimal)
   println("All solutions was checked: [OK]")
end

test_join_graph_solution_grafo_dir_example()
