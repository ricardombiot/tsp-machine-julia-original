module TSPMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.TableTimeline
    using Main.PathsSet.Graf

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimeline: Timeline
    using Main.PathsSet.DatabaseActions: DBActions
    using Main.PathsSet.DatabaseMemoryController
    using Main.PathsSet.DatabaseMemoryController: DBMemoryController

    mutable struct TravellingSalesmanMachine
        n :: Color
        actual_km :: Km
        km_b :: Km
        km_solution_recived :: Union{Km, Nothing}
        color_origin :: Color
        graf :: Grafo
        timeline :: Timeline
        db :: DBActions
        db_controller :: DBMemoryController
    end

    function new(graf :: Grafo, km_b :: Km, color_origin :: Color = Color(0))
        n = graf.n
        actual_km = Km(0)
        timeline = TableTimeline.new()
        km_solution_recived = nothing


        db = DatabaseActions.new(n, km_b, color_origin)
        db_controller = DatabaseMemoryController.new()
        machine = TravellingSalesmanMachine(n, actual_km, km_b, km_solution_recived, color_origin, graf,
            timeline, db, db_controller)
        init!(machine)

        return machine
    end

    function init!(machine :: TravellingSalesmanMachine)
        TableTimeline.put_init!(machine.timeline, machine.n, machine.color_origin)
        send_destines!(machine, machine.color_origin)
        machine.actual_km += Km(1)
    end

    function execute!(machine :: TravellingSalesmanMachine)
        if make_step!(machine)
            km_halt = km_target(machine)
            println("#KM: $(machine.actual_km)/$(km_halt)")
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
        return km_to_halt-1 == machine.actual_km
    end

    function km_target(machine :: TravellingSalesmanMachine)
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
                #if is_valid_origin(machine, origin)
                (is_valid, action_id) = TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)
                println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
                if is_valid
                     send_destines!(machine, origin)
                else
                    # Si la acción no se envia a nadie se registra para ser eliminada en el sigueinte paso.
                    DatabaseMemoryController.register!(machine.db_controller, action_id, machine.actual_km)
                end
                #end
            end
        end
    end

    function send_destines!(machine :: TravellingSalesmanMachine, origin :: Color)
        action = TableTimeline.get_action_cell(machine.timeline, machine.db, machine.actual_km, origin)

        if action != nothing && action.valid
            parent_id = action.id
            km_destine_max = nothing
            for (destine, weight) in Graf.get_destines(machine.graf, origin)
                if is_valid_destine(machine, action, destine)

                    #println("--> Destine $destine")
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

    ## Only can return to origin if some graph lenght is equal to N.
    function check_if_solution_recived(machine :: TravellingSalesmanMachine, destine :: Color, km_destine :: Km)
        if destine == machine.color_origin
            if machine.km_solution_recived != nothing
                machine.km_solution_recived = min(machine.km_solution_recived, km_destine)
            else
                machine.km_solution_recived = km_destine
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

    function is_valid_origin(machine :: TravellingSalesmanMachine, origin :: Color) :: Bool
        ## En el ultimo caso solo calculo si tiene como destine color_origin
        if Km(machine.actual_km) == Km(machine.n-1)
            have_arista_to_origin = Graf.have_arista(machine.graf, origin,  machine.color_origin)
            #println("# Before end check origin: $origin ($have_arista_to_origin)")
            return have_arista_to_origin
        else
            return true
        end
    end

    function get_action(machine :: TravellingSalesmanMachine, action_id :: ActionId) :: Union{Action, Nothing}
        return DatabaseActions.get_action(machine.db, action_id)
    end

    function get_cell_origin(machine :: TravellingSalesmanMachine) :: Union{TimelineCell, Nothing}
        return TableTimeline.get_cell(machine.timeline, machine.actual_km+1, machine.color_origin)
    end

end
