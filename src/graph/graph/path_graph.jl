module PathGraph
    using Main.PathsSet.Alias: Color, Km, Step, UniqueNodeKey, ActionId

    using Main.PathsSet.PathEdge
    using Main.PathsSet.PathNode
    using Main.PathsSet.Owners
    using Main.PathsSet.EdgeIdentity

    using Main.PathsSet.Owners: OwnersByStep
    using Main.PathsSet.NodeIdentity: NodeId, NodesIdSet
    using Main.PathsSet.EdgeIdentity: EdgeId

    using Main.PathsSet.PathEdge: Edge
    using Main.PathsSet.PathNode: Node

    mutable struct Graph
        n :: Color
        b :: Km
        next_step :: Step
        color_origin :: Color
        owners :: OwnersByStep

        table_nodes :: Dict{ActionId, Dict{NodeId, Node}}

        table_edges :: Dict{EdgeId, Edge}

        table_lines :: Dict{Step, NodesIdSet}
        ## Para cada color guardamos un set de nodos que lo usan
        table_color_nodes :: Dict{Color, NodesIdSet}

        action_parent_id :: Union{ActionId, Nothing}
        nodes_to_delete :: NodesIdSet

        valid :: Bool
    end

    include("./graph_constructor.jl")
    include("./graph_lines.jl")
    include("./graph_nodes.jl")
    include("./graph_owners.jl")
    include("./graph_edge.jl")
    include("./graph_make_up.jl")
    include("./graph_delete.jl")


end
