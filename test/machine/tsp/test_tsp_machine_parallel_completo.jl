function test_tsp_machine_grafo_completo(n :: Color)
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

   test_show_one_solution(machine, optimal_solution)
end

function test_show_one_solution(machine, optimal_solution)
   graph_solution = TSPSolver.get_one_solution_graph(machine)

   println("# Show one solution")
   path = PathSolverOwner.new(graph_solution)
   PathSolverOwner.calc!(path)
   txt_path = PathSolverOwner.print_path(path)
   println(txt_path)

   checker = PathChecker.new(machine.graf, path, optimal_solution)
   @test PathChecker.check!(checker)
end

test_tsp_machine_grafo_completo(Color(8))
