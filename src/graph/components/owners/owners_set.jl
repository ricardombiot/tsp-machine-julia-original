module OwnersSet
    using Main.PathsSet.Alias: Step, UniqueNodeKey

    using Main.PathsSet.FBSet
    using Main.PathsSet.FBSet: FixedBinarySet

    mutable struct OwnersFixedSet
        fbset :: FixedBinarySet
    end

    function new(bbnn :: UniqueNodeKey)
        fbset = FBSet.new(bbnn)
        OwnersFixedSet(fbset)
    end

    function push!(owners_set :: OwnersFixedSet, key :: UniqueNodeKey)
        FBSet.push!(owners_set.fbset, key)
    end

    function pop!(owners_set :: OwnersFixedSet, key :: UniqueNodeKey)
        FBSet.pop!(owners_set.fbset, key)
    end

    function isempty(owners_set :: OwnersFixedSet) :: Bool
        return FBSet.isempty(owners_set.fbset)
    end

    function have(owners_set :: OwnersFixedSet, key :: UniqueNodeKey) :: Bool
        FBSet.have(owners_set.fbset, key)
    end

    function union!(owners_set_a :: OwnersFixedSet, owners_set_b :: OwnersFixedSet)
        FBSet.union!(owners_set_a.fbset, owners_set_b.fbset)
    end

    function intersect!(owners_set_a :: OwnersFixedSet, owners_set_b :: OwnersFixedSet)
        FBSet.intersect!(owners_set_a.fbset, owners_set_b.fbset)
    end

    function diff!(owners_set_a :: OwnersFixedSet, owners_set_b :: OwnersFixedSet)
        FBSet.diff!(owners_set_a.fbset, owners_set_b.fbset)
    end

    #=
    function new(derive_fbset :: FixedBinarySet)
        fbset = deepcopy(derive_fbset)
        OwnersFixedSet(fbset)
    end

    function new_empty(derive_fbset :: FixedBinarySet)
        fbset = deepcopy(derive_fbset)
        if !FBSet.isempty(fbset)
            FBSet.to_empty!(fbset)
        end

        OwnersFixedSet(fbset)
    end
    =#
end
