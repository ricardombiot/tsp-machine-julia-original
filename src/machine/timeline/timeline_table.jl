module TableTimeline
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.Cell
    using Main.PathsSet.Cell: TimelineCell

    using Main.PathsSet.Actions
    using Main.PathsSet.Actions: Action

    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions
    using Main.PathsSet.GeneratorIds

    mutable struct Timeline
        cells :: Dict{Km, Dict{Color, TimelineCell}}
    end

    function new()
        cells = Dict{Km, Dict{Color, TimelineCell}}()
        Timeline(cells)
    end

    function get_line(timeline :: Timeline, km :: Km) :: Union{Dict{Color, TimelineCell}, Nothing}
        if haskey(timeline.cells, km)
            return timeline.cells[km]
        else
            return nothing
        end
    end

    function have_cell(timeline :: Timeline, km :: Km, color :: Color) :: Bool
        get_cell(timeline, km, color) != nothing
    end

    function get_action_cell(timeline :: Timeline, db :: IDBActions, km :: Km, color :: Color) :: Union{Action, Nothing}
        if have_cell(timeline, km, color)
            cell = get_cell(timeline, km, color)
            return Cell.get_action(cell, db)
        else
            return nothing
        end
    end

    function get_cell(timeline :: Timeline, km :: Km, color :: Color) :: Union{TimelineCell, Nothing}
        if haskey(timeline.cells, km)
            if haskey(timeline.cells[km], color)
                return timeline.cells[km][color]
            end
        end

        return nothing
    end

    function create_cell!(timeline :: Timeline, km :: Km, color :: Color, action_id :: Union{ActionId, Nothing} = nothing)
        if !haskey(timeline.cells, km)
            timeline.cells[km] = Dict{Color, TimelineCell}()
        end

        if !haskey(timeline.cells[km], color)
            new_cell = Cell.new(km, color, action_id)
            timeline.cells[km][color] = new_cell
        end
    end

    function put_init!(timeline :: Timeline, n :: Color, color_origin :: Color)
        km = Km(0)
        action_id = GeneratorIds.get_action_id(n, km, color_origin)
        create_cell!(timeline, km, color_origin, action_id)
    end

    function push_parent!(timeline :: Timeline, km :: Km, color :: Color, parent_id :: ActionId)
        if !have_cell(timeline, km, color)
            create_cell!(timeline, km, color)
        end

        cell = get_cell(timeline, km, color)
        Cell.push_parent!(cell, parent_id)
    end

    function execute!(timeline :: Timeline, db :: IDBActions, km :: Km, color :: Color) :: Tuple{Bool, Union{ActionId,Nothing}}
        if have_cell(timeline, km, color)
            cell = get_cell(timeline, km, color)
            return Cell.execute!(cell, db)
        else
            return (false, nothing)
        end
    end

    function remove!(timeline :: Timeline, km :: Km)
        if haskey(timeline.cells, km)
            delete!(timeline.cells, km)
        end
    end
end
