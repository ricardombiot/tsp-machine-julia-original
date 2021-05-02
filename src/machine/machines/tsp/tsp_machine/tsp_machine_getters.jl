function get_action(machine :: TravellingSalesmanMachine, action_id :: ActionId) :: Union{Action, Nothing}
    return DatabaseActions.get_action(machine.db, action_id)
end

function get_cell_origin(machine :: TravellingSalesmanMachine) :: Union{TimelineCell, Nothing}
    return TableTimeline.get_cell(machine.timeline, machine.actual_km, machine.color_origin)
end
