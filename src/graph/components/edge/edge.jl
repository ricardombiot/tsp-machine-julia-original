module PathEdge
    using Main.PathsSet.Alias: Step

    using Main.PathsSet.Owners
    using Main.PathsSet.PathNode
    using Main.PathsSet.EdgeIdentity

    using Main.PathsSet.EdgeIdentity: EdgeId
    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathNode: Node
    using Main.PathsSet.Owners: OwnersByStep

    mutable struct Edge
        id :: EdgeId
        owners :: OwnersByStep
    end

    function new(origin_id :: NodeId, destine_id :: NodeId, owners_origin :: OwnersByStep) :: Edge
        id = EdgeIdentity.new(origin_id, destine_id)
        owners = Owners.derive(owners_origin)
        Edge(id, owners)
    end

    function build!(node_origin :: Node, node_destine :: Node) :: Edge
        PathNode.add_son!(node_origin, node_destine)
        PathNode.add_parent!(node_destine, node_origin)

        return new(node_origin.id, node_destine.id, node_origin.owners)
    end

    function push_owner!(edge :: Edge, node_owner :: Node)
        push_owner!(edge, node_owner.step, node_owner.id)
    end
    function push_owner!(edge :: Edge, step :: Step, node_id :: NodeId)
        Owners.push!(edge.owners, step, node_id)
    end

    function pop_owner!(edge :: Edge, node_owner :: Node)
        pop_owner!(edge, node_owner.step, node_owner.id)
    end
    function pop_owner!(edge :: Edge, step :: Step, node_id :: NodeId)
        Owners.pop!(edge.owners, step, node_id)
    end

    function have_owner(edge :: Edge, node_owner :: Node) :: Bool
        have_owner(edge, node_owner.step, node_owner.id)
    end
    function have_owner(edge :: Edge, step :: Step, node_id :: NodeId) :: Bool
        Owners.have(edge.owners, step, node_id)
    end

end
