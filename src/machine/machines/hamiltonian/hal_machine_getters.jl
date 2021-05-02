function get_action(machine :: HamiltonianMachine, action_id :: ActionId) :: Union{Action, Nothing}
    return DatabaseActions.get_action(machine.db, action_id)
end

function get_cell_origin(machine :: HamiltonianMachine) :: Union{TimelineCell, Nothing}
    return TableTimeline.get_cell(machine.timeline, machine.actual_km, machine.color_origin)
end
