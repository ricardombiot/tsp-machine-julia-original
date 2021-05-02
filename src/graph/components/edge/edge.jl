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
    end

    function new(origin_id :: NodeId, destine_id :: NodeId) :: Edge
        id = EdgeIdentity.new(origin_id, destine_id)
        Edge(id)
    end

    function build!(node_origin :: Node, node_destine :: Node) :: Edge
        PathNode.add_son!(node_origin, node_destine)
        PathNode.add_parent!(node_destine, node_origin)

        return new(node_origin.id, node_destine.id)
    end

    function destroy!(node_origin :: Node, node_destine :: Node)
        PathNode.delete_son!(node_origin, node_destine)
        PathNode.delete_parent!(node_destine, node_origin)
    end

end
