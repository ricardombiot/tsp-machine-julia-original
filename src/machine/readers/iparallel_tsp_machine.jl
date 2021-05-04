function get_cell_origin(machine :: TravellingSalesmanMachineParallel) :: Union{TimelineCell, Nothing}
    return ParallelTSPMachine.get_cell_origin(machine)
end

function get_action(machine :: TravellingSalesmanMachineParallel, action_id :: ActionId) :: Union{Action, Nothing}
    return ParallelTSPMachine.get_action(machine, action_id)
end


function get_db(machine :: TravellingSalesmanMachineParallel) :: DBActions
    db_decorator = machine.db
    return db_decorator.db
end

function get_actual_km(machine :: TravellingSalesmanMachineParallel) :: Km
    return machine.actual_km
end

function get_color_origin(machine :: TravellingSalesmanMachineParallel) :: Color
    return machine.color_origin
end
