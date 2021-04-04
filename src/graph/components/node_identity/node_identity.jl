module NodeIdentity
    using Main.PathsSet.Alias: ActionId, Km, Color, UniqueNodeKey
    using Main.PathsSet.GeneratorIds

    struct NodeId
        key :: UniqueNodeKey
        action_id :: ActionId
        action_parent_id :: ActionId
    end

    const NodesIdSet = Set{NodeId}

    include("./node_id_constructor.jl")
    include("./node_id_info.jl")
    include("./node_id_getters.jl")

end
