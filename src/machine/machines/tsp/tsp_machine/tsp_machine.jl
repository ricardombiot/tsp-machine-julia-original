module TSPMachine
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

    mutable struct TravellingSalesmanMachine
        n :: Color
        actual_km :: Km
        km_b :: Km
        km_solution_recived :: Union{Km, Nothing}
        color_origin :: Color
        graf :: Grafo
        timeline :: Timeline
        db :: DBActions
        db_controller :: DBMemoryController
    end

    include("./tsp_machine_constructor.jl")
    include("./tsp_machine_send_destines.jl")
    include("./tsp_machine_execute.jl")
    include("./tsp_machine_getters.jl")

end
