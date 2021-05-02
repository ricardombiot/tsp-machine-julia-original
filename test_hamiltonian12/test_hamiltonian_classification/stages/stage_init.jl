function stage_init(base_path :: String, n :: Color) :: DataClassification
    avoid_first_slow_execution_for_compiling()

    base_path = "$base_path$n"
    path_tsp_machine = prepare_folders_results(base_path, "tsp_machine")
    path_hal_machine = prepare_folders_results(base_path, "hal_machine")
    path_tsp_brute = prepare_folders_results(base_path, "tsp_brute")


    total = Int64(2^((n*(n-1))/2))
    total_ok = 0
    total_time_tsp_machine = Threads.Atomic{Int64}(0)
    total_time_hal_machine = Threads.Atomic{Int64}(0)
    total_time_tsp_brute = Threads.Atomic{Int64}(0)
    counter = Threads.Atomic{Int64}(1)


    DataClassification(n, path_tsp_machine, path_hal_machine, path_tsp_brute,
        total, total_ok, total_time_tsp_machine, total_time_hal_machine, total_time_tsp_brute, counter,
        0, 0, 0, 0.0, 0.0)
end


function avoid_first_slow_execution_for_compiling()
    graf = GrafGenerator.completo(Color(5))
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    HalMachine.execute!(machine)
end
