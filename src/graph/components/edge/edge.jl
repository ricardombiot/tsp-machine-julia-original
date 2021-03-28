module PathEdge

    using Main.PathsSets.EdgeIdentity: EdgesId
    using Main.PathsSet.Owners: OwnersByStep

    mutable struct Edge
        id :: EdgeId
        owners :: OwnersByStep
    end

    # dar owners
    function new(origin_id :: NodeId, destine_id :: NodeId, owners_origin :: OwnersByStep)
        id = EdgeIdentity.new(origin_id, destine_id)
        owners = Owners.derive(owners_origin)
        Edge(id, owners)
    end

end
