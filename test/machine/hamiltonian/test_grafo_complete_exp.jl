
function test_grafo_complete_calc(n)
   graf = GrafGenerator.completo(Color(n))

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)


   println("## Calc. K$n...")
   HalMachine.execute!(machine)

   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   println("## Exploring...")
   limit = UInt128(100)
   b = Km(graf.n)
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true, "")
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions founded: $total")
end

test_grafo_complete_calc(9)
