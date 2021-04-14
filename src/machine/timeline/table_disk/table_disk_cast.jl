
function cast_dir_color_to_color(dir_color :: String) :: Color
    txt_color = replace(dir_color, "color" => "")
    color = parse(Color,txt_color)

    return color
end

function cast_file_parent_id_to_action_id(file_id :: String) :: ActionId
    file_id = replace(file_id, ".txt" => "")
    file_id = replace(file_id, "parent_" => "")
    action_id = parse(ActionId, file_id)
    return action_id
end


#=
function cast_file_action_id_to_action_id(file_id :: String) :: ActionId
    file_id = replace(file_id, ".txt" => "")
    file_id = replace(file_id, "action_id_" => "")
    action_id = parse(ActionId, file_id)
    return action_id
end
=#
