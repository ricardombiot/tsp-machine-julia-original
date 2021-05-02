module SubsetSumSolver
    using Main.PathsSet.Alias: Km, Step

    using Main.PathsSet.SubsetSumProgram
    using Main.PathsSet.SubsetSumMachine
    using Main.PathsSet.SubsetSumMachine: SumMachine

    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.PathReader

    function get_all_solution_graphs(machine :: SumMachine) :: Array{Graph, 1}
        solution_graphs = Array{Graph, 1}()
        for (km, list_graphs) in machine.program.table_graphs_solutions
            solution_graphs = [solution_graphs; list_graphs]
        end

        return solution_graphs
    end

    # Gets the graphs with the maximum number of items
    function get_longest_solutions_graphs(machine :: SumMachine) :: Array{Graph, 1}
        if SubsetSumMachine.have_solution(machine)
            length_max = maximum(keys(machine.program.table_graphs_solutions))
            return machine.program.table_graphs_solutions[length_max]
        else
            return Array{Graph, 1}()
        end
    end

    function get_one_subset_solution(machine :: SumMachine) :: Union{Array{Int64,1}, Nothing}
        list_graphs = get_all_solution_graphs(machine)

        if !isempty(list_graphs)
            graph = pop!(list_graphs)
            return get_subset_solution_of_graph(machine, graph)
        else
            return nothing
        end
    end

    function get_subset_solution_of_graph(machine :: SumMachine, graph :: Graph) :: Array{Int64,1}
        graph = deepcopy(graph)
        path = PathReader.read!(machine.n, machine.max_b, graph, false)
        return SubsetSumProgram.get_route_original_values(machine.program, path.route)
    end

end
