module DatabaseInterface
    using Main.PathsSet.Alias: ActionId, Km , Color, ActionsIdSet
    using Main.PathsSet.Actions: Action

    using Main.PathsSet.DatabaseActionsDisk
    using Main.PathsSet.DatabaseActionsDisk: DBActionsDisk
    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.DatabaseActions: DBActions

    const IDBActions = Union{DBActions, DBActionsDisk}

    function register_up!(db :: DBActionsDisk, km :: Km, up_color :: Color, parents :: ActionsIdSet) :: ActionId
        return DatabaseActionsDisk.register_up!(db, km, up_color, parents)
    end
    function register_up!(db :: DBActions, km :: Km, up_color :: Color, parents :: ActionsIdSet) :: ActionId
        return DatabaseActions.register_up!(db, km, up_color, parents)
    end

    function generate_action_id(db :: DBActions, km :: Km, up_color :: Color) :: ActionId
        return DatabaseActions.generate_action_id(db, km, up_color)
    end
    function generate_action_id(db :: DBActionsDisk, km :: Km, up_color :: Color) :: ActionId
        return DatabaseActionsDisk.generate_action_id(db, km, up_color)
    end


    function get_action(db :: DBActionsDisk, id :: ActionId) :: Union{Action, Nothing}
        return DatabaseActionsDisk.get_action(db, id)
    end
    function get_action(db :: DBActions, id :: ActionId) :: Union{Action, Nothing}
        return DatabaseActions.get_action(db, id)
    end

    function remove!(db :: DBActionsDisk, id :: ActionId)
        DatabaseActionsDisk.remove!(db, id)
    end
    function remove!(db :: DBActions, id :: ActionId)
        DatabaseActions.remove!(db, id)
    end


    function finished_execution!(db :: DBActionsDisk, action :: Action)
        DatabaseActionsDisk.finished_execution!(db, action)
    end

    function finished_execution!(db :: DBActions, action :: Action)
    end



end
