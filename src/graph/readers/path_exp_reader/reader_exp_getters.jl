function print_solutions(exp_solver :: PathSolutionExpReader)
    for path in exp_solver.paths_solution
        txt = PathReader.to_string_path(path)
        println(txt)
    end
end

function to_string_solutions(exp_solver :: PathSolutionExpReader) :: String
    txt = ""
    for path in exp_solver.paths_solution
        txt *= PathReader.to_string_path(path)
        txt *= "\n"
    end

    return txt
end

function to_string_solutions(exp_solver :: PathSolutionExpReader, map_names :: Dict{Color, String}) :: String
    txt = ""
    for path in exp_solver.paths_solution
        txt *= PathReader.to_string_path(path, map_names)
        txt *= "\n"
    end

    return txt
end

function get_total_solutions_found(exp_solver :: PathSolutionExpReader) :: UInt128
    return length(exp_solver.paths_solution)
end
