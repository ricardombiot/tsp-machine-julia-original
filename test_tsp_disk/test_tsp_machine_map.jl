include("./../src/main.jl")
using Test
using Dates

function generic_execution(map :: String)
   directory_data = "./data/disk_$map"
   color_origin = Color(0)
   graf = GrafGenerator.read_tsplib_file(map)

   println("## End Reading tsplib execution: $time")
   b_km = Km(graf.n * graf.max_weight)
   machine = TSPMachineDisk.new(graf, b_km, color_origin, directory_data)
   TSPMachineDisk.activate_parallel!(machine)
   TSPMachineDisk.execute!(machine)

   return (graf.n, b_km, machine)
end

function generic_explore_solutions(n , b, machine)
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

function test_tsp_machine_disk_map(map)
   start_time = now()
   println("## Start execution: $start_time")

   (n, b_km, machine) = generic_execution(map)

   cell = TSPMachineDisk.get_cell_origin(machine)
   if cell != nothing
      println("Instance have solution...")
      generic_explore_solutions(n, b_km, machine)
   else
      println("Instance have NOT solution...")
   end

   time_execute = now() - start_time
   str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_execute))
   println("TIME EXECUTION: $str_time_test")
end


function main(args)
   map = first(args)
   test_tsp_machine_disk_map(map)
end



main(ARGS)
