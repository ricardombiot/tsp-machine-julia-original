function calc_and_plot!(path :: PathSolutionReader, dir :: String)
    if next_step!(path)
        graphviz_plot(path, dir)
        calc_and_plot!(path, dir)
    else
        close_path!(path)
    end
end


function graphviz_plot(path :: PathSolutionReader, dir :: String)
    name_file = build_name_file_path(path)
    println("Plot [$name_file]")
    Graphviz.to_png(path.graph, "graph_$name_file", dir)
    println("--> After plot")
end

function build_name_file_path(path :: PathSolutionReader) :: String
    txt = ""
    for color in path.route
        txt *= "$color"
    end

    return txt
end
