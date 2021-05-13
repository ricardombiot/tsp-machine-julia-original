include("./../../src/main.jl")
include("./stages/classification_stages.jl")

function main(args)
     n = parse(UInt128,first(args))
     base_path = "./data/results_classification"
     ClassificationStages.run!(base_path, n)
end

main(ARGS)
