function execute!(machine :: HamiltonianMachine)
    # Hamiltonian: $ O(N) $
    # TSP: $ O(B) $
    if make_step!(machine)
        #println("#KM: $(machine.actual_km)/$(machine.n)")
        execute!(machine)
    end
end

function make_step!(machine :: HamiltonianMachine) :: Bool
    if machine.actual_km < machine.n
        execute_line!(machine :: HamiltonianMachine)
        free_memory!(machine)
        machine.actual_km += Km(1)
        return true
    else
        return false
    end
end

function execute_line!(machine :: HamiltonianMachine)
    line = TableTimeline.get_line(machine.timeline, machine.actual_km)
    if line != nothing
        # $ O(N) $
        for (origin, cell) in line
            if is_valid_origin(machine, origin)
                # Hamiltonian: $ O(N^11) $
                # TSP: $ O(N^12) $
                (is_valid, action_id) = TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)
                #println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
                if is_valid
                     send_destines!(machine, origin)
                end
            end
        end
    end
end


function is_valid_origin(machine :: HamiltonianMachine, origin :: Color) :: Bool
    ## En el ultimo caso solo calculo si tiene como destine color_origin
    if Km(machine.actual_km) == Km(machine.n-1)
        have_arista_to_origin = Graf.have_arista(machine.graf, origin,  machine.color_origin)
        #println("# Before end check origin: $origin ($have_arista_to_origin)")
        return have_arista_to_origin
    else
        return true
    end
end


function free_memory!(machine :: HamiltonianMachine)
    if machine.actual_km > 1
        clear_km = machine.actual_km - Km(1)
        DatabaseMemoryController.free_memory_actions_step!(machine.db_controller, clear_km, machine.db)
        TableTimeline.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end
