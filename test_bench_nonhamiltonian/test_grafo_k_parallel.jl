using BenchmarkTools
using Test
using Dates
include("./../src/main.jl")

function test_bench()
   n_thr = Threads.nthreads()
   iterations = 30

   println("#### Benchmark ###")
   println("# Threads: $(n_thr)")
   println("# Iterations: $(iterations)")

   csv_txt = ""
   for n in 5:10
      csv_times_line = "$n"
      println("#### Time K$n")
      n_color = Color(n)
      color_origin = Color(0)
      graf = GrafGenerator.not_hamiltonian_node_isolated(n_color)
      time_execute_total = 0
      for iter in 1:iterations
         time_execute = test_grafo_with_g(graf)
         time_execute = cast_time_to_int64(time_execute)
         csv_times_line *=";$time_execute"

         time_execute_total += time_execute
      end
      avg_time_execute = time_execute_total / iterations

      println(avg_time_execute)
      csv_txt *= csv_times_line *"\n"
   end
   println("### CSV_REPORT ###")
   println(csv_txt)

end

function test_grafo_with_g(graf, log = false)
   color_origin = Color(0)
   b_km = Km(graf.n)
   machine = ParallelTSPMachine.new(graf, b_km, color_origin)

   time = now()
   ParallelTSPMachine.execute!(machine)
   time_execute = now() - time

   @test SolutionGraphReader.have_solution(machine) == false

   return time_execute
end

function cast_time_to_int64(ms :: Millisecond) :: Int64
    ms = replace("$ms"," milliseconds" => "")
    ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms")
end

test_bench()
