function execute!(machine :: TravellingSalesmanMachineDisk)
    if !machine.info.finished && make_step!(machine)
        km_halt = get_km_target(machine)
        println("#KM: $(machine.info.actual_km)/$(km_halt)")

        if !have_secure_partial_stop(machine)
            execute!(machine)
        end
    end
end

function rules_to_halt_machine(machine :: TravellingSalesmanMachineDisk) :: Bool
    km_to_halt = get_km_target(machine)
    # la maquina de saltos tiene no tiene que procesar soluciones
    #return km_to_halt-1 == machine.info.actual_km
    return km_to_halt == machine.info.actual_km
end

function make_step!(machine :: TravellingSalesmanMachineDisk) :: Bool
    if !rules_to_halt_machine(machine)
        calc_line!(machine)
        free_memory!(machine)
        TSPMachineInfoDisk.jump!(machine.info)
        #machine.info.actual_km += Km(1)
        save_info!(machine)

        #return true
        return !machine.info.finished
    else
        machine.info.finished = true
        save_info!(machine)
        return false
    end
end

function calc_line!(machine :: TravellingSalesmanMachineDisk)
    execute_line!(machine)
end

function execute_line!(machine :: TravellingSalesmanMachineDisk)
    line = TableTimelineDisk.get_line(machine.timeline, machine.info.actual_km)
    if line != nothing
        for origin in line

            (is_valid, action_id) = TableTimelineDisk.execute!(machine.timeline, machine.db, machine.info.actual_km, origin)
            println("Execute KM:$(machine.info.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
            if is_valid
                 send_destines!(machine, origin)
            else
                # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                register_action_to_clean!(machine, machine.info.actual_km, action_id)
            end
            #end
        end
    end
end


function have_secure_partial_stop(machine :: TravellingSalesmanMachineDisk) :: Bool
    path = "$(machine.path)/stop"
    return isfile(path)
end
