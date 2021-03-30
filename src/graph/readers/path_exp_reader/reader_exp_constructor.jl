function new(n :: Color, b :: Km, graph :: Graph, limit :: UInt128 , is_origin_join :: Bool = false)
    step = Step(0)
    paths_solvers = Array{PathSolutionReader,1}()
    paths_solution = Array{PathSolutionReader,1}()

    exp_solver = PathSolutionExpReader(n, b, step, limit, paths_solvers, paths_solution, is_origin_join)
    init_generar_paths_semillas!(exp_solver, graph)

    return exp_solver
end

function init_generar_paths_semillas!(exp_solver :: PathSolutionExpReader, graph :: Graph)
    if exp_solver.limit > 0
        solver_semilla = PathReader.new(exp_solver.n, exp_solver.b, graph, exp_solver.is_origin_join)
        push!(exp_solver.paths_solvers, solver_semilla)
        exp_solver.limit-= 1
    end
end
