
function send_destines!(machine :: TravellingSalesmanMachine, origin :: Color)
    action = TableTimeline.get_action_cell(machine.timeline, machine.db, machine.actual_km, origin)

    if action != nothing && action.valid
        parent_id = action.id
        km_destine_max = nothing
        for (destine, weight) in Graf.get_destines(machine.graf, origin)
            if is_valid_destine(machine, action, destine)
                km_destine = machine.actual_km + Km(weight)

                # Solo se enviará si puede ser solución optima
                if km_destine <= km_target(machine)
                    if km_destine_max == nothing
                        km_destine_max = km_destine
                    elseif km_destine > km_destine_max
                        km_destine_max = km_destine
                    end

                    TableTimeline.push_parent!(machine.timeline, km_destine, destine, parent_id)
                    check_if_solution_recived(machine, destine, km_destine)
                end
            end
        end

        if km_destine_max != nothing
            DatabaseMemoryController.register!(machine.db_controller, action.id, km_destine_max)
        end
    end
end

function is_valid_destine(machine :: TravellingSalesmanMachine, action :: Action, destine :: Color)
    if destine == machine.color_origin
        return action.max_length_graph == machine.n
    else
        return true
    end
end

# Only can return to origin if some graph lenght is equal to N.
function check_if_solution_recived(machine :: TravellingSalesmanMachine, destine :: Color, km_destine :: Km)
    if destine == machine.color_origin
        if machine.km_solution_recived != nothing
            machine.km_solution_recived = min(machine.km_solution_recived, km_destine)
        else
            machine.km_solution_recived = km_destine
        end
    end
end
