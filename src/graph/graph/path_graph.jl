module PathGraph

    using Main.PathsSet.Owners: OwnersByStep
    using Main.PathsSets.NodeIdentity: NodeId, NodesIdSet

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
        table_color_nodes :: Dict{Color,NodesIdSet}

        action_parent_id :: Union{ActionId, Nothing}
        nodes_to_delete :: NodesIdSet

        valid :: Bool
    end

    include("./graph_constructor.jl")
    include("./graph_lines.jl")


end
