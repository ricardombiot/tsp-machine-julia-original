module ExecuteActions
    using Main.PathsSet.Alias: ActionId, ActionsIdSet
    using Main.PathsSet.PathGraph
    using Main.PathsSet.Actions
    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.DatabaseActionsDisk
    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions

    using Main.PathsSet.DatabaseActions: DBActions
    using Main.PathsSet.Actions: Action

    function run!(db :: IDBActions, id :: ActionId)
        action = DatabaseInterface.get_action(db, id)

        if action != nothing && !Actions.was_execute(action)
            Actions.init_props_graphs!(action)
            reduce_map_up_parents!(db, action)
            DatabaseInterface.finished_execution!(db, action)
        end
    end

    function reduce_map_up_parents!(db :: IDBActions, action :: Action)
        parents = Actions.get_parents(action)
        up_color = action.up_color

        # $ O(N) $
        for parent_id in parents
            action_parent = DatabaseInterface.get_action(db, parent_id)

            if Actions.was_execute(action_parent)
                dict_graphs = Actions.get_graph(action_parent)

                # $ O(N) $
                for (lenght, graph_parent) in dict_graphs
                    copy_graph = deepcopy(graph_parent)

                    # $ O(N^10) $
                    PathGraph.up!(copy_graph, up_color, action.id)

                    if copy_graph.valid
                        Actions.push_graph_by_lenght!(action, copy_graph)
                    end
                end
            end
        end
    end

end
