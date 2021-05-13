module InterfaceMachine
    using Main.PathsSet.Alias: Km, Color, ActionId

    using Main.PathsSet.HalMachine
    using Main.PathsSet.HalMachine: HamiltonianMachine
    using Main.PathsSet.TSPMachine
    using Main.PathsSet.TSPMachine: TravellingSalesmanMachine
    using Main.PathsSet.TSPMachineDisk
    using Main.PathsSet.TSPMachineDisk: TravellingSalesmanMachineDisk
    using Main.PathsSet.ParallelTSPMachine
    using Main.PathsSet.ParallelTSPMachine: TravellingSalesmanMachineParallel

    const IMachine = Union{
                        HamiltonianMachine,
                        TravellingSalesmanMachine,
                        TravellingSalesmanMachineDisk,
                        TravellingSalesmanMachineParallel,
                     }

    using Main.PathsSet.Cell: TimelineCell
    using Main.PathsSet.Actions: Action
    using Main.PathsSet.DatabaseActions: DBActions
    using Main.PathsSet.DatabaseActionsDisk: DBActionsDisk


    include("./ihal_machine.jl")
    include("./itsp_machine.jl")
    include("./iparallel_tsp_machine.jl")
    include("./itsp_disk_machine.jl")


end
