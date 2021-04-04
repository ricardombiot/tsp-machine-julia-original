function new(n :: Color, b :: Km, action_id :: ActionId, action_parent_id :: Union{ActionId, Nothing} = nothing)
    if action_parent_id == nothing
        action_parent_id = action_id
    end
    key = calc_key(n, b, action_id, action_parent_id)
    NodeId(key, action_id, action_parent_id)
end
