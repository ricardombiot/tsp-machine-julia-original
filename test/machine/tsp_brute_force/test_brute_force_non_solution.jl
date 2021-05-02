

function test_tsp_brute_force_non_solution(n :: Color)
   graf = GrafGenerator.not_hamiltonian_one_node_with_one_edge(n)

   color_origin = Color(0)
   b_km = Km(n)
   machine = TSPBruteForce.new(graf, b_km, color_origin)
   TSPBruteForce.execute!(machine)

   @test TSPBruteForce.have_solution(machine) == false

end

test_tsp_brute_force_non_solution(Color(10))
