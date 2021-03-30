function calc!(exp_solver :: PathSolutionExpReader)
    if make_step!(exp_solver)
        calc!(exp_solver)
    end
end

function make_step!(exp_solver :: PathSolutionExpReader) :: Bool
    exp_solver.step += 1
    next_solvers = Array{PathSolutionReader,1}()
    recursive_pop!(exp_solver, next_solvers)

    is_finished = isempty(exp_solver.paths_solvers)

    return !is_finished
end


function recursive_pop!(exp_solver :: PathSolutionExpReader, next_solvers :: Array{PathSolutionReader,1})
    if !isempty(exp_solver.paths_solvers)
        path = pop!(exp_solver.paths_solvers)

        if path.step < exp_solver.step
            update_path = make_next!(exp_solver, path)
            if update_path != nothing
                push!(next_solvers, update_path)
            end
        end
        recursive_pop!(exp_solver, next_solvers)
    else
        exp_solver.paths_solvers = next_solvers
    end
end

function make_next!(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader) :: Union{PathSolutionReader, Nothing}
    copy_path = deepcopy(path)

    PathReader.next_step!(path)
    if PathReader.is_finished(path)
        push!(exp_solver.paths_solution, path)
        return nothing
    else
        if path.graph.valid && path.next_node_id != nothing
            derive(exp_solver, path, copy_path)
            return path
        else
            println("no valid")
            exp_solver.limit += 1
            return nothing
        end
    end
end

function derive(exp_solver :: PathSolutionExpReader, path :: PathSolutionReader, copy_path :: PathSolutionReader)
    if exp_solver.limit > 0
        selected_node_id = path.next_node_id
        # borramos el nodo para que no pueda volver a selecionarlo
        PathGraph.save_to_delete_node!(copy_path.graph, selected_node_id)
        PathGraph.apply_node_deletes!(copy_path.graph)

        PathReader.clear_graph_by_owners!(copy_path)
        #PathGraph.apply_node_deletes!(copy_path.graph)
        #PathGraph.review_owners_all_graph!(copy_path.graph)
        # Si llegamos aqui sabemos que tenemos un paso más por lo tanto tiene que poder
        # selecionar siguiente.
        if can_selected_next(copy_path)
            push!(exp_solver.paths_solvers, copy_path)

            exp_solver.limit -= 1
            println("Create derive... $(exp_solver.limit)")
        end
    end
end


function can_selected_next(copy_path :: PathSolutionReader) :: Bool
    if copy_path.graph.valid
        node = PathGraph.get_node(copy_path.graph, copy_path.next_node_id)
        if node != nothing
            next_selection = PathReader.selected_next(copy_path, node)
            if next_selection != nothing
                exist_node = PathGraph.get_node(copy_path.graph, next_selection)
                return exist_node != nothing
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end
