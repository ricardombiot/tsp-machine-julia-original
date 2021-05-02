function get_cell_origin(machine :: TravellingSalesmanMachine) :: Union{TimelineCell, Nothing}
    return TSPMachine.get_cell_origin(machine)
end

function get_action(machine :: TravellingSalesmanMachine, action_id :: ActionId) :: Union{Action, Nothing}
    return TSPMachine.get_action(machine, action_id)
end


function get_db(machine :: TravellingSalesmanMachine) :: DBActions
    return machine.db
end

function get_actual_km(machine :: TravellingSalesmanMachine) :: Km
    return machine.actual_km
end

function get_color_origin(machine :: TravellingSalesmanMachine) :: Color
    return machine.color_origin
end
