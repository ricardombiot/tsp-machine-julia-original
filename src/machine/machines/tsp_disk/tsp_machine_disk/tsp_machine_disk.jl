module TSPMachineDisk
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.TSPMachineInfoDisk
    using Main.PathsSet.TSPMachineInfoDisk: MachineInfoExecution

    using Main.PathsSet.DatabaseActionsDisk
    using Main.PathsSet.DatabaseActionsDisk: DBActionsDisk
    using Main.PathsSet.DatabaseMemoryControllerDisk
    using Main.PathsSet.DatabaseMemoryControllerDisk: DBMemoryControllerDisk

    using Main.PathsSet.TableTimelineDisk
    using Main.PathsSet.Graf

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimelineDisk: TimelineDisk

    mutable struct TravellingSalesmanMachineDisk
        path :: String
        info :: MachineInfoExecution
        graf :: Grafo
        timeline :: TimelineDisk
        db :: DBActionsDisk
        db_controller :: DBMemoryControllerDisk
    end

    include("./constructor.jl")
    include("./destines.jl")
    include("./execution.jl")
    include("./getters.jl")
    include("./memory.jl")


end
