module InterfaceMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.HalMachine
    using Main.PathsSet.HalMachine: HamiltonianMachine
    using Main.PathsSet.TSPMachine
    using Main.PathsSet.TSPMachine: TravellingSalesmanMachine

    const IMachine = Union{HamiltonianMachine, TravellingSalesmanMachine}

    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.DatabaseActions: DBActions


    include("./ihal_machine.jl")
    include("./itsp_machine.jl")

end
