function get_path_km(timeline :: TimelineDisk, km :: Km) :: String
    "$(timeline.path)/timeline/km$(km)"
end

function get_path_cell(timeline :: TimelineDisk, km :: Km, color :: Color) :: String
    "$(timeline.path)/timeline/km$(km)/color$(color)"
end

function get_path_cell_parents(timeline :: TimelineDisk, km :: Km, color :: Color) :: String
    "$(timeline.path)/timeline/km$(km)/color$(color)/parents"
end

#=
function get_path_cell_action_id(timeline :: TimelineDisk, km :: Km, color :: Color) :: String
    "$(timeline.path)/timeline/km$(km)/color$(color)/action_id"
end
=#
