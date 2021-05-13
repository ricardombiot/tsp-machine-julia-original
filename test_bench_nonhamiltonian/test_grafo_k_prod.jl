using BenchmarkTools
using Test
include("./../src/main.jl")

function test_bench()

   for n in 5:20
      n_color = Color(n)
      color_origin = Color(0)
      graf = GrafGenerator.not_hamiltonian_node_isolated(n_color)
      b = @benchmarkable test_grafo_with_g(x) setup=(x = deepcopy($graf)) samples=30 seconds=1000.0
      println("#### Time K$n")
      println(run(b))
   end

end

function test_grafo_with_g(graf, log = false)
   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)
   HalMachine.execute!(machine)

   @test SolutionGraphReader.have_solution(machine) == false
end

test_bench()
