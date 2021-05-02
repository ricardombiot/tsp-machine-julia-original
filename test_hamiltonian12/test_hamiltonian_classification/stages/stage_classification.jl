
function stage_classification!(data :: DataClassification)

    total_time_tsp_machine = Base.Threads.Atomic{Int64}(0)
    total_time_hal_machine = Base.Threads.Atomic{Int64}(0)
    total_time_tsp_brute = Base.Threads.Atomic{Int64}(0)
    counter = Base.Threads.Atomic{Int64}(1)
    n = data.n
    total = data.total
    path_tsp_machine = data.path_tsp_machine
    path_hal_machine = data.path_hal_machine
    path_tsp_brute = data.path_tsp_brute

    Threads.@threads for id in 0:total-1


        try
            thr = Threads.threadid()
            println("$(id) to worker: $(thr)")
            procentage = (counter[]/ total) * 100
            println("Counter: $(counter[]) State: $procentage%")


            time_execution = test_clasification_tsp_machine(n, id, path_tsp_machine)
            time_execution = cast_time_to_int64(time_execution)
            Threads.atomic_add!(total_time_tsp_machine, time_execution)

            time_execution = test_clasification_hal_machine(n, id, path_hal_machine)
            time_execution = cast_time_to_int64(time_execution)
            Threads.atomic_add!(total_time_hal_machine, time_execution)

            time_execution = test_clasification_tsp_brute_force(n, id, path_tsp_brute)
            time_execution = cast_time_to_int64(time_execution)
            Threads.atomic_add!(total_time_tsp_brute, time_execution)

            Threads.atomic_add!(counter, 1)
        catch
            @warn "Error in thread"
        end # try


    end


    data.avg_time_tsp_machine = total_time_tsp_machine[] / data.total
    data.avg_time_hal_machine = total_time_hal_machine[] / data.total
    data.avg_time_tsp_brute = total_time_tsp_brute[] / data.total
end
