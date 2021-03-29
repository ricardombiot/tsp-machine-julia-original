module HalSolver
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    using Main.PathsSet.HalMachine
    using Main.PathsSet.HalMachine: HamiltonianMachine
    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.Actions
    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    function solve_one_solution(graf :: Grafo, color_origin :: Color = Color(0)) :: Union{Nothing, Graph}
        machine = HalMachine.new(graf, color_origin)
        execute!(machine)
        return get_one_solution_graph(machine)
    end

    function get_one_solution_graph(machine :: HamiltonianMachine) :: Union{Nothing, Graph}
        cell_origin = HalMachine.get_cell_origin(machine)
        parents = cell_origin.parents

        if isempty(parents)
            return nothing
        else
            parent_1 = first(parents)
            action_solution = HalMachine.get_action(machine, parent_1)
            graph = Actions.get_max_graph(action_solution)

            return graph
        end
    end

    function get_all_solution_graph(machine :: HamiltonianMachine) :: Array{Tuple{ActionId,Graph},1}

        list_graph = Array{Tuple{ActionId,Graph},1}()
        cell_origin = HalMachine.get_cell_origin(machine)
        if cell_origin != nothing
            parents = cell_origin.parents

            for parent_id in parents
              action_solution = HalMachine.get_action(machine, parent_id)
              graph = Actions.get_max_graph(action_solution)

              push!(list_graph, (parent_id, graph))
            end
        end

        return sort(list_graph)
    end

    function get_all_actions_graph(machine :: HamiltonianMachine) :: Array{Tuple{ActionId,Union{Graph, Nothing}},1}

        list_graphs = Array{Tuple{ActionId,Union{Graph, Nothing}},1}()
        for (action_id, action) in machine.db.table
            if action.valid
                graph = Actions.get_max_graph(action)

                push!(list_graphs, (action_id, graph))
            else
                push!(list_graphs, (action_id, nothing))
            end
       end

       return sort(list_graphs)
    end

    function get_graph_join_origin(machine :: HamiltonianMachine) :: Union{Graph, Nothing}
        color_origin = machine.color_origin
        action_id = DatabaseActions.generate_action_id(machine.db, machine.actual_km+1, machine.color_origin)

        graph_join = nothing

        for (parent_id, graph_solution) in get_all_solution_graph(machine)
            copy_graph_solution = deepcopy(graph_solution)
            #PathGraph.up!(copy_graph_solution, color_origin, action_id)

            ## Without delete origin
            PathGraph.make_up!(copy_graph_solution, color_origin, action_id)
            if copy_graph_solution.valid
                if graph_join == nothing
                    graph_join = copy_graph_solution
                else
                    PathGraph.join!(graph_join, copy_graph_solution)
                end
            end
        end

        return graph_join
    end



end
