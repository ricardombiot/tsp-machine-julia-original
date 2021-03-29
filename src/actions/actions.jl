module Actions
    using Main.PathsSet.Alias: Color, Km, ActionId, UniqueNodeKey
    using Main.PathsSet.Alias: Step, Km, Color, ActionId

    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph
    const DictOfGraphsByLenght = Dict{Step, Graph}
    const DictOfUpGraphsByLenght = Dict{Step, Dict{NodeId,Graph}}
    using Main.PathsSet.GeneratorIds

    mutable struct Action
        id :: ActionId

        km :: Km
        up_color :: Color

        props_parents :: Array{ActionId, 1}
        props_graph :: Union{DictOfGraphsByLenght, Nothing}
        props_up_graphs :: Union{DictOfUpGraphsByLenght, Nothing}
        max_length_graph :: Step
        # Is valid after add a valid graph
        valid :: Bool
    end


    function new(id :: ActionId, km :: Km, up_color :: Color, parents :: Array{ActionId, 1})
        props_graph = nothing
        props_up_graphs = nothing
        max_length_graph = Step(0)
        Action(id, km, up_color, parents, props_graph, props_up_graphs, max_length_graph, false)
    end

    function new_init(n :: Color, b :: Km, color_origin :: Color)

        km = Km(0)
        id = GeneratorIds.get_action_id(n, km, color_origin)

        max_length_graph = Step(0)
        parents = Array{ActionId, 1}()
        props_graph = nothing
        props_up_graphs = nothing

        action = Action(id, km, color_origin, parents, props_graph, props_up_graphs, max_length_graph, false)

        graph = PathGraph.new(n, b, color_origin, id)
        init_props_graphs!(action)
        push_graph_by_lenght!(action, graph)

        return action
    end

    function get_parents(action :: Action) :: Array{ActionId, 1}
        action.props_parents
    end

    function get_graph(action :: Action) :: Union{DictOfGraphsByLenght, Nothing}
        action.props_graph
    end

    function get_max_graph(action :: Action) :: Graph
        return action.props_graph[action.max_length_graph]
    end

    function get_up_graph(action :: Action, step :: Step, node_id :: NodeId) :: Graph
        return action.props_up_graphs[step][node_id]
    end

    function was_execute(action :: Action) :: Bool
        get_graph(action) != nothing
    end

    function init_props_graphs!(action :: Action)
        action.props_graph = DictOfGraphsByLenght()
        action.props_up_graphs = DictOfUpGraphsByLenght()
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

            # Desactivo para ahorrar memoria...
            #push_up_graph!(action, graph)
        end
    end

    function push_up_graph!(action :: Action, graph :: Graph)
        length = PathGraph.get_lenght(graph)
        if !haskey(action.props_up_graphs, length)
            action.props_up_graphs[length] = Dict{NodeId,Graph}()
        end

        node_id = PathGraph.get_last_id_node(graph)
        action.props_up_graphs[length][node_id] = deepcopy(graph)
    end

end
