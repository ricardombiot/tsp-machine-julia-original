module DatabaseMemoryControllerDisk
    using Main.PathsSet.Alias: Km, ActionId, ActionsIdSet

    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions

    mutable struct DBMemoryControllerDisk
        path :: String
    end

    function new(path :: String)
        DBMemoryControllerDisk(path)
    end

    function init!(controller :: DBMemoryControllerDisk)
        init_path = "$(controller.path)/db_controller"

        if !isdir(init_path)
            mkdir(init_path)
        end
    end

    function get_path_km(controller :: DBMemoryControllerDisk, km :: Km) :: String
        "$(controller.path)/db_controller/km$(km)"
    end

    function cast_file_action_id_to_action_id(file_id :: String) :: ActionId
        file_id = replace(file_id, ".txt" => "")
        file_id = replace(file_id, "action_" => "")
        action_id = parse(ActionId, file_id)
        return action_id
    end

    function read_km(controller :: DBMemoryControllerDisk, km :: Km) :: Array{String, 1}
        path = get_path_km(controller, km)

        if isdir(path)
            return readdir(path)
        else
            return Array{String, 1}()
        end
    end

    function have_km(controller :: DBMemoryControllerDisk, km :: Km) :: Bool
        path = get_path_km(controller, km)
        return isdir(path)
    end


    function register!(controller :: DBMemoryControllerDisk, km_last_use :: Km, action_id :: ActionId)
        if !have_km(controller, km_last_use)
            path = get_path_km(controller, km_last_use)
            mkdir(path)
        end

        path = get_path_km(controller, km_last_use)
        path_action_file = "$(path)/action_$(action_id).txt"

        if !isfile(path_action_file)
            shell_command = `touch $(path_action_file)`
            run(shell_command)
        end
    end

    function free_memory_actions_step!(controller :: DBMemoryControllerDisk, km :: Km, db :: IDBActions)
        if have_km(controller, km)
            for file_action_id in read_km(controller, km)
                action_id = cast_file_action_id_to_action_id(file_action_id)
                DatabaseInterface.remove!(db, action_id)
            end

            clear_controller_km!(controller, km)
        end
    end

    function clear_controller_km!(controller :: DBMemoryControllerDisk, km :: Km)
        if have_km(controller, km)
            path = get_path_km(controller, km)
            rm(path, recursive=true)
        end
    end


end
