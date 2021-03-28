module PathNode
    using Main.PathsSets.Alias: ActionId, Step, Color

    using Main.PathsSets.NodeIdentity: NodeId
    using Main.PathsSets.EdgeIdentity: EdgesIdSet

    using Main.PathsSet.Owners: OwnersByStep

    mutable struct Node
        id :: NodeId
        action_id :: ActionId
        color :: Color
        step :: Step

        parents :: EdgesIdSet
        sons :: EdgesIdSet

        owners :: OwnersByStep
    end

    function new(n :: Color, b :: Km, step :: Step, color :: Color, owners_graph :: OwnersByStep, action_id :: ActionId, action_parent_id :: Union{ActionId, Nothing} = nothing)
        node_id = NodeIdentity.new(n, b, action_id, action_parent_id)
        parents = EdgesIdSet()
        sons = EdgesIdSet()
        owners = Owners.derive(owners_graph)

        Node(node_id, action_id, color, step, parents, sons, owners)
    end


end
