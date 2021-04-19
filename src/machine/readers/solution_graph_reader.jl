module SolutionGraphReader
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    using Main.PathsSet.InterfaceMachine
    using Main.PathsSet.InterfaceMachine: IMachine
    using Main.PathsSet.DatabaseInterface

    #using Main.PathsSet.DatabaseActions
    using Main.PathsSet.Actions
    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    function get_one_solution_graph(machine :: IMachine) :: Union{Nothing, Graph}
        cell_origin = InterfaceMachine.get_cell_origin(machine)
        parents = cell_origin.parents

        if isempty(parents)
            return nothing
        else
            parent_1 = first(parents)
            action_solution = InterfaceMachine.get_action(machine, parent_1)
            graph = Actions.get_max_graph(action_solution)

            return graph
        end
    end

    function get_all_solution_graph(machine :: IMachine) :: Array{Tuple{ActionId,Graph},1}

        list_graph = Array{Tuple{ActionId,Graph},1}()
        cell_origin = InterfaceMachine.get_cell_origin(machine)
        if cell_origin != nothing
            parents = cell_origin.parents

            for parent_id in parents
              action_solution = InterfaceMachine.get_action(machine, parent_id)
              graph = Actions.get_max_graph(action_solution)

              push!(list_graph, (parent_id, graph))
            end
        end

        return sort(list_graph)
    end

    function get_graph_join_origin(machine :: IMachine) :: Union{Graph, Nothing}
        db = InterfaceMachine.get_db(machine)
        actual_km = InterfaceMachine.get_actual_km(machine)
        color_origin = InterfaceMachine.get_color_origin(machine)

        action_id = DatabaseInterface.generate_action_id(db, actual_km+1, color_origin)

        graph_join = nothing

        for (parent_id, graph_solution) in get_all_solution_graph(machine)
            copy_graph_solution = deepcopy(graph_solution)

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
