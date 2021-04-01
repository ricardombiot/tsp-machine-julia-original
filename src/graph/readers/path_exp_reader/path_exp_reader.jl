module PathExpReader
    using Main.PathsSet.Alias: Step, Color, Km
    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.PathReader
    using Main.PathsSet.PathReader: PathSolutionReader

    using Main.PathsSet.Graphviz

    mutable struct PathSolutionExpReader
        n :: Color
        b :: Km
        step :: Step
        limit :: UInt128
        paths_solvers :: Array{PathSolutionReader,1}
        paths_solution :: Array{PathSolutionReader,1}
        is_origin_join :: Bool
        dir :: String
    end


    include("./reader_exp_constructor.jl")
    include("./reader_exp_next_step.jl")
    include("./reader_exp_getters.jl")
    include("./reader_exp_plot.jl")


end
