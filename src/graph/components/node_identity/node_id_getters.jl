function is_root(node_id :: NodeId) :: Bool
    node_id.action_id == node_id.action_parent_id
end

function to_string(node_id :: NodeId, point :: String = ".") :: String
    #=
    if is_root(node_id)
        return "K$(node_id.key)$(point)$(node_id.action_id)$(point)Rt"
    else
        return "K$(node_id.key)$(point)$(node_id.action_id)$(point)$(node_id.action_parent_id)"
    end
    =#

    if is_root(node_id)
        return "K$(node_id.key)"
    else
        return "K$(node_id.key)"
    end
end
