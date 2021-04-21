function execute!(machine :: TravellingSalesmanMachine)
    if make_step!(machine)
        km_halt = km_target(machine)
        #println("#KM: $(machine.actual_km)/$(km_halt)")
        execute!(machine)
    end
end

function make_step!(machine :: TravellingSalesmanMachine) :: Bool
    if !rules_to_halt_machine(machine)
        execute_line!(machine)
        free_memory!(machine)
        machine.actual_km += Km(1)
        return true
    else
        return false
    end
end

function free_memory!(machine :: TravellingSalesmanMachine)
    if machine.actual_km > 1
        clear_km = machine.actual_km - 1
        DatabaseMemoryController.free_memory_actions_step!(machine.db_controller, clear_km, machine.db)
        TableTimeline.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end

function rules_to_halt_machine(machine :: TravellingSalesmanMachine) :: Bool
    km_to_halt = km_target(machine)
    return km_to_halt == machine.actual_km
end

function km_target(machine :: TravellingSalesmanMachine) :: Km
    if machine.km_solution_recived == nothing
        return machine.km_b
    else
        return min(machine.km_solution_recived, machine.km_b)
    end
end

function execute_line!(machine :: TravellingSalesmanMachine)
    line = TableTimeline.get_line(machine.timeline, machine.actual_km)
    if line != nothing
        for (origin, cell) in line
            (is_valid, action_id) = TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)

            #println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
            if is_valid
                 send_destines!(machine, origin)
            else
                # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                DatabaseMemoryController.register!(machine.db_controller, action_id, machine.actual_km)
            end
        end
    end
end
