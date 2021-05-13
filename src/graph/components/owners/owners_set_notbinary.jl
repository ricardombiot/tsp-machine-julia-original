module OwnersSet
    using Main.PathsSet.Alias: Step, UniqueNodeKey


    mutable struct OwnersFixedSet
        nobinary_set :: Set{UniqueNodeKey}
    end

    function new(bbnn :: UniqueNodeKey)
        fbset = Set{UniqueNodeKey}()
        OwnersFixedSet(fbset)
    end

    function push!(owners_set :: OwnersFixedSet, key :: UniqueNodeKey)
        Base.push!(owners_set.nobinary_set, key)
    end

    function pop!(owners_set :: OwnersFixedSet, key :: UniqueNodeKey)
        if have(owners_set, key)
            Base.pop!(owners_set.nobinary_set, key)
        end
    end

    function to_empty!(owners_set :: OwnersFixedSet)
        Base.to_empty!(owners_set.nobinary_set)
    end

    function isempty(owners_set :: OwnersFixedSet) :: Bool
        return Base.isempty(owners_set.nobinary_set)
    end

    function have(owners_set :: OwnersFixedSet, key :: UniqueNodeKey) :: Bool
        return key in owners_set.nobinary_set
    end

    function union!(owners_set_a :: OwnersFixedSet, owners_set_b :: OwnersFixedSet)
        Base.union!(owners_set_a.nobinary_set, owners_set_b.nobinary_set)
    end

    function intersect!(owners_set_a :: OwnersFixedSet, owners_set_b :: OwnersFixedSet)
        Base.intersect!(owners_set_a.nobinary_set, owners_set_b.nobinary_set)
    end

    function to_list(owners_set :: OwnersFixedSet) :: Array{Int64,1}
        collect(owners_set.nobinary_set)
    end

    function count(owners_set :: OwnersFixedSet) :: Int64
        length(owners_set.nobinary_set)
    end

    function to_string(owners :: OwnersFixedSet) :: String
        println(owners.nobinary_set)
    end

    function isequal(owners_a :: OwnersFixedSet, owners_b :: OwnersFixedSet) :: Bool
        owners_a.nobinary_set == owners_b.nobinary_set
    end
end
