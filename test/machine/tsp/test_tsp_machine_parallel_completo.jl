function test_tsp_machine_grafo_completo_parallel(n :: Color)
   graf = GrafGenerator.completo(n, Weight(10))

   color_origin = Color(0)
   b_km = Km(n * 20)
   optimal_solution = Km(n * 10)
   machine = TSPMachine.new(graf, b_km, color_origin)

   println("## Calculating TSP Machine grafo completo K$n")
   TSPMachineParallel.execute!(machine)

   println("KM Solution: $(machine.km_solution_recived)")
   @test machine.actual_km == optimal_solution - 1
   @test machine.km_solution_recived == optimal_solution
   cell = TSPMachine.get_cell_origin(machine)
   @test cell != nothing

   test_get_one_solution(n, b_km, machine, optimal_solution)
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

test_tsp_machine_grafo_completo_parallel(Color(8))
