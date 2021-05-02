module Cell
    using Main.PathsSet.Alias: Km, Color, ActionId, ActionsIdSet

    using Main.PathsSet.Actions
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.ExecuteActions

    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions

    mutable struct TimelineCell
        km :: Km
        color :: Color
        parents :: ActionsIdSet
        action_id :: Union{ActionId, Nothing}

        valid :: Bool
    end

    function new(km :: Km, color :: Color, action_id :: Union{ActionId, Nothing} = nothing)
        parents = ActionsIdSet()
        TimelineCell(km, color, parents, action_id, true)
    end

    function push_parent!(cell :: TimelineCell, parent_id :: ActionId)
        push!(cell.parents, parent_id)
    end

    function get_action(cell :: TimelineCell, db :: IDBActions) :: Union{Action, Nothing}
        if cell.action_id != nothing
            return DatabaseInterface.get_action(db, cell.action_id)
        else
            return nothing
        end
    end

    function execute!(cell :: TimelineCell, db :: IDBActions) :: Tuple{Bool, Union{ActionId,Nothing}}
        if cell.action_id == nothing
            cell.action_id = DatabaseInterface.register_up!(db, cell.km, cell.color, cell.parents)
            ExecuteActions.run!(db, cell.action_id)

            action = get_action(cell, db)
            cell.valid = action.valid
            return (cell.valid, cell.action_id)
        else
            return (false, nothing)
        end
    end

end
