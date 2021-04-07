module TSPMachineParallel
    using Main.PathsSet.Alias: Km, Color, ActionId
    using Main.PathsSet.TSPMachine
    using Main.PathsSet.TSPMachine: TravellingSalesmanMachine

    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimeline
    using Base.Threads

    using Main.PathsSet.DatabaseMemoryController
    using Main.PathsSet.DatabaseMemoryController: DBMemoryController

    function execute!(machine :: TravellingSalesmanMachine)
        n_thr = nthreads()
        println("Thr: $n_thr" )
        execute_step!(machine)
    end

    function execute_step!(machine :: TravellingSalesmanMachine)
        if make_step!(machine)
            km_halt = TSPMachine.km_target(machine)
            println("#KM: $(machine.actual_km)/$(km_halt)")
            execute_step!(machine)
        end
    end

    function make_step!(machine :: TravellingSalesmanMachine) :: Bool
        if !TSPMachine.rules_to_halt_machine(machine)
            execute_line!(machine)
            TSPMachine.free_memory!(machine)
            machine.actual_km += Km(1)
            return true
        else
            return false
        end
    end

    function execute_line!(machine :: TravellingSalesmanMachine)
        line = TableTimeline.get_line(machine.timeline, machine.actual_km)
        if line != nothing
            results = Array{Tuple{Bool, Color, ActionId}, 1}()

            Threads.@threads for origin in collect(keys(line))
                (is_valid, action_id) = TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)

                result_tuple :: Tuple{Bool, Color, ActionId} = (is_valid, origin, action_id)
                push!(results, result_tuple)
            end


            for (is_valid, origin, action_id) in results
                if is_valid
                     TSPMachine.send_destines!(machine, origin)
                else
                    # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                    DatabaseMemoryController.register!(machine.db_controller, action_id, machine.actual_km)
                end
            end
        end
    end

end
