function new(n :: Color, b :: Km, step :: Step, color :: Color, owners_graph :: OwnersByStep, action_id :: ActionId, action_parent_id :: Union{ActionId, Nothing} = nothing)
    node_id = NodeIdentity.new(n, b, action_id, action_parent_id)
    parents = Dict{NodeId, EdgeId}()
    sons = Dict{NodeId, EdgeId}()
    owners = Owners.derive(owners_graph)

    Node(node_id, action_id, color, step, parents, sons, owners)
end
