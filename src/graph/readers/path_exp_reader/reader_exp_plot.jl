function is_plot_active(exp_solver :: PathSolutionExpReader) :: Bool
    exp_solver.dir != ""
end

function graph_plot(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader)
    if is_plot_active(exp_solver)
        if path.step > 3
            graphviz_plot(exp_solver, path)
        else
            println("Plot omited path.step < 3")
        end
    end
end

function graphviz_plot(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader)
    name_file = build_name_file_path(path)
    println("Plot [$name_file]")
    Graphviz.to_png(path.graph,"graph_$name_file",exp_solver.dir)
end

function build_name_file_path(path :: PathSolutionReader) :: String
    txt = ""
    for color in path.route
        txt *= "$color"
    end

    return txt
end
