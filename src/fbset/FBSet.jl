module FBSet

    using Main.PathsSet.FBSet128
    using Main.PathsSet.FBSet128: FixedBinarySet128

    mutable struct FixedBinarySet
        n :: Int64
        n_subsets :: Int64
        active_subsets :: Int64
        subsets :: Dict{Int64, FixedBinarySet128}
    end

    function new(n :: Int64)
        n_subsets = Int64(ceil( n / 128 ))
        subsets = Dict{Int64, FixedBinarySet128}()
        active_subsets = 0

        FixedBinarySet(n, n_subsets, active_subsets, subsets)
    end

    function get_subset_id(set :: FixedBinarySet, item :: Int64) :: Int64
        Int64(ceil(item  / 128))
    end

    function get_target_item(item :: Int64) :: Int64
        Int64(rem(item-1,128)) + 1
    end

    function to_empty!(set :: FixedBinarySet)
        set.subsets = Dict{Int64, FixedBinarySet128}()
        set.active_subsets = 0
    end

    function count(set :: FixedBinarySet) :: Int64
        total = 0
        for (id, subset) in set.subsets
            total += FBSet128.count(subset)
        end

        return total
    end

    function isempty(set :: FixedBinarySet) :: Bool
        return set.active_subsets == 0
    end

    function isfull(set :: FixedBinarySet) :: Bool
        for id in 1:set.n_subsets-1
            subset = get_subset(set, id)
            if subset == nothing
                return false
            elseif !FBSet128.isfull(subset)
                return false
            end

        end


        ultima_id = set.n_subsets
        subset = get_subset(set, ultima_id)
        if subset == nothing
            return false
        else
            not_corver_items = (set.n_subsets * 128) - set.n
            partial_full = UInt128(0xffffffffffffffffffffffffffffffff) >>> not_corver_items
            return subset.content == partial_full
        end
    end

    function push!(set :: FixedBinarySet, list_items :: Array{Int64,1})
        for item in list_items
            push!(set, item)
        end
    end

    function push!(set :: FixedBinarySet, item :: Int64)
        if item > 0 && item <= set.n
            subset = load_subset!(set, item)
            item_target = get_target_item(item)
            FBSet128.push!(subset, item_target)
        end
    end

    function pop!(set :: FixedBinarySet, item :: Int64)
        if item > 0 && item <= set.n
            subset = load_subset!(set, item)
            item_target = get_target_item(item)
            FBSet128.pop!(subset, item_target)

            clear_subset_if_isempty_by_item!(set, item)
        end
    end

    function have_items(set :: FixedBinarySet, list_items :: Array{Int64,1} ) :: Array{Bool,1}
        list_results = Array{Bool,1}()
        for item in list_items
            result = have(set, item)
            Base.push!(list_results, result)
        end

        return list_results
    end

    function have(set :: FixedBinarySet, item :: Int64) :: Bool
        if item > 0 && item <= set.n
            subset = load_subset!(set, item)
            item_target = get_target_item(item)
            return FBSet128.have(subset, item_target)
        else
            return false
        end
    end


    function union!(set_a :: FixedBinarySet, set_b :: FixedBinarySet)
        if set_a.n == set_b.n
            for (id, subset_b) in set_b.subsets
                subset_a = load_subset_by_id!(set_a, id)
                FBSet128.union!(subset_a, subset_b)
            end
        end
    end

    function intersect!(set_a :: FixedBinarySet, set_b :: FixedBinarySet)
        if set_a.n == set_b.n
            for (id, subset_a) in set_a.subsets
                subset_b = get_subset(set_b, id)

                if subset_b == nothing
                    # Si uno de los conjuntos es vacio entonces la intersección será vacia

                    # Si el subconjunto A, existe entonces tenemos que borrarlo
                    # eso significa que todo el subset es vacio
                    delete!(set_a.subsets, id)
                    set_a.active_subsets -= 1
                else
                    FBSet128.intersect!(subset_a, subset_b)

                    if FBSet128.isempty(subset_a)
                        delete!(set_a.subsets, id)
                        set_a.active_subsets -= 1
                    end
                end
            end
        end
    end

    function intersect_old!(set_a :: FixedBinarySet, set_b :: FixedBinarySet)
        if set_a.n == set_b.n
            for id in 1:set_a.n_subsets
                subset_a = get_subset(set_a, id)
                subset_b = get_subset(set_b, id)

                if subset_a == nothing || subset_b == nothing
                    # Si uno de los conjuntos es vacio entonces la intersección será vacia
                    if subset_a != nothing
                        # Si el subconjunto A, existe entonces tenemos que borrarlo
                        # eso significa que todo el subset es vacio
                        delete!(set_a.subsets, id)
                    end
                elseif subset_a != nothing && subset_b != nothing
                    FBSet128.intersect!(subset_a, subset_b)

                    if FBSet128.isempty(subset_a)
                        delete!(set_a.subsets, id)
                        set_a.active_subsets -= 1
                    end
                end
            end
        end
    end

    function diff!(set_a :: FixedBinarySet, set_b :: FixedBinarySet)
        if set_a.n == set_b.n
            for (id, subset_a) in set_a.subsets
                subset_b = get_subset(set_b, id)

                if subset_b != nothing
                    FBSet128.diff!(subset_a, subset_b)

                    if FBSet128.isempty(subset_a)
                        delete!(set_a.subsets, id)
                        set_a.active_subsets -= 1
                    end
                end
            end
        end
    end

    function isequal(set_a :: FixedBinarySet, set_b :: FixedBinarySet) :: Bool
        if set_a.n == set_b.n
            flag = true

            for id in 1:set_a.n_subsets
                if !flag
                    return false
                end

                subset_a = get_subset(set_a, id)
                subset_b = get_subset(set_b, id)
                if subset_a == nothing && subset_b == nothing
                    flag = true
                elseif subset_a == nothing && subset_b != nothing
                    flag = false
                elseif subset_a != nothing && subset_b == nothing
                    flag = false
                else
                    flag = FBSet128.isequal(subset_a, subset_b)
                end
            end

            return true
        else
            return false
        end
    end



    function get_subset(set :: FixedBinarySet, id :: Int64) :: Union{FixedBinarySet128, Nothing}
        if haskey(set.subsets, id)
            return set.subsets[id]
        end
    end

    function clear_subset_if_isempty_by_item!(set :: FixedBinarySet, item :: Int64)
        id = get_subset_id(set, item)
        clear_subset_if_isempty!(set, id)
    end

    function clear_subset_if_isempty!(set :: FixedBinarySet, id :: Int64)
        if haskey(set.subsets, id)
            if FBSet128.isempty(set.subsets[id])
                delete!(set.subsets, id)
                set.active_subsets -= 1
            end
        end
    end

    function load_subset!(set :: FixedBinarySet, item :: Int64) :: Union{FixedBinarySet128, Nothing}
        id = get_subset_id(set, item)
        return load_subset_by_id!(set, id)
    end

    function load_subset_by_id!(set :: FixedBinarySet, id :: Int64) :: Union{FixedBinarySet128, Nothing}
        if !haskey(set.subsets, id)
            set.subsets[id] = FBSet128.new()
            set.active_subsets+= 1
        end

        return set.subsets[id]
    end


    function to_string(set :: FixedBinarySet) :: String
        txt = ""
        for id in 1:set.n_subsets-1
            subset = get_subset(set, id)

            content128 = UInt128(0)
            if subset != nothing
                content128 = subset.content
            end

            content = bitstring(content128)
            txt *= "$content"
        end

        return txt
    end
end
