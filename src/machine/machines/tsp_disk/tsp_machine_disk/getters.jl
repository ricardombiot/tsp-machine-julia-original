function get_action(machine :: TravellingSalesmanMachineDisk, action_id :: ActionId) :: Union{Action, Nothing}
    return DatabaseActionsDisk.get_action(machine.db, action_id)
end

function get_cell_origin(machine :: TravellingSalesmanMachineDisk) :: Union{TimelineCell, Nothing}
    # la maquina de saltos saltará al paso ultimo
    return TableTimelineDisk.get_cell(machine.timeline, machine.info.actual_km, machine.info.color_origin)
end

function get_km_target(machine :: TravellingSalesmanMachineDisk)
    if machine.info.km_solution_recived == nothing
        return machine.info.km_b
    else
        return min(machine.info.km_solution_recived, machine.info.km_b)
    end
end
