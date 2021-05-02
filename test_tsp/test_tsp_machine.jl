using Distributed

include("./../src/main.jl")


using Test
using Dates

function test_tsp_machine_grafo_completo(n :: Color)

   start_time = now()
   time = now()
   println("## Start execution: $time")
   graf = GrafGenerator.completo(n, Weight(10))

   color_origin = Color(0)
   b_km = Km(n * 20)
   optimal_solution = Km(n * 10)
   machine = TSPMachine.new(graf, b_km, color_origin)

   time = now()
   println("## Machine execution: $time")
   println("## Calculating TSP Machine grafo completo K$n")
   TSPMachineParallel.execute!(machine)

   time_execute = now() - time
   println("## Execution Duration: $time_execute")

   time = now()
   println("## Machine end calc: $time")
   println("KM Solution: $(machine.km_solution_recived)")
   @test machine.actual_km == optimal_solution - 1
   @test machine.km_solution_recived == optimal_solution
   cell = TSPMachine.get_cell_origin(machine)
   @test cell != nothing


   test_explore_solutions(n, b_km, machine, optimal_solution)

   end_time = now()
   time = end_time - start_time
   println("## Duration: $time")
end

function test_explore_solutions(n , b, machine, optimal_solution)
   time = now()
   println("## Creating compact graph: $time")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   time = now()
   println("## Exploration solutions: $time")
   println("# Start Exploring")
   limit = UInt128(50)
   reader_exp = PathExpReader.new(n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")

   time = now()
   println("## Start checking Test: $time")

   @test PathChecker.check_all!(machine.graf, reader_exp.paths_solution, optimal_solution)
   println("# Checked all $total solutions [OK]")

   time = now()
   println("## End Test: $time")
end



test_tsp_machine_grafo_completo(Color(9))
