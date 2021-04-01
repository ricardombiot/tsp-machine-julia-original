module DatabaseActions
    using Main.PathsSet.Alias: Step, Km, Color, ActionId, ActionsIdSet

    using Main.PathsSet.PathGraph
    using Main.PathsSet.Actions

    using Main.PathsSet.Actions
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.GeneratorIds

    mutable struct DBActions
        n :: Color
        b :: Km
        color_origin :: Color

        table :: Dict{ActionId, Action}
    end

    function new(n :: Color, b :: Km, color_origin :: Color)
        table = Dict{ActionId, Action}()
        db = DBActions(n, b, color_origin, table)
        init!(db)

        return db
    end

    function init!(db :: DBActions)
        action = Actions.new_init(db.n, db.b, db.color_origin)
        register_action!(db, action)
    end

    function register_action!(db :: DBActions, action :: Action)
        db.table[action.id] = action
    end

    function generate_action_id(db :: DBActions, km :: Km, up_color :: Color) :: ActionId
        return GeneratorIds.get_action_id(db.n, km, up_color)
    end

    function register_up!(db :: DBActions, km :: Km, up_color :: Color, parents :: ActionsIdSet) :: ActionId
        action_id = generate_action_id(db, km, up_color)
        action = Actions.new(action_id, km, up_color, parents)
        register_action!(db, action)

        return action_id
    end


    function get_action(db :: DBActions, id :: ActionId) :: Union{Action, Nothing}
        if haskey(db.table, id)
            return db.table[id]
        else
            return nothing
        end
    end

    function remove!(db :: DBActions, id :: ActionId)
        if haskey(db.table, id)
            delete!(db.table, id)
        end
    end

end
