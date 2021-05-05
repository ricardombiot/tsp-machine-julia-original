function build_space_report!(base_reports_path :: String, name_test :: String, name_mode :: String, name_config :: String)
    file_inspector_report = SpaceInspector.get_csv_file_name(base_reports_path)
    file_space_window = get_file_space_window_name(base_reports_path, name_test, name_mode, name_config)
    file_output_memory = get_file_memory_name(base_reports_path, name_test, name_mode, name_config)

    report_memory_csv = ""

    open(file_inspector_report) do io_inspector
        open(file_space_window) do io
            while !eof(io)
                line_csv = readline(io)
                (line_report_final, (time_start, time_end))= read_line_space_window(line_csv)

                (io_inspector, worst_mem_usage) = load_worst_mem_usage_space_window!(io_inspector, time_start, time_end)
                line_report_final = "$line_report_final;$worst_mem_usage"

                #=
                println("-------")
                println(line_csv)
                println(line_report_final)
                println(time_start)
                println(time_end)
                println("-------")
                =#

                report_memory_csv *= line_report_final * "\n"
            end
        end
    end

    write_memory_report!(file_output_memory, report_memory_csv)
end

function write_memory_report!(file_output_memory, report_csv)
    println("Writing memory report $file_output_memory ... ")
    open("$file_output_memory", "w") do io
        write(io, report_csv)
    end
end

function load_worst_mem_usage_space_window!(io_inspector, time_start, time_end)
    flag_found_start = false
    flag_found_end = false
    worst_mem_usage = 0.0

    while !flag_found_end
        if eof(io_inspector)
            println("ERROR: INSPECTOR HAVENT THE WINDOW OF SPACE")
            throw("ERROR: INSPECTOR HAVENT THE WINDOW OF SPACE")
        end

        line_csv = readline(io_inspector)
        (point_time, point_mem_usage) = read_line_inspector(line_csv)

        if !flag_found_start
            if point_time > time_start
                flag_found_start = true
            end
        end

        if flag_found_start
            worst_mem_usage = max(worst_mem_usage, point_mem_usage)
        end

        if point_time > time_end
            flag_found_end = true
        end
    end

    return (io_inspector, worst_mem_usage)
end

function read_line_inspector(line_csv) :: Tuple{DateTime, Float64}
    values = split(line_csv,";")
    point_time = DateTime(values[1])
    point_mem_usage = parse(Float64,values[2])

    (point_time, point_mem_usage)
end

function read_line_space_window(line_csv) :: Tuple{String, Tuple{DateTime,DateTime}}
    values = split(line_csv,";")
    n = values[1]
    time_start = DateTime(values[2])
    time_end = DateTime(values[3])
    mem_allocated = values[4]

    return ("$n;$mem_allocated",(time_start, time_end))
end

function run_memory_inspector(base_reports_path)
    myself_pid = getpid()
    task = @async SpaceInspector.run!(base_reports_path, myself_pid)
    println("Waiting SpaceInspector will be active...")

    wait_while_start(task)
end

function wait_while_start(task)
    while !istaskstarted(task)
        sleep(0.02)
    end
end

function stop_memory_inspector(base_reports_path)
    SpaceInspector.stop!(base_reports_path)
end
