module DatabaseActionsDisk
    using Main.PathsSet.Alias: Step, ActionsIdSet, Km, Color, ActionId

    using Main.PathsSet.PathGraph
    using Main.PathsSet.Actions

    using Main.PathsSet.Actions
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.GeneratorIds
    using Serialization

    mutable struct DBActionsDisk
        n :: Color
        b :: Km
        color_origin :: Color

        path :: String
    end

    function new(n :: Color, b :: Km, color_origin :: Color, path :: String)
        db = DBActionsDisk(n, b, color_origin, path)

        return db
    end

    function init!(db :: DBActionsDisk)
        path = "$(db.path)/db"
        if !isdir(path)
            println(path)
            mkdir(path)
        end

        action = Actions.new_init(db.n, db.b, db.color_origin)
        register_action!(db, action)
    end

    function get_path_file_name(db :: DBActionsDisk, action :: Action) :: String
        get_path_file_name(db, action.id)
    end
    function get_path_file_name(db :: DBActionsDisk, id :: ActionId) :: String
        "$(db.path)/db/act$(id).tspm"
    end

    function register_action!(db :: DBActionsDisk, action :: Action)
        path = get_path_file_name(db, action)
        serialize(path, action)
    end

    function generate_action_id(db :: DBActionsDisk, km :: Km, up_color :: Color) :: ActionId
        return GeneratorIds.get_action_id(db.n, km, up_color)
    end

    function register_up!(db :: DBActionsDisk, km :: Km, up_color :: Color, parents :: ActionsIdSet) :: ActionId
        action_id = generate_action_id(db, km, up_color)
        action = Actions.new(action_id, km, up_color, parents)
        register_action!(db, action)

        return action_id
    end


    function get_action(db :: DBActionsDisk, id :: ActionId) :: Union{Action, Nothing}
        path = get_path_file_name(db, id)
        if isfile(path)
            return deserialize(path)
        else
            return nothing
        end
    end

    function finished_execution!(db :: DBActionsDisk, action :: Action)
        DatabaseActionsDisk.register_action!(db, action)
    end


    function remove!(db :: DBActionsDisk, id :: ActionId)
        path = get_path_file_name(db, id)
        if isfile(path)
            rm(path)
        end
    end

end
