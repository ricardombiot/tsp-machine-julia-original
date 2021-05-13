#import Pkg;
#Pkg.add("Plots")
#Pkg.add("YAML")

import YAML
using Dates
using Plots
include("./../src/main.jl")
include("./benchmark_funcs.jl")
include("./benchmark_space.jl")

function main(args)
    config_file = first(args)
    params = YAML.load_file(config_file)

    series_funs = Dict{String, Any}()

    series_funs["n!"] = (n) -> factorial(n)
    series_funs["n"] = (n) -> n
    series_funs["n^2"] = (n) -> n^2
    series_funs["n^3"] = (n) -> n^3
    series_funs["n^4"] = (n) -> n^4
    series_funs["n^5"] = (n) -> n^5
    series_funs["n^6"] = (n) -> n^6
    series_funs["n^7"] = (n) -> n^7
    series_funs["n^8"] = (n) -> n^8

    series_funs["n^12"] = (n) -> n^12
    series_funs["n^14"] = (n) -> n^14
    series_funs["n^16"] = (n) -> n^16

    n_start = params["n_start"]
    n_end = params["n_end"]
    n_inc = 1
    if haskey(params, "n_inc")
        n_inc = params["n_inc"]
    end
    plots = params["plots"]

    #println(plots)

    base_reports_path="./reports"

    println("# Calculating...")
    time_increments = load_time_increments(base_reports_path, params)
    memory_increments = load_memory_increments(base_reports_path, params)

    base_series = Dict{String, Any}()
    base_series["time"] = time_increments
    base_series["space"] = memory_increments

    println("# Buiding plots...")

    x = n_start+n_inc:n_inc:n_end
    gr()
    for (plot_key, plot_config) in plots
        p = nothing
        name = plot_config["name"]
        title = plot_config["title"]
        series = plot_config["series"]
        target_name = plot_config["target"]["name"]
        target_serie = plot_config["target"]["serie"]

        println("# Starting ploting... $name")
        p = plot(x, base_series[target_serie], label= target_name, title = title , lw = 2)

        #println(name)
        #println(series)
        println("   - Calculating series...")
        for serie in series
            #println("------")
            #println(serie)
            name_serie = serie["name"]
            fn_serie = serie["serie"]
            values = calc_serie(fn_serie, series_funs, params)
            #println(name_serie)
            #println(values)
            plot!(p, x, values, label = name_serie)
        end
        println("   - Config title...")
        x_title_plot!(p, params)
        save_path_image = get_name_save_path_image(base_reports_path, params, name)
        println("   - Saving plot in... $save_path_image.png")
        savefig(p, "$save_path_image.png")
        #println("   - Saving plot in... $save_path_image.tikz")
        #savefig(p, "$save_path_image.tikz")
        println("   - Saved plot: $name [OK]")
    end

end


function get_name_save_path_image(base_reports_path, params, name)

    name_test= params["name_test"]
    name_mode= params["name_mode"]
    name_config = params["name_config"]

    "$base_reports_path/$name_test/$name_mode/$(name_config)_$(name)"
end

function x_title_plot!(p, params)
    iterations = params["iterations"]
    singlecore = params["singlecore"]
    threads = params["threads"]

    if singlecore
        xlabel!(p, "N iterations: $iterations (singlecore)")
    else
        xlabel!(p, "N iterations: $iterations threads: $threads")
    end
end

function calc_serie(name, series_funs, params)
    func = series_funs[name]
    results = Dict{Int64,Float64}()
    for n in get_n_range(params)
        val = func(n)
        results[n] = val
    end

    return calc_increment(results, params)
end

function calc_increment(results, params)
    lista_increments = Array{Float64,1}()
    last_n = nothing
    for n in get_n_range(params)
        if last_n != nothing
            last = results[last_n]
            actual = results[n]

            if last != 0 && actual != 0
                increment = ceil(((actual/last)-1)*100)
            else
                increment = 0
            end

            push!(lista_increments, increment)
        end

        last_n = n
    end

    return lista_increments
end

function load_memory_increments(base_reports_path, params)
    name_test= params["name_test"]
    name_mode= params["name_mode"]
    name_config = params["name_config"]
    n_start = params["n_start"]
    n_end = params["n_end"]

    file_memory = get_file_memory_name(base_reports_path, name_test , name_mode, name_config)

    results = Dict{Int64,Float64}()

    open(file_memory) do io
        while !eof(io)
           csv_line = readline(io)
           values = read_memory_times(csv_line)

           n = values[1]
           worst_allocated = values[2]

           results[n] = worst_allocated
       end
    end


    lista_increments = Array{Float64,1}()
    last_n = nothing
    for n in get_n_range(params)
        if last_n != nothing
            last_worst_allocated = results[last_n]
            actual_worst_allocated = results[n]

            if last_worst_allocated != 0 && actual_worst_allocated != 0
                increment = ceil(((actual_worst_allocated/last_worst_allocated)-1)*100)
            else
                increment = 0
            end

            push!(lista_increments, increment)
        #else
        #    push!(lista_increments, 0)
        end

        last_n = n
    end

    return lista_increments

end

function load_time_increments(base_reports_path, params)
    name_test= params["name_test"]
    name_mode= params["name_mode"]
    name_config = params["name_config"]
    n_start = params["n_start"]
    n_end = params["n_end"]

    file_times = get_file_times_name(base_reports_path, name_test , name_mode, name_config)

    results = Dict{Int64,Float64}()

    open(file_times) do io
        while !eof(io)
           csv_line = readline(io)
           values = read_line_times(csv_line)

           n = values[1]
           average = values[2]

           results[n] = average
          # println(csv_line)
       end
    end

    lista_increments = Array{Float64,1}()
    last_n = nothing
    for n in get_n_range(params)
        if last_n != nothing
            last_average = results[last_n]
            actual_average = results[n]

            if last_average != 0.0 && actual_average != 0.0
                increment = ceil(((actual_average/last_average)-1)*100)
            else
                increment = 0.0
            end

            push!(lista_increments, increment)
        #else
        #    push!(lista_increments,0.0)
        end

        last_n = n
    end

    return lista_increments
end

function read_line_times(csv_line)
    values = split(csv_line, ";")
    n = first(values)
    average = last(values)

    n = parse(Int64,n)
    average = parse(Float64,average)

    [n, average]
end


function read_memory_times(csv_line)
    values = split(csv_line, ";")
    n = values[1]
    worst_allocated = values[2]

    n = parse(Int64,n)
    worst_allocated = parse(Int64,worst_allocated)

    [n, worst_allocated]
end


main(ARGS)
