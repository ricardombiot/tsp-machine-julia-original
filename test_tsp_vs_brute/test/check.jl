include("./../../src/main.jl")
using Dates

function write_times_result!(path :: String, txt_time :: String, name :: String)
        path_file_times = "$(path)/check_times_$name.csv"

        open(path_file_times, "w") do io
            write(io, txt_time)
        end
end

function write_result!(path :: String, txt_checked_rate :: String, txt_time :: String)
        path_file_checked_rate = "$(path)/check_rate.txt"
        path_file_times = "$(path)/check_times.txt"

        open(path_file_checked_rate, "w") do io
            write(io, txt_checked_rate)
        end

        open(path_file_times, "w") do io
            write(io, txt_time)
        end
end

function main(args)

     n = parse(UInt128,popfirst!(args))
     total = parse(Int64,popfirst!(args))

     base_path = "./data/results$n"
     path_tsp_machine = get_folder_algoritm(base_path, "tsp_machine_parallel")
     path_tsp_brute = get_folder_algoritm(base_path, "tsp_brute")


     times_tsp_machine = [-1, 0, 0]
     times_tsp_brute = [-1, 0, 0]

     total_checked = 0
     total_checked_valid = 0
     #total = 5
     for id in 0:total-1
         if isfile(get_file_solutions(path_tsp_brute, id)) && isfile(get_file_solutions(path_tsp_machine, id))

            solutions_tsp_brute = open(f->read(f, String), get_file_solutions(path_tsp_brute, id))
            solutions_tsp_machine = open(f->read(f, String), get_file_solutions(path_tsp_machine, id))

            set_solutions_tsp_brute = Set(split(solutions_tsp_brute, "\n"))
            set_solutions_tsp_machine = Set(split(solutions_tsp_machine, "\n"))

            set_diff_solutions = setdiff(set_solutions_tsp_brute, set_solutions_tsp_machine)

            if isempty(set_diff_solutions)
               #println("[$id] OK")
               total_checked_valid += 1

               times_tsp_brute = collect_time(path_tsp_brute, id, times_tsp_brute)
               times_tsp_machine = collect_time(path_tsp_machine, id, times_tsp_machine)
            else
               println("[$id] ERROR")
            end



            total_checked += 1
         end
     end

     rate = (total_checked_valid / total_checked) * 100
     times_tsp_brute = collect_avg_time(times_tsp_brute, total_checked_valid)
     txt_times_tsp_brute = to_string_close_txt_times(times_tsp_brute, n, "tsp_brute")
     times_tsp_machine = collect_avg_time(times_tsp_machine, total_checked_valid)
     txt_times_tsp_machine = to_string_close_txt_times(times_tsp_machine, n, "tsp_machine")

     println("## Summary Checked ##")
     println("Graf. N: $n")
     println("TOTAL: $total_checked")
     println("TOTAL OK: $total_checked_valid")
     println("RATE: $rate%")
     println(txt_times_tsp_brute)
     println(txt_times_tsp_machine)

     write_result!(base_path, "$rate", "$txt_times_tsp_brute\n$txt_times_tsp_machine\n")
     write_times_result!(base_path, "$txt_times_tsp_brute\n", "tsp_brute")
     write_times_result!(base_path, "$txt_times_tsp_machine\n", "tsp_machine")
end

function get_folder_algoritm(base_path, name_algorithm)
    "$base_path/$name_algorithm"
end

function get_file_solutions(path , id )
    "$path/$(id)_solutions.txt"
end

function get_file_time(path , id )
    "$path/$(id)_time.txt"
end

function to_string_close_txt_times(array_close_times, n, name_algorithm) :: String
    min = array_close_times[1]
    max = array_close_times[2]
    avg = array_close_times[3]
    total = array_close_times[4]

    "$name_algorithm;$n;$min;$max;$avg;$total"
end

function collect_avg_time(array_times, total_checked_valid) :: Array{Float64,1}
    min = array_times[1]
    max = array_times[2]
    total = array_times[3]

    avg = (total / total_checked_valid)
    [min, max, avg, total]
end

function collect_time(path , id, array_times) :: Array{Int64,1}
    time_ms = read_ms_file_time(path , id )

    min = array_times[1]
    max = array_times[2]
    total = array_times[3]

    if min == -1 || min > time_ms
        min = time_ms
    end

    if max < time_ms
        max = time_ms
    end

    total += time_ms

    [min, max, total]
end

function read_ms_file_time(path , id ) :: Int64
    txt_time_ms = open(f->read(f, String), get_file_time(path , id ))

    return cast_time_to_int64(txt_time_ms)
end

function cast_time_to_int64(ms :: String) :: Int64
    ms = replace("$ms"," milliseconds" => "")
    ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms")
end

main(ARGS)
