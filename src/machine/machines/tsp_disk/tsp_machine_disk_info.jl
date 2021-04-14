module TSPMachineInfoDisk
    using Serialization
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.MachineJumper
    using Main.PathsSet.MachineJumper: Jumper

    mutable struct MachineInfoExecution
        n :: Color
        actual_km :: Km
        km_b :: Km
        km_solution_recived :: Union{Km, Nothing}
        color_origin :: Color
        finished :: Bool
        jumper :: Jumper
    end

    function new(n :: Color, km_b :: Km, color_origin :: Color)
        actual_km = Km(0)
        km_solution_recived = nothing
        finished = false
        jumper = MachineJumper.new(km_b)

        MachineInfoExecution(n, actual_km, km_b, km_solution_recived, color_origin, finished, jumper)
    end

    function jump!(info :: MachineInfoExecution)
        info.actual_km = MachineJumper.next_km!(info.jumper, info.actual_km)
    end

    function register_jump!(info :: MachineInfoExecution, km :: Km)
        MachineJumper.register_km!(info.jumper, km)
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
