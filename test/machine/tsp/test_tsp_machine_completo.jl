function test_tsp_machine_grafo_completo(n :: Color)
   graf = GrafGenerator.completo(n, Weight(10))
   time = now()
   color_origin = Color(0)
   b_km = Km(n * 20)
   optimal_solution = Km(n * 10)
   machine = TSPMachine.new(graf, b_km, color_origin)

   println("## Calculating TSP Machine grafo completo K$n")
   TSPMachine.execute!(machine)

   println("KM Solution: $(machine.km_solution_recived)")
   @test machine.actual_km == optimal_solution - 1
   @test machine.km_solution_recived == optimal_solution
   cell = TSPMachine.get_cell_origin(machine)
   @test cell != nothing

   #test_get_one_solution(n, b_km, machine, optimal_solution)
   test_explore_solutions(n ,b_km, machine, optimal_solution)

   time_execute = now() - time
   str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_execute))
   println("TIME EXECUTION: $str_time_test")
end

function test_get_one_solution(n , b, machine, optimal_solution)
   graph_solution = SolutionGraphReader.get_one_solution_graph(machine)

   println("# Show one solution")
   (tour, path) = PathReader.load!(n, b, graph_solution)
   println(tour)
   @test path.step == n+1

   checker = PathChecker.new(machine.graf, path, optimal_solution)
   result_check = PathChecker.check!(checker)
   @test result_check
   println("# Checked the solution [$result_check]")
end

function test_explore_solutions(n , b, machine, optimal_solution)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   total_expected = factorial(n-1)
   println("## Search all $total_expected solutions...")
   limit = UInt128(total_expected)
   reader_exp = PathExpReader.new(n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")

   @test PathChecker.check_all!(machine.graf, reader_exp.paths_solution, optimal_solution)
   println("# Checked all $total solutions [OK]")

   @test total == total_expected
   println("# Checked all $total = ($n-1)!  ; $total = $total_expected")
end


test_tsp_machine_grafo_completo(Color(5))
