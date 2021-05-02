include("./../src/main.jl")
using Test
using Dates

function test_tsp_machine_djibouti()
   time = now()
   println("## Start execution: $time")

   graf = GrafGenerator.read_tsplib_file("dj38")

   time = now()
   println("## End Reading tsplib execution: $time")
   color_origin = Color(0)
   b_km = Km(graf.n * graf.max_weight)

   machine = TSPMachine.new(graf, b_km, color_origin)

   time = now()
   println("## Machine execution: $time")
   println("## Calculating TSP Machine")
   TSPMachineParallel.execute!(machine)

   time = now()
   println("## Machine end calc: $time")
   test_explore_solutions(n, b_km, machine)

   end_time = now()
   time = end_time - start_time
   println("## Duration: $time")
end

function test_explore_solutions(n , b, machine)
   time = now()
   println("## Creating compact graph: $time")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   time = now()
   println("## Exploration solutions: $time")
   println("# Start Exploring")
   limit = UInt128(10)
   reader_exp = PathExpReader.new(n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")

   time = now()
   println("## End Test: $time")
end

test_tsp_machine_djibouti()
