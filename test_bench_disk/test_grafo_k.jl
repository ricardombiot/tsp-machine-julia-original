using BenchmarkTools
using Test
include("./../src/main.jl")

function test_bench()

   #for n in 3:6
   for n in 7:10
      n_color = Color(n)
      color_origin = Color(0)
      graf = GrafGenerator.completo(n_color, Weight(10))
      b = @benchmarkable test_grafo_with_g(x, true) setup=(x = deepcopy($graf)) samples=1 seconds=1000.0
      println("#### Time K$n")
      println(run(b))
   end

end

function test_grafo_with_g(graf, log = false)
   path = "./data/disk"

   if isdir(path)
      rm(path, recursive = true)
      mkdir(path)
   else
      mkdir(path)
   end

   b_km = (graf.n+1) * 10
   color_origin = Color(0)
   machine = TSPMachineDisk.new(graf, b_km, color_origin, path)
   TSPMachineDisk.activate_parallel!(machine)
   TSPMachineDisk.execute!(machine)



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

   optimal = Weight(graf.n * 10)
   checker = PathChecker.new(graf, path, optimal)

   @test PathChecker.check!(checker)
   if log
      println("## Checking tour.. $(checker.valid)")
   end
end

test_bench()
