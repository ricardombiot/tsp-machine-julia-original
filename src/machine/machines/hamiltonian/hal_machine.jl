module HalMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.TableTimeline
    using Main.PathsSet.Graf

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.TableTimeline: Timeline
    using Main.PathsSet.DatabaseActions: DBActions
    using Main.PathsSet.DatabaseMemoryController
    using Main.PathsSet.DatabaseMemoryController: DBMemoryController


    mutable struct HamiltonianMachine
        n :: Color
        actual_km :: Km
        color_origin :: Color
        graf :: Grafo
        timeline :: Timeline
        db :: DBActions
        db_controller :: DBMemoryController
    end

    include("./hal_machine_constructor.jl")
    include("./hal_machine_send_destines.jl")
    include("./hal_machine_execute.jl")
    include("./hal_machine_getters.jl")

end
