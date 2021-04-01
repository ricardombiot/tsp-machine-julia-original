function calc!(exp_solver :: PathSolutionExpReader)
    if make_step!(exp_solver)
        calc!(exp_solver)
    end
end

function make_step!(exp_solver :: PathSolutionExpReader) :: Bool
    next_solvers = Array{PathSolutionReader,1}()
    recursive_pop!(exp_solver, next_solvers)

    is_finished = isempty(exp_solver.paths_solvers)

    exp_solver.step += 1
    return !is_finished
end

function recursive_pop!(exp_solver :: PathSolutionExpReader, next_solvers :: Array{PathSolutionReader,1})
    if !isempty(exp_solver.paths_solvers)
        path = pop!(exp_solver.paths_solvers)
        if path.next_node_id != nothing
            derive_path_next_step!(exp_solver, path, next_solvers)
        else
            push!(exp_solver.paths_solution, path)
        end

        recursive_pop!(exp_solver, next_solvers)
    else
        exp_solver.paths_solvers = next_solvers
    end
end


function derive_path_next_step!(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader, next_solvers :: Array{PathSolutionReader,1})
    PathReader.push_step!(path)
    copy_path = deepcopy(path)

    if path.graph.valid
        if exp_solver.limit > 0
            derive_fixed_next!(exp_solver, path, next_solvers)
        else
            PathReader.fixed_next!(path)
            PathReader.clear_graph_by_owners!(path)
            push!(next_solvers, path)
        end
    else
        println("Not valid graph")
        graph_plot(exp_solver, copy_path)
    end
end

function derive_fixed_next!(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader, next_solvers :: Array{PathSolutionReader,1})

    node = PathGraph.get_node(path.graph, path.next_node_id)
    sons = deepcopy(node.sons)
    if !isempty(sons)
        total_sons = 0
        for (node_id, edge_id) in sons
            copy_path = deepcopy(path)
            copy_path.next_node_id = node_id

            PathReader.clear_graph_by_owners!(copy_path)
            if is_valid_selection(copy_path)
                push!(next_solvers, copy_path)
            else
                println("After clear graph not valid")
                graph_plot(exp_solver, copy_path)
            end

            total_sons += 1
        end

        update_limit(exp_solver, total_sons)
    else
        path.next_node_id = nothing
        push!(next_solvers, path)
    end
end


function is_valid_selection(copy_path :: PathSolutionReader ) :: Bool
    node = PathGraph.get_node(copy_path.graph, copy_path.next_node_id)

    exist_selection = node != nothing
    return copy_path.graph.valid && exist_selection
end


function update_limit(exp_solver :: PathSolutionExpReader, total_sons :: Int64)

    if total_sons > exp_solver.limit
        if exp_solver.limit == 1
            son  = first(sons)
            sons = [son]

            exp_solver.limit -= 1
        else
            limit = Int64(exp_solver.limit)
            sons = sons[1:limit]

            exp_solver.limit = UInt128(0)
        end
    else
        exp_solver.limit -= (total_sons-1)
    end

end
