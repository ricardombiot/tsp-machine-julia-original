module TSPMachineInfoDisk
    using Serialization
    using Main.PathsSet.Alias: Km, Color, ActionId

    mutable struct MachineInfoExecution
        n :: Color
        actual_km :: Km
        km_b :: Km
        km_solution_recived :: Union{Km, Nothing}
        color_origin :: Color
        finished :: Bool
    end

    function new(n :: Color, km_b :: Km, color_origin :: Color)
        actual_km = Km(0)
        km_solution_recived = nothing
        finished = false

        MachineInfoExecution(n, actual_km, km_b, km_solution_recived, color_origin, finished)
    end

    function get_path_file_name(path :: String) :: String
        "$(path)/info.tspm"
    end

    function write!(info :: MachineInfoExecution, path :: String)
        path = get_path_file_name(path)
        serialize(path, info)
    end

    function read!(path :: String) :: Union{MachineInfoExecution, Nothing}
        path = get_path_file_name(path)
        if isfile(path)
            return deserialize(path)
        else
            return nothing
        end
    end

end
