function create_grafo()
   n = Color(5)
   g = Graf.new(n)
   Graf.add_bidirectional!(g, Color(0), Color(1), Weight(17))
   Graf.add_bidirectional!(g, Color(0), Color(2), Weight(18))
   Graf.add_bidirectional!(g, Color(0), Color(3), Weight(20))
   Graf.add_bidirectional!(g, Color(0), Color(4), Weight(30))

   Graf.add_bidirectional!(g, Color(1), Color(2), Weight(5))
   Graf.add_bidirectional!(g, Color(1), Color(3), Weight(11))
   Graf.add_bidirectional!(g, Color(1), Color(4), Weight(16))

   Graf.add_bidirectional!(g, Color(2), Color(3), Weight(9))
   Graf.add_bidirectional!(g, Color(2), Color(4), Weight(17))

   Graf.add_bidirectional!(g, Color(3), Color(4), Weight(11))

   return g
end

function test_tsp_machine()
   path = "./machine/tsp_disk/disk"
   graf = create_grafo()

   color_origin = Color(0)
   b_km = Km(100)
   machine = TSPMachineDisk.new(graf, b_km, color_origin, path)

   println("## Calculating TSP Machine")
   TSPMachineDisk.execute!(machine)
   println("KM Solution: $(machine.info.km_solution_recived)")
   @test machine.info.actual_km == Km(70) - 1
   @test machine.info.km_solution_recived == Km(70)
   cell = TSPMachineDisk.get_cell_origin(machine)
   @test cell != nothing

   optimal_solution = Weight(70)
   test_get_one_solution(graf.n, b_km, machine, optimal_solution)

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

test_tsp_machine()
