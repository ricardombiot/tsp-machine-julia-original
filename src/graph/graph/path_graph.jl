module PathGraph
    using Main.PathsSet.Alias: Color, SetColors, Km, Step, UniqueNodeKey, ActionId

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
        # N of nodes
        n :: Color
        # max km target (B)
        b :: Km
        # Next step (length of step)
        next_step :: Step
        # Color origin (node origin)
        color_origin :: Color
        # Owners of graph
        owners :: OwnersByStep

        # dictionary of nodes by actionid and node id
        table_nodes :: Dict{ActionId, Dict{NodeId, Node}}
        # dictionary of edges by edge id
        table_edges :: Dict{EdgeId, Edge}
        # dictionary of node id by line
        table_lines :: Dict{Step, NodesIdSet}
        # dictionary of node id by color
        table_color_nodes :: Dict{Color, NodesIdSet}

        # save the parent action id
        action_parent_id :: Union{ActionId, Nothing}
        # temporal set of nodes id that should be delete
        nodes_to_delete :: NodesIdSet
        # flag that say if is required make a review of owners
        required_review_ownwers :: Bool
        # flag that say if the graph is valid
        valid :: Bool
    end

    include("./graph_constructor.jl")
    include("./graph_init.jl")
    include("./graph_lines.jl")
    include("./graph_nodes.jl")
    include("./graph_add_node.jl")
    include("./graph_owners_review.jl")
    include("./graph_edge.jl")
    include("./graph_make_up.jl")
    include("./graph_delete.jl")
    include("./graph_delete_edge.jl")
    include("./graph_delete_node.jl")
    include("./graph_join.jl")
    include("./graph_getters.jl")
    include("./graph_log.jl")

    include("./graph_owners_colors_review.jl")

end
