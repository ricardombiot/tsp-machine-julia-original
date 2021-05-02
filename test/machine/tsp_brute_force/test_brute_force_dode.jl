function test_tsp_brute_force()
   graf = GrafGenerator.dodecaedro()

   color_origin = Color(0)
   b_km = Km(21)
   machine = TSPBruteForce.new(graf, b_km, color_origin)
   TSPBruteForce.execute!(machine)

   @test TSPBruteForce.have_solution(machine)

   path = TSPBruteForce.get_solution(machine)
   @test path.length == 20+1
   @test path.km == Km(20)

end

function test_tsp_brute_force_all_solutions()
   graf = GrafGenerator.dodecaedro()

   color_origin = Color(0)
   b_km = Km(21)
   machine = TSPBruteForce.new(graf, b_km, color_origin, true)
   TSPBruteForce.execute!(machine)

   @test TSPBruteForce.have_solution(machine)


   path = TSPBruteForce.get_solution(machine)
   @test path.length == 20+1
   @test path.km == Km(20)

   @test length(machine.path_solution) == 60

end


test_tsp_brute_force()
test_tsp_brute_force_all_solutions()
