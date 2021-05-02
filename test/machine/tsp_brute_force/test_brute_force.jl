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

function test_tsp_brute_force()
   graf = create_grafo()

   color_origin = Color(0)
   b_km = Km(70)
   machine = TSPBruteForce.new(graf, b_km, color_origin)
   TSPBruteForce.execute!(machine)

   @test TSPBruteForce.have_solution(machine)

   path = TSPBruteForce.get_solution(machine)
   @test path.length == 5+1
   @test path.km == Km(70)

end

test_tsp_brute_force()
