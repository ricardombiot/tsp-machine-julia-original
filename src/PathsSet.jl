module PathsSet

    include("utils/alias.jl")
    include("utils/generator_ids.jl")

    include("fbset/FBSet128.jl")
    include("fbset/FBSet.jl")

    include("graph/components/node/node_identity.jl")
    include("graph/components/owners/owners_set.jl")
    include("graph/components/owners/owners.jl")


end # module
