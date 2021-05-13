module SpaceInspector
    using Dates

    function run!(base_path :: String, pid)
        println("Start target: $pid")
        init_folder!(base_path)
        init_clean_files!(base_path)
        execute!(base_path, pid)
    end

    function init_folder!(base_path :: String)
        if !isdir("$base_path/tmp_inspector")
            mkdir("$base_path/tmp_inspector")
        end
    end

    function init_clean_files!(base_path :: String)
        if isfile(get_csv_file_name(base_path))
            rm(get_csv_file_name(base_path))
        end

        if isfile(get_stop_file_name(base_path))
            rm(get_stop_file_name(base_path))
        end
    end

    function stop!(base_path :: String)
        stop_file = get_stop_file_name(base_path)
        shell_command = `touch $(stop_file)`
        run(shell_command)
    end

    function get_stop_file_name(base_path)
        "$base_path/tmp_inspector/space_inspector.stop"
    end

    function get_csv_file_name(base_path :: String)
        "$base_path/tmp_inspector/space_inspector.csv"
    end

    function halt(base_path :: String) :: Bool
        isfile(get_stop_file_name(base_path))
    end

    function execute!(base_path :: String, pid)
         open(get_csv_file_name(base_path), "w") do io

             while !halt(base_path)
                 sleep(0.0001)
                 timeframe = get_time_frame()
                 memory = get_total_usage_memory(pid)
                 write(io, "$timeframe;$memory" * "\n")
             end

         end
    end

    function get_time_frame()
        DateTime(now())
    end

    function get_total_usage_memory(pid)
        # Alterative: Read the memory of process
        #command = `\(ps -eo pid,vsize\) \| grep $pid`
        #command = `top -l 1 -o mem -pid $pid \| tail -n 1`
        #println(command)
        #result_memory = run(command)
        #println(result_memory)

        usage_bytes = Sys.total_memory() - Sys.free_memory()
        usage_mb = trunc( usage_bytes / 1024 / 1024)
        return usage_mb
    end

end
