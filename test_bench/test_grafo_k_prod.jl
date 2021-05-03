using BenchmarkTools
using Test
include("./../src/main.jl")

function test_bench()

   for n in 3:14
      n_color = Color(n)
      color_origin = Color(0)
      graf = GrafGenerator.completo(n_color)
      b = @benchmarkable test_grafo_with_g(x) setup=(x = deepcopy($graf)) samples=30 seconds=1000.0
      println("#### Time K$n")
      println(run(b))
   end

end

function test_grafo_with_g(graf, log = false)
   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)
   HalMachine.execute!(machine)

   if log
      println("## Search solution.. ")
   end
   graph = SolutionGraphReader.get_one_solution_graph(machine)


   if log
      println("## Read tour.. ")
   end
   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph)
   if log
      println(tour)
   end
   @test path.step == graf.n+1
   #=
   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)

   @test PathChecker.check!(checker)
   if log
      println("## Checking tour.. $(checker.valid)")
   end
   =#
end

test_bench()
