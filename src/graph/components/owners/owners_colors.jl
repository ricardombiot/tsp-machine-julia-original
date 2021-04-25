#=
module OwnersColors
    using Main.PathsSet.Alias: Step, UniqueNodeKey, Color, SetColors
    using Main.PathsSet.NodeIdentity: NodeId, NodesIdSet

    mutable struct ConflictColorDetector
        count_owners_step :: Color
        last_color :: Color
    end


    mutable struct OwnersColoresByNode
        dict_step :: Dict{NodeId, ConflictColorDetector}

        dict_node_conflicts :: Dict{NodeId, SetColors}

        nodes_to_remove :: NodesIdSet
    end

end
=#
