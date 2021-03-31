module Actions
    using Main.PathsSet.Alias: Step, Color, Km, ActionId, UniqueNodeKey, SetActions

    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.GeneratorIds

    const DictOfGraphsByLenght = Dict{Step, Graph}

    mutable struct Action
        id :: ActionId

        km :: Km
        up_color :: Color

        props_parents :: SetActions
        props_graph :: Union{DictOfGraphsByLenght, Nothing}
        max_length_graph :: Step
        # Is valid after add a valid graph
        valid :: Bool
    end


    function new(id :: ActionId, km :: Km, up_color :: Color, parents :: SetActions)
        props_graph = nothing
        max_length_graph = Step(0)
        Action(id, km, up_color, parents, props_graph, max_length_graph, false)
    end

    function new_init(n :: Color, b :: Km, color_origin :: Color)

        km = Km(0)
        id = GeneratorIds.get_action_id(n, km, color_origin)

        max_length_graph = Step(0)
        parents = SetActions()
        props_graph = nothing

        action = Action(id, km, color_origin, parents, props_graph, max_length_graph, false)

        graph = PathGraph.new(n, b, color_origin, id)
        init_props_graphs!(action)
        push_graph_by_lenght!(action, graph)

        return action
    end

    function get_parents(action :: Action) :: SetActions
        action.props_parents
    end

    function get_graph(action :: Action) :: Union{DictOfGraphsByLenght, Nothing}
        action.props_graph
    end

    function get_max_graph(action :: Action) :: Graph
        return action.props_graph[action.max_length_graph]
    end

    function was_execute(action :: Action) :: Bool
        get_graph(action) != nothing
    end

    function init_props_graphs!(action :: Action)
        action.props_graph = DictOfGraphsByLenght()
    end

    function push_graph_by_lenght!(action :: Action, graph :: Graph)
        if graph.valid
            action.valid = true
            length = PathGraph.get_lenght(graph)

            if length > action.max_length_graph
                action.max_length_graph = length
            end

            if haskey(action.props_graph, length)
                actual_graph = action.props_graph[length]
                PathGraph.join!(actual_graph, graph)
            else
                action.props_graph[length] = graph
            end
        end
    end

end
