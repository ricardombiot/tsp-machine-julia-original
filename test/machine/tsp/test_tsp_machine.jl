function create_grafo()
   n = Color(5)
   g = Graf.new(n)
   Graf.add_bidirectional!(g, Color(0), Color(1), Weight(17))
   Graf.add_bidirectional!(g, Color(0), Color(2), Weight(18))
   Graf.add_bidirectional!(g, Color(0), Color(3), Weight(20))
   Graf.add_bidirectional!(g, Color(0), Color(4), Weight(30))

   Graf.add_bidirectional!(g, Color(1), Color(2), Weight(5))
   Graf.add_bidirectional!(g, Color(1), Color(3), Weight(11))
   Graf.add_bidirectional!(g, Color(1), Color(4), Weight(16))

   Graf.add_bidirectional!(g, Color(2), Color(3), Weight(9))
   Graf.add_bidirectional!(g, Color(2), Color(4), Weight(17))

   Graf.add_bidirectional!(g, Color(3), Color(4), Weight(11))

   return g
end

function test_tsp_machine()
   graf = create_grafo()

   color_origin = Color(0)
   b_km = Km(100)
   machine = TSPMachine.new(graf, b_km, color_origin)

   println("## Calculating TSP Machine")
   TSPMachine.execute!(machine)
   println("KM Solution: $(machine.km_solution_recived)")
   @test machine.actual_km == Km(70) - 1
   @test machine.km_solution_recived == Km(70)
   cell = TSPMachine.get_cell_origin(machine)
   @test cell != nothing

   test_get_one_solution(graf.n, b_km, machine)
   test_explore_solutions(graf.n, b_km, machine)
end

function test_get_one_solution(n , b, machine)
   graph_solution = SolutionGraphReader.get_one_solution_graph(machine)

   println("# Show one solution")
   (tour, path) = PathReader.load!(n, b, graph_solution)
   println(tour)
   @test path.step == n+1

   optimal_solution = Weight(70)
   checker = PathChecker.new(machine.graf, path, optimal_solution)
   @test PathChecker.check!(checker)
   println("# Checked the solution [OK]")
end

function test_explore_solutions(n , b, machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   println("## Search all solutions.. ")
   limit = UInt128(100)
   reader_exp = PathExpReader.new(n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")

   optimal = Weight(70)
   @test PathChecker.check_all!(machine.graf, reader_exp.paths_solution, optimal)
   println("# Checked all $total solutions [OK]")
end


test_tsp_machine()
