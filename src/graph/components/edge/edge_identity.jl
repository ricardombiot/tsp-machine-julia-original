module EdgeIdentity

    using Main.PathsSets.NodeIdentity: NodeId

    struct EdgeId
        origin_id :: NodeId
        destine_id :: NodeId
    end

    const EdgesIdSet = Set{EdgeId}

    function new(origin_id :: NodeId, destine_id :: NodeId)
        EdgeId(origin_id, destine_id)
    end

end
