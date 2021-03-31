function print_solutions(exp_solver :: PathSolutionExpReader)
    for path in exp_solver.paths_solution
        txt = PathReader.print_path(path)
        println(txt)
    end
end

function get_total_solutions_found(exp_solver :: PathSolutionExpReader) :: UInt128
    return length(exp_solver.paths_solution)
end
