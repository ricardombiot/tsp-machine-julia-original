module HalMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.TableTimeline
    using Main.PathsSet.Graf

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimeline: Timeline
    using Main.PathsSet.DatabaseActions: DBActions

    mutable struct HamiltonianMachine
        n :: Color
        actual_km :: Km
        color_origin :: Color
        graf :: Grafo
        timeline :: Timeline
        db :: DBActions
    end

    function new(graf :: Grafo, color_origin :: Color = Color(0))
        n = graf.n
        b = Km(n)
        actual_km = Km(0)
        timeline = TableTimeline.new()


        db = DatabaseActions.new(n, b, color_origin)
        machine = HamiltonianMachine(n, actual_km, color_origin, graf, timeline, db)
        init!(machine)

        return machine
    end

    function init!(machine :: HamiltonianMachine)
        TableTimeline.put_init!(machine.timeline, machine.n, machine.color_origin)
        send_destines!(machine, machine.color_origin)
        machine.actual_km += Km(1)
    end

    function execute!(machine :: HamiltonianMachine)
        if make_step!(machine)
            #println("#KM: $(machine.actual_km)/$(machine.n)")
            execute!(machine)
        end
    end

    function make_step!(machine :: HamiltonianMachine) :: Bool
        if machine.actual_km < machine.n
            execute_line!(machine :: HamiltonianMachine)
            machine.actual_km += Km(1)
            return true
        else
            return false
        end
    end

    function execute_line!(machine :: HamiltonianMachine)
        line = TableTimeline.get_line(machine.timeline, machine.actual_km)
        if line != nothing
            for (origin, cell) in line
                if is_valid_origin(machine, origin)
                    (is_valid, action_id) = TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)
                    #println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
                    if is_valid
                         send_destines!(machine, origin)
                    end
                end
            end
        end
    end

    function send_destines!(machine :: HamiltonianMachine, origin :: Color)
        action = TableTimeline.get_action_cell(machine.timeline, machine.db, machine.actual_km, origin)

        if action != nothing && action.valid
            parent_id = action.id
            for (destine, weight) in Graf.get_destines(machine.graf, origin)
                if is_valid_destine(machine, action, destine)
                    #println("--> Destine $destine")
                    km_destine = machine.actual_km + Km(weight)
                    TableTimeline.push_parent!(machine.timeline, km_destine, destine, parent_id)
                end
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

    function get_action(machine :: HamiltonianMachine, action_id :: ActionId) :: Union{Action, Nothing}
        return DatabaseActions.get_action(machine.db, action_id)
    end

    function get_cell_origin(machine :: HamiltonianMachine) :: Union{TimelineCell, Nothing}
        return TableTimeline.get_cell(machine.timeline, machine.actual_km, machine.color_origin)
    end

end
