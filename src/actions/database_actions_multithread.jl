module DatabaseActionsMultiThread
    using Main.PathsSet.Alias: ActionId, Km , Color, ActionsIdSet
    using Main.PathsSet.Actions: Action

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.DatabaseActions: DBActions

    mutable struct DBActionsMultiThread
        semafore :: Base.Semaphore
        db :: DBActions
    end

    function new(n :: Color, b :: Km, color_origin :: Color)
        semafore = Base.Semaphore(1)

        Base.acquire(semafore)
        db = DatabaseActions.new(n, b, color_origin)
        Base.release(semafore)

        return DBActionsMultiThread(semafore, db)
    end

    function register_up!(db_decorator :: DBActionsMultiThread, km :: Km, up_color :: Color, parents :: ActionsIdSet) :: ActionId

        Base.acquire(db_decorator.semafore)
        action_id = DatabaseActions.register_up!(db_decorator.db, km, up_color, parents)
        Base.release(db_decorator.semafore)

        return action_id
    end

    function generate_action_id(db :: DBActions, km :: Km, up_color :: Color) :: ActionId
        return DatabaseActions.generate_action_id(db_decorator.db, km, up_color)
    end

    function get_action(db_decorator :: DBActionsMultiThread, id :: ActionId) :: Union{Action, Nothing}
        Base.acquire(db_decorator.semafore)
        action = DatabaseActions.get_action(db_decorator.db, id)
        Base.release(db_decorator.semafore)
        return action
    end

    function remove!(db_decorator :: DBActionsMultiThread, id :: ActionId)
        return DatabaseActions.remove!(db_decorator.db, id)
    end

end
