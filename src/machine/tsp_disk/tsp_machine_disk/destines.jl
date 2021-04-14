
function send_destines!(machine :: TravellingSalesmanMachineDisk, origin :: Color)
    action = TableTimelineDisk.get_action_cell(machine.timeline, machine.db, machine.info.actual_km, origin)

    if action != nothing && action.valid
        parent_id = action.id
        km_destine_max = nothing
        for (destine, weight) in Graf.get_destines(machine.graf, origin)
            if is_valid_destine(machine, action, destine)

                #println("--> Destine $destine")
                km_destine = machine.info.actual_km + Km(weight)

                # Solo se enviará si puede ser solución optima
                if km_destine <= get_km_target(machine)
                    if km_destine_max == nothing
                        km_destine_max = km_destine
                    elseif km_destine > km_destine_max
                        km_destine_max = km_destine
                    end

                    TableTimelineDisk.push_parent!(machine.timeline, km_destine, destine, parent_id)
                    check_if_solution_recived(machine, destine, km_destine)
                end
            end
        end

        #if km_destine_max != nothing
            #DatabaseMemoryController.register!(machine.db_controller, action.id, km_destine_max)
        #end
    end
end

# Only can return to origin if some graph lenght is equal to N.
function check_if_solution_recived(machine :: TravellingSalesmanMachineDisk, destine :: Color, km_destine :: Km)
    if destine == machine.info.color_origin
        if machine.info.km_solution_recived != nothing
            machine.info.km_solution_recived = min(machine.info.km_solution_recived, km_destine)
        else
            machine.info.km_solution_recived = km_destine
        end
    end
end

function is_valid_destine(machine :: TravellingSalesmanMachineDisk, action :: Action, destine :: Color)
    if destine == machine.info.color_origin
        return action.max_length_graph == machine.info.n
    else
        return true
    end
end
