
function test_dode_calc()
   graf = GrafGenerator.dodecaedro()
   time = now()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)


   println("## Calc. Dode...")
   HalMachine.execute!(machine)

   #println("## Plot join solution.. ")
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)
   Graphviz.to_png(graph_join,"graph_join_solutions","./machine/hamiltonian/visual_graphs/grafo_dode")

   println("## Search all solutions.. ")
   dir = "./machine/hamiltonian/visual_graphs/exp_dode"
   limit = UInt128(100)
   b = Km(graf.n)
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, dir)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions founded: $total")
   #println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")

   optimal = Weight(20)
   @test PathChecker.check_all!(graf, reader_exp.paths_solution, optimal)
   println("All solutions was checked: [OK]")

   time_execute = now() - time
   str_time_test = Dates.canonicalize(Dates.CompoundPeriod(time_execute))
   println("TIME EXECUTION: $str_time_test")
end

test_dode_calc()
