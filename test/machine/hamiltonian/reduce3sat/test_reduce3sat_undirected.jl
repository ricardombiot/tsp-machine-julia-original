function create_grafo_reduce3sat_undirected()
   # (x1 + x2 + !x3) * (!x2 + x3 + x4) * (x1 + !x2 + x4)
   # Example: https://opendsa-server.cs.vt.edu/ODSA/Books/Everything/html/threeSAT_to_hamiltonianCycle.html
   n = Color(87)
   g = Graf.new(n)

   Graf.add_bidirectional!(g, Color(0), Color(29))
   Graf.add_bidirectional!(g, Color(0), Color(30))

   Graf.add!(g, Color(30), Color(31))
   Graf.add!(g, Color(30), Color(41))

   Graf.add_bidirectional!(g, Color(1), Color(31))
   Graf.add_bidirectional!(g, Color(1), Color(32))

   Graf.add!(g, Color(32), Color(33))
   Graf.add!(g, Color(32), Color(43))
   Graf.add!(g, Color(32), Color(53))
   Graf.add!(g, Color(32), Color(81))

   Graf.add_bidirectional!(g, Color(2), Color(33))
   Graf.add_bidirectional!(g, Color(2), Color(34))

   Graf.add!(g, Color(34), Color(31))
   Graf.add!(g, Color(34), Color(35))

   Graf.add_bidirectional!(g, Color(3), Color(35))
   Graf.add_bidirectional!(g, Color(3), Color(36))

   Graf.add!(g, Color(36), Color(33))
   Graf.add!(g, Color(36), Color(37))

   Graf.add_bidirectional!(g, Color(4), Color(37))
   Graf.add_bidirectional!(g, Color(4), Color(38))

   Graf.add!(g, Color(38), Color(35))
   Graf.add!(g, Color(38), Color(39))

   Graf.add_bidirectional!(g, Color(5), Color(39))
   Graf.add_bidirectional!(g, Color(5), Color(40))

   Graf.add!(g, Color(40), Color(37))
   Graf.add!(g, Color(40), Color(41))
   Graf.add!(g, Color(40), Color(85))

   Graf.add_bidirectional!(g, Color(6), Color(41))
   Graf.add_bidirectional!(g, Color(6), Color(42))

   Graf.add!(g, Color(42), Color(39))
   Graf.add!(g, Color(42), Color(53))
   Graf.add!(g, Color(42), Color(43))

   Graf.add_bidirectional!(g, Color(7), Color(43))
   Graf.add_bidirectional!(g, Color(7), Color(44))

   Graf.add!(g, Color(44), Color(45))
   Graf.add!(g, Color(44), Color(55))
   Graf.add!(g, Color(44), Color(65))
   Graf.add!(g, Color(44), Color(81))

   Graf.add_bidirectional!(g, Color(8), Color(45))
   Graf.add_bidirectional!(g, Color(8), Color(46))

   Graf.add!(g, Color(46), Color(43))
   Graf.add!(g, Color(46), Color(47))

   Graf.add_bidirectional!(g, Color(9), Color(47))
   Graf.add_bidirectional!(g, Color(9), Color(48))

   Graf.add!(g, Color(48), Color(45))
   Graf.add!(g, Color(48), Color(49))

   Graf.add_bidirectional!(g, Color(10), Color(49))
   Graf.add_bidirectional!(g, Color(10), Color(50))

   Graf.add!(g, Color(50), Color(47))
   Graf.add!(g, Color(50), Color(51))
   Graf.add!(g, Color(50), Color(83))

   Graf.add_bidirectional!(g, Color(11), Color(51))
   Graf.add_bidirectional!(g, Color(11), Color(52))

   Graf.add!(g, Color(52), Color(49))
   Graf.add!(g, Color(52), Color(53))

   Graf.add_bidirectional!(g, Color(12), Color(53))
   Graf.add_bidirectional!(g, Color(12), Color(54))

   Graf.add!(g, Color(54), Color(51))
   Graf.add!(g, Color(54), Color(55))
   Graf.add!(g, Color(54), Color(65))
   Graf.add!(g, Color(54), Color(85))

   Graf.add_bidirectional!(g, Color(13), Color(55))
   Graf.add_bidirectional!(g, Color(13), Color(56))

   Graf.add!(g, Color(56), Color(57))
   Graf.add!(g, Color(56), Color(67))
   Graf.add!(g, Color(56), Color(77))

   Graf.add_bidirectional!(g, Color(14), Color(57))
   Graf.add_bidirectional!(g, Color(14), Color(58))

   Graf.add!(g, Color(58), Color(55))
   Graf.add!(g, Color(58), Color(59))
   Graf.add!(g, Color(58), Color(81))

   Graf.add_bidirectional!(g, Color(15), Color(59))
   Graf.add_bidirectional!(g, Color(15), Color(60))

   Graf.add!(g, Color(60), Color(57))
   Graf.add!(g, Color(60), Color(61))
   Graf.add!(g, Color(60), Color(83))

   Graf.add_bidirectional!(g, Color(16), Color(61))
   Graf.add_bidirectional!(g, Color(16), Color(62))

   Graf.add!(g, Color(62), Color(59))
   Graf.add!(g, Color(62), Color(63))

   Graf.add_bidirectional!(g, Color(17), Color(63))
   Graf.add_bidirectional!(g, Color(17), Color(64))

   Graf.add!(g, Color(64), Color(61))
   Graf.add!(g, Color(64), Color(65))

   Graf.add_bidirectional!(g, Color(18), Color(65))
   Graf.add_bidirectional!(g, Color(18), Color(66))

   Graf.add!(g, Color(66), Color(63))
   Graf.add!(g, Color(66), Color(67))
   Graf.add!(g, Color(66), Color(77))

   Graf.add_bidirectional!(g, Color(19), Color(67))
   Graf.add_bidirectional!(g, Color(19), Color(68))

   Graf.add!(g, Color(68), Color(69))
   Graf.add!(g, Color(68), Color(79))

   Graf.add_bidirectional!(g, Color(20), Color(69))
   Graf.add_bidirectional!(g, Color(20), Color(70))

   Graf.add!(g, Color(70), Color(67))
   Graf.add!(g, Color(70), Color(71))

   Graf.add_bidirectional!(g, Color(21), Color(71))
   Graf.add_bidirectional!(g, Color(21), Color(72))

   Graf.add!(g, Color(72), Color(69))
   Graf.add!(g, Color(72), Color(73))
   Graf.add!(g, Color(72), Color(83))

   Graf.add_bidirectional!(g, Color(22), Color(73))
   Graf.add_bidirectional!(g, Color(22), Color(74))

   Graf.add!(g, Color(74), Color(71))
   Graf.add!(g, Color(74), Color(75))

   Graf.add_bidirectional!(g, Color(23), Color(75))
   Graf.add_bidirectional!(g, Color(23), Color(76))

   Graf.add!(g, Color(76), Color(73))
   Graf.add!(g, Color(76), Color(77))
   Graf.add!(g, Color(76), Color(85))

   Graf.add_bidirectional!(g, Color(24), Color(77))
   Graf.add_bidirectional!(g, Color(24), Color(78))

   Graf.add!(g, Color(78), Color(75))
   Graf.add!(g, Color(78), Color(79))

   Graf.add_bidirectional!(g, Color(25), Color(79))
   Graf.add_bidirectional!(g, Color(25), Color(80))

   Graf.add!(g, Color(80), Color(29))

   Graf.add_bidirectional!(g, Color(26), Color(81))
   Graf.add_bidirectional!(g, Color(26), Color(82))

   Graf.add!(g, Color(82), Color(33))
   Graf.add!(g, Color(82), Color(45))
   Graf.add!(g, Color(82), Color(55))

   Graf.add_bidirectional!(g, Color(27), Color(83))
   Graf.add_bidirectional!(g, Color(27), Color(84))

   Graf.add!(g, Color(84), Color(47))
   Graf.add!(g, Color(84), Color(61))
   Graf.add!(g, Color(84), Color(73))

   Graf.add_bidirectional!(g, Color(28), Color(85))
   Graf.add_bidirectional!(g, Color(28), Color(86))

   Graf.add!(g, Color(86), Color(41))
   Graf.add!(g, Color(86), Color(51))
   Graf.add!(g, Color(86), Color(77))

   return g
end

function test_hal_grafo_reduce3sat_undirected()
   graf = create_grafo_reduce3sat_undirected()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calculating Graph Reduce3sat")
   HalMachine.execute!(machine)

   println("## Graph parent")
   graph = SolutionGraphReader.get_one_solution_graph(machine)
   graph_join = graph
   Graphviz.to_png(graph_join,"graph_parent","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")
   #println(graph)
   #println("## Building join")
   #graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   #println("## Plot join")
   #Graphviz.to_png(graph_join,"graph_join","./machine/hamiltonian/visual_graphs/grafo_reduce3sat")

   #=
   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
   =#


   limit = UInt128(10)
   b = Km(graf.n)
   println("## Searching paths")
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   println("## Cheking paths")
   optimal = Weight(graf.n)
   @test PathChecker.check_all!(graf, reader_exp.paths_solution, optimal)
      #==#
end



test_hal_grafo_reduce3sat_undirected()
