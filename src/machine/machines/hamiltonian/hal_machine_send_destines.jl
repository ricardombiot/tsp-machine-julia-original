function send_destines!(machine :: HamiltonianMachine, origin :: Color)
    action = TableTimeline.get_action_cell(machine.timeline, machine.db, machine.actual_km, origin)

    if action != nothing && action.valid
        parent_id = action.id
        km_destine_max = nothing
        # $ O(N) $
        for (destine, weight) in Graf.get_destines(machine.graf, origin)
            if is_valid_destine(machine, action, destine)
                #println("--> Destine $destine")
                km_destine = machine.actual_km + Km(weight)

                if km_destine_max == nothing
                    km_destine_max = km_destine
                elseif km_destine > km_destine_max
                    km_destine_max = km_destine
                end

                TableTimeline.push_parent!(machine.timeline, km_destine, destine, parent_id)
            end
        end

        if km_destine_max != nothing
            DatabaseMemoryController.register!(machine.db_controller, action.id, km_destine_max)
        end
    end
end

function is_valid_destine(machine :: HamiltonianMachine, action :: Action, destine :: Color)
    if destine == machine.color_origin
        return action.max_length_graph == machine.n
    else
        return true
    end
end
