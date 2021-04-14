module SubsetSumMachine
    using Main.PathsSet.Alias: Km, Color, ActionId, Step

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.TableTimeline
    using Main.PathsSet.Graf

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimeline: Timeline
    using Main.PathsSet.DatabaseActions: DBActions

    using Main.PathsSet.SubsetSumProgram
    using Main.PathsSet.SubsetSumProgram: SumProgram

    mutable struct SumMachine
        n :: Color
        max_b :: Km
        actual_km :: Km
        color_origin :: Color
        program :: SumProgram
        timeline :: Timeline
        db :: DBActions

        first_solution_stop :: Bool
    end

    function new(b :: Km, k :: Color, lista :: Array{Int64,1}, first_solution_stop :: Bool = false)
        program = SubsetSumProgram.new(b, k, lista)
        n = program.graf.n
        color_origin = Color(0)
        actual_km = Km(0)
        timeline = TableTimeline.new()
        max_b = SubsetSumProgram.get_max_target(program)
        db = DatabaseActions.new(n, max_b, color_origin)

        machine = SumMachine(n, max_b, actual_km, color_origin, program, timeline, db, first_solution_stop)
        init!(machine)

        return machine
    end

    function init!(machine :: SumMachine)
        TableTimeline.put_init!(machine.timeline, machine.n, machine.color_origin)
        send_destines!(machine, machine.color_origin)
        machine.actual_km += Km(1)
    end

    function execute!(machine :: SumMachine)
        if make_step!(machine)
            next_target = get_next_target(machine)
            println("#KM: $(machine.actual_km)/$(next_target)")
            execute!(machine)
        end
    end

    function get_next_target(machine :: SumMachine) :: Union{Km, Nothing}
        next_target = SubsetSumProgram.get_next_target(machine.program)

        if next_target != nothing
            return next_target + 1
        else
            return nothing
        end
    end

    function make_step!(machine :: SumMachine) :: Bool
        if !halt(machine)
            execute_line!(machine :: SumMachine)
            machine.actual_km += Km(1)
            capture_solutions!(machine)
            review_next_target!(machine)
            return true
        else
            return false
        end
    end

    function execute_line!(machine :: SumMachine)
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

    function send_destines!(machine :: SumMachine, origin :: Color)
        action = TableTimeline.get_action_cell(machine.timeline, machine.db, machine.actual_km, origin)

        if action != nothing && action.valid
            parent_id = action.id
            for (destine, weight) in Graf.get_destines(machine.program.graf, origin)
                if is_valid_destine(machine, action, destine)
                    km_destine = machine.actual_km + Km(weight)
                    TableTimeline.push_parent!(machine.timeline, km_destine, destine, parent_id)
                end
            end
        end
    end

    function is_valid_destine(machine :: SumMachine, action :: Action, destine :: Color)
        if destine == machine.color_origin
            if Km(machine.actual_km) == get_next_target(machine) - 1
                #println("Send to origin: $(machine.actual_km)")
                return true
            else
                #println("Not send to origin: $(machine.actual_km)")
                return false
            end
        else
            return true
        end
    end

    function halt(machine :: SumMachine) :: Bool
        if machine.first_solution_stop
            return have_solution(machine) || is_finished(machine)
        else
            return is_finished(machine)
        end
    end

    function is_finished(machine :: SumMachine) :: Bool
        get_next_target(machine) == nothing
    end

    function is_valid_origin(machine :: SumMachine, origin :: Color) :: Bool
        return origin != machine.color_origin
    end

    function capture_solutions!(machine :: SumMachine)
        if Km(machine.actual_km) == get_next_target(machine)
            cell = get_cell_origin(machine)
            if cell != nothing

                for action_id in cell.parents
                    action = SubsetSumMachine.get_action(machine, action_id)
                    SubsetSumProgram.save_graphs_solution_of_action!(machine.program, machine.actual_km - 1, action)
                end
            end
        end
    end

    function have_solution(machine :: SumMachine) :: Bool
        machine.program.have_solution
    end

    function review_next_target!(machine :: SumMachine)
        if Km(machine.actual_km) == get_next_target(machine)
            SubsetSumProgram.inc_next_target!(machine.program)
        end
    end

    function get_action(machine :: SumMachine, action_id :: ActionId) :: Union{Action, Nothing}
        return DatabaseActions.get_action(machine.db, action_id)
    end

    function get_cell_origin(machine :: SumMachine) :: Union{TimelineCell, Nothing}
        return TableTimeline.get_cell(machine.timeline, machine.actual_km, machine.color_origin)
    end

end
