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
    return km_to_halt == machine.info.actual_km
end

function make_step!(machine :: TravellingSalesmanMachineDisk) :: Bool
    if !rules_to_halt_machine(machine)
        calc_line!(machine)
        free_memory!(machine)
        TSPMachineInfoDisk.jump!(machine.info)
        save_info!(machine)

        #return !machine.info.finished
        return true
    else
        machine.info.finished = true
        save_info!(machine)
        return false
    end
end

function calc_line!(machine :: TravellingSalesmanMachineDisk)
    if machine.parallel
        execute_line_parallel!(machine)
    else
        execute_line!(machine)
    end
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
        end
    end
end


function execute_line_parallel!(machine :: TravellingSalesmanMachineDisk)
    line = TableTimelineDisk.get_line(machine.timeline, machine.info.actual_km)
    if line != nothing
        results = Array{Tuple{Bool, Color, ActionId}, 1}()

        Threads.@threads for origin in line
            id = Threads.threadid()
            total_th = Threads.nthreads()
            (is_valid, action_id) = TableTimelineDisk.execute!(machine.timeline, machine.db, machine.info.actual_km, origin)
            #println("Thr.Id:$id/$total_th - Execute KM:$(machine.info.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
            result_tuple :: Tuple{Bool, Color, ActionId} = (is_valid, origin, action_id)
            push!(results, result_tuple)
        end


        for (is_valid, origin, action_id) in results
            if is_valid
                 send_destines!(machine, origin)
            else
                # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                register_action_to_clean!(machine, machine.info.actual_km, action_id)
            end
        end
    end
end

#=
function execute_line_parallel!(machine :: TravellingSalesmanMachineDisk)
    line = TableTimelineDisk.get_line(machine.timeline, machine.info.actual_km)
    if line != nothing
        global lock_key = Threads.Condition()
        global semaphore = Base.Semaphore(1)
        c = Threads.Condition()
        Threads.@threads for origin in line
            id = Threads.threadid()
            total_th = Threads.nthreads()
            (is_valid, action_id) = TableTimelineDisk.execute!(machine.timeline, machine.db, machine.info.actual_km, origin)
            println("Thr.Id:$id/$total_th - Execute KM:$(machine.info.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
            if is_valid
                total_th = Threads.nthreads()

                try
                    println("Thr.Id:$id/$total_th - waiting")
                    Base.lock(lock_key)
                    #Base.acquire(semaphore)
                    total_th = Threads.nthreads()
                    println("Thr.Id:$id/$total_th - Entre in critial area")
                    send_destines!(machine, origin)

                catch e
                    println("Error send destines $e")
                finally
                    Base.unlock(lock_key)
                    #Base.release(semaphore)
                end # try

                total_th = Threads.nthreads()
                println("Thr.Id:$id/$total_th - Out of critial area")
            else
                # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                register_action_to_clean!(machine, machine.info.actual_km, action_id)
            end
        end
    end
end
=#

function have_secure_partial_stop(machine :: TravellingSalesmanMachineDisk) :: Bool
    path = "$(machine.path)/stop"
    return isfile(path)
end
