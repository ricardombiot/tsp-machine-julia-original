module PathNode
    using Main.PathsSet.Alias: ActionId, Step, Color, Km

    using Main.PathsSet.NodeIdentity
    using Main.PathsSet.EdgeIdentity
    using Main.PathsSet.Owners

    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.EdgeIdentity: EdgeId
    using Main.PathsSet.Owners: OwnersByStep

    mutable struct Node
        id :: NodeId
        action_id :: ActionId
        color :: Color
        step :: Step

        parents :: Dict{NodeId, EdgeId}
        sons :: Dict{NodeId, EdgeId}

        owners :: OwnersByStep
    end

    include("./node_constructor.jl")
    include("./node_parents_and_sons_methods.jl")
    include("./node_owners_methods.jl")
    include("./node_join.jl")
    include("./node_getters.jl")


end
