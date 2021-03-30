module InterfaceMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.HalMachine
    using Main.PathsSet.HalMachine: HamiltonianMachine

    const IMachine = HamiltonianMachine

    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.DatabaseActions: DBActions


    include("./ihal_machine.jl")

end
