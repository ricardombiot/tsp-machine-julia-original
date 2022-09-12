function create_grafo_canary_islands()
   n = Color(13)
   g = Graf.new(n)
   Graf.add_bidirectional!(g, Color(0), Color(1), Weight(30))
   Graf.add_bidirectional!(g, Color(0), Color(2), Weight(91))
   Graf.add_bidirectional!(g, Color(0), Color(4), Weight(88))
   Graf.add_bidirectional!(g, Color(0), Color(5), Weight(233))
   Graf.add_bidirectional!(g, Color(0), Color(6), Weight(284))

   Graf.add_bidirectional!(g, Color(1), Color(2), Weight(59))
   Graf.add_bidirectional!(g, Color(1), Color(3), Weight(63))
   Graf.add_bidirectional!(g, Color(1), Color(4), Weight(136))

   Graf.add_bidirectional!(g, Color(2), Color(3), Weight(99))

   Graf.add_bidirectional!(g, Color(3), Color(4), Weight(242))

   Graf.add_bidirectional!(g, Color(4), Color(5), Weight(88))

   Graf.add_bidirectional!(g, Color(5), Color(6), Weight(66))
   Graf.add_bidirectional!(g, Color(5), Color(7), Weight(4))
   Graf.add_bidirectional!(g, Color(5), Color(8), Weight(14))

   Graf.add_bidirectional!(g, Color(6), Color(8), Weight(5))
   Graf.add_bidirectional!(g, Color(6), Color(9), Weight(13))
   Graf.add_bidirectional!(g, Color(6), Color(11), Weight(2))

   Graf.add_bidirectional!(g, Color(7), Color(8), Weight(12))

   Graf.add_bidirectional!(g, Color(8), Color(9), Weight(11))

   Graf.add_bidirectional!(g, Color(9), Color(10), Weight(19))
   Graf.add_bidirectional!(g, Color(9), Color(11), Weight(19))
   Graf.add_bidirectional!(g, Color(9), Color(12), Weight(20))

   Graf.add_bidirectional!(g, Color(10), Color(11), Weight(1))
   Graf.add_bidirectional!(g, Color(10), Color(12), Weight(8))

   Graf.add_bidirectional!(g, Color(11), Color(12), Weight(11))

   return g
end

function map_names_canary_islands()
   map_names = Dict{Color,String}()
   map_names[Color(0)] = "Tenerife"
   map_names[Color(1)] = "La Gomera"
   map_names[Color(2)] = "La Palma"
   map_names[Color(3)] = "El Hierro"
   map_names[Color(4)] = "Gran Canaria"
   map_names[Color(5)] = "Fuerteventura"
   map_names[Color(6)] = "La Graciosa"
   map_names[Color(7)] = "Isla de Lobos"
   map_names[Color(8)] = "Lanzarote"
   map_names[Color(9)] = "Roque del Este"
   map_names[Color(10)] = "Roque del Oeste"
   map_names[Color(11)] = "Montaña Clara"
   map_names[Color(12)] = "Alegranza"

   return map_names
end


function test_tsp_canary_islands()
   graf = create_grafo_canary_islands()

   color_origin = Color(0)
   b_km = Km(1000)
   machine = TSPMachine.new(graf, b_km, color_origin)

   println("## Calculating TSP Machine")
   TSPMachine.execute!(machine)
   println("KM Solution: $(machine.km_solution_recived)")
   #@test machine.actual_km == Km(70)
   #@test machine.km_solution_recived == Km(70)
   cell = TSPMachine.get_cell_origin(machine)
   @test cell != nothing


   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   println("## Search all solutions...")
   limit = UInt128(100)
   reader_exp = PathExpReader.new(graf.n, b_km, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   total = PathExpReader.get_total_solutions_found(reader_exp)
   println("Solutions found: $total with a actual limit: $(reader_exp.limit)/$limit")


   optimal_solution = machine.km_solution_recived
   @test PathChecker.check_all!(machine.graf, reader_exp.paths_solution, optimal_solution)
   println("# Checked all $total solutions [OK]")


   map_names = map_names_canary_islands()
   routes_with_names = PathExpReader.to_string_solutions(reader_exp, map_names)
   println("# Routes with names ")
   println(routes_with_names)
end


test_tsp_canary_islands()
