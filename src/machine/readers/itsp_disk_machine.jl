function get_cell_origin(machine :: TravellingSalesmanMachineDisk) :: Union{TimelineCell, Nothing}
    return TSPMachineDisk.get_cell_origin(machine)
end

function get_action(machine :: TravellingSalesmanMachineDisk, action_id :: ActionId) :: Union{Action, Nothing}
    return TSPMachineDisk.get_action(machine, action_id)
end


function get_db(machine :: TravellingSalesmanMachineDisk) :: DBActions
    return DBActions(machine.db)
end

function get_actual_km(machine :: TravellingSalesmanMachineDisk) :: Km
    return machine.info.actual_km
end

function get_color_origin(machine :: TravellingSalesmanMachineDisk) :: Color
    return machine.info.color_origin
end
