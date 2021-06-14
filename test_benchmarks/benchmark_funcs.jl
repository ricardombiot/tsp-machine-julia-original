function write_reports!(base_reports_path :: String, name_test :: String, name_mode :: String, name_config :: String, n_start :: Int64, n_end :: Int64, params, times_report, windows_report)
    build_directories_reports!(base_reports_path, name_test, name_mode)
    #file_times = "$path_mode_test/$(name_config)_times.csv"
    #file_space_window = get_file_space_window_name "$path_mode_test/$(name_config)_space_window.csv"
    file_times = get_file_times_name(base_reports_path, name_test, name_mode, name_config)
    file_space_window = get_file_space_window_name(base_reports_path, name_test, name_mode, name_config)

    write_times_report!(file_times, times_report, n_start, n_end, params)
    write_space_window_report!(file_space_window, windows_report)
end

function get_file_times_name(base_reports_path :: String, name_test :: String, name_mode :: String, name_config :: String) :: String
    "$base_reports_path/$name_test/$name_mode/$(name_config)_times.csv"
end

function get_file_space_window_name(base_reports_path :: String, name_test :: String, name_mode :: String, name_config :: String) :: String
    "$base_reports_path/$name_test/$name_mode/$(name_config)_space_window.csv"
end

function get_file_memory_name(base_reports_path :: String, name_test :: String, name_mode :: String, name_config :: String) :: String
    "$base_reports_path/$name_test/$name_mode/$(name_config)_memory.csv"
end

function write_times_report!(file_times, times_report, n_start, n_end, params)
    println("Writing times report $file_times ... ")
    open("$file_times", "w") do io
        #for (n, iter_times) in times_report
        #for n in n_start:n_end
        for n in get_n_range(params)
            iter_times = times_report[n]
            line_txt = "$n"
            total_items = 0
            total = 0.0
            for time_in_iter in iter_times
                line_txt *= ";$time_in_iter"
                total += time_in_iter
                total_items += 1
            end

            average = 0.0
            if total_items > 0
                average = total / total_items
            end
            write(io, line_txt * ";$average\n")
        end
    end
end

function write_space_window_report!(file_space_window :: String, windows_report)
    println("Writing space window report $file_space_window ... ")
    open("$file_space_window", "w") do io
        for line in windows_report
            write(io, line * "\n")
        end
    end
end

function build_directories_reports!(base_reports_path, name_test, name_mode)
    if !isdir(base_reports_path)
        mkdir(base_reports_path)
    end
    path_name_test = "$base_reports_path/$name_test"

    if !isdir(path_name_test)
        mkdir(path_name_test)
    end

    path_mode_test = "$path_name_test/$name_mode"
    if !isdir(path_mode_test)
        mkdir(path_mode_test)
    end
end

function test_execute(instance, activate_log)
    time = now()
    stats = @timed TestBuilder.test_instance(instance, activate_log)
    mem_allocated = stats.bytes
    #println(stats)
    #mem_allocated = @allocated TestBuilder.test_instance(instance, activate_log)
    #mem_allocated = trunc(mem_allocated / 1024 / 1024)
    time_execute = now() - time
    return (cast_time_to_int64(time_execute), mem_allocated)
end

function cast_time_to_int64(ms :: Millisecond) :: Int64
    ms_txt = "$ms"
    ms_txt = replace(ms_txt," milliseconds" => "")
    ms_txt = replace(ms_txt," millisecond" => "")
    #ms = replace("$ms"," milliseconds" => "")
    #ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms_txt")
end

function get_n_range(params)
    n_start = params["n_start"]
    n_end = params["n_end"]
    n_inc = 1
    if haskey(params, "n_inc")
        n_inc = params["n_inc"]
    end


    return n_start:n_inc:n_end
end

function main_executor(base_reports_path, args)
    config_file = first(args)
    params = YAML.load_file(config_file)

    name_test = params["name_test"]
    name_mode = params["name_mode"]
    name_config = params["name_config"]
    singlecore = params["singlecore"]
    threads = params["threads"]
    activate_log = params["activate_log"]
    activate_log_iters = params["activate_log_iters"]
    n_start = params["n_start"]
    n_end = params["n_end"]
    iterations = params["iterations"]

    times_report = Dict{Int64,Array{Int64,1}}()
    windows_report = Array{String,1}()
    is_fisrt_execution = true
    #avoid_fisrt_register_execution = true

    for n in get_n_range(params)
        sleep(0.01)
        if activate_log
            println("INPUT: Graph of [$n]")
        end
        ## Save window space
        time_start_window_space = DateTime(now())
        times_report[n] = Array{Int64,1}()
        worst_mem_allocated = -1

        instance = TestBuilder.create_by_n_instance(n)
        for iter in 1:iterations
            if instance == nothing
                instance = TestBuilder.create_by_iter_instance(n)
            end

            (time_execution, mem_allocated) = test_execute(instance, activate_log_iters)
            if is_fisrt_execution
                (time_execution, mem_allocated) = test_execute(instance, activate_log_iters)
                is_fisrt_execution = false
            end

            #if !avoid_fisrt_register_execution
            push!(times_report[n], time_execution)
            worst_mem_allocated = max(worst_mem_allocated, mem_allocated)
            #end
            #avoid_fisrt_register_execution = false

            if activate_log_iters
                println("Iter [$n, $iter]: $time_execution ms")
            end

            GC.gc()
        end

        time_end_window_space = DateTime(now())
        push!(windows_report, "$n;$time_start_window_space;$time_end_window_space;$worst_mem_allocated")
    end

    if activate_log
        println("Finished Testing")
        println("Writing Reports... wait please.")
    end

    write_reports!(base_reports_path, name_test, name_mode, name_config, n_start, n_end, params, times_report, windows_report)
end
