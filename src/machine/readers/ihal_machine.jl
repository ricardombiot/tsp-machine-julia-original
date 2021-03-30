function get_cell_origin(machine :: HamiltonianMachine) :: Union{TimelineCell, Nothing}
    return HalMachine.get_cell_origin(machine)
end

function get_action(machine :: HamiltonianMachine, action_id :: ActionId) :: Union{Action, Nothing}
    return HalMachine.get_action(machine, action_id)
end


function get_db(machine :: HamiltonianMachine) :: DBActions
    return machine.db
end

function get_actual_km(machine :: HamiltonianMachine) :: Km
    return machine.actual_km
end

function get_color_origin(machine :: HamiltonianMachine) :: Color
    return machine.color_origin
end
