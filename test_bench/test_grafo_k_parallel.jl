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

   path_csvs = "./reports"


   csv_times_file = ""
   csv_space_file = ""
   for n in 3:6
      wait_gc_before()
      time_start_window_space = DateTime(now())
      csv_times_line = "$n"

      println("#### Time K$n")
      n_color = Color(n)
      color_origin = Color(0)
      graf = GrafGenerator.completo(n_color)
      time_execute_total = 0
      for iter in 1:iterations
         time_execute = test_grafo_with_g(graf)
         time_execute = cast_time_to_int64(time_execute)
         csv_times_line *=";$time_execute"

         time_execute_total += time_execute
      end
      avg_time_execute = time_execute_total / iterations

      println(avg_time_execute)
      csv_times_file *= csv_times_line *"\n"
      time_end_window_space = DateTime(now())
      csv_space_file *= "$n;$time_start_window_space;$time_end_window_space" *"\n"

   end
   #println("### CSV_REPORT_TIMES ###")
   #println(csv_times_file)
   #println("### CSV_SPACE_WINDOW_TIMES ###")
   #println(csv_space_file)
   write_csv!(path_csvs, "report_times", csv_times_file)
   write_csv!(path_csvs, "report_space_window", csv_space_file)

end

function write_csv!(path, file, content)
   open("$path/$(file).csv", "w") do io
      write(io, content)
   end
end

function wait_gc_before()
   GC.gc()
   sleep(0.1)
end

function test_grafo_with_g(graf, log = false)
   time = now()
   color_origin = Color(0)
   b_km = Km(graf.n)
   machine = ParallelTSPMachine.new(graf, b_km, color_origin)
   ParallelTSPMachine.execute!(machine)

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


   time_execute = now() - time
   return time_execute
end

function cast_time_to_int64(ms :: Millisecond) :: Int64
    ms = replace("$ms"," milliseconds" => "")
    ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms")
end

test_bench()
