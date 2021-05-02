

function test_tsp_brute_force_complete(n :: Color)
   graf = GrafGenerator.completo(n)

   color_origin = Color(0)
   b_km = Km(n)
   machine = TSPBruteForce.new(graf, b_km, color_origin)
   TSPBruteForce.execute!(machine)

   @test TSPBruteForce.have_solution(machine)

   path = TSPBruteForce.get_solution(machine)
   @test path.length == n+1
   @test path.km == Km(n)

end

test_tsp_brute_force_complete(Color(8))
