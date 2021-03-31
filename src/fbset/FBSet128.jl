module FBSet128

    mutable struct FixedBinarySet128
        content :: UInt128
    end

    function new()
        content = UInt128(0)
        FixedBinarySet128(content)
    end

    function to_empty!(set :: FixedBinarySet128)
        set.content = UInt128(0)
    end

    function to_full!(set :: FixedBinarySet128)
        set.content = UInt128(0xffffffffffffffffffffffffffffffff)
    end

    function isempty(set :: FixedBinarySet128) :: Bool
        return set.content == UInt128(0)
    end

    function isfull(set :: FixedBinarySet128) :: Bool
        return set.content == UInt128(0xffffffffffffffffffffffffffffffff)
    end

    function count(set :: FixedBinarySet128) :: Int64
        return count_ones(set.content)
    end

    function to_list(set :: FixedBinarySet128, item_start :: Int64 = 0) :: Array{Int64,1}
        list = Array{Int64,1}()
        for item in 1:128
            if have(set, item)
                item_value = item_start + item

                Base.push!(list, item_value)
            end
        end

        return list
    end

    function push!(set :: FixedBinarySet128, list_items :: Array{Int64,1})
        for item in list_items
            push!(set, item)
        end
    end

    function push!(set :: FixedBinarySet128, item :: Int64)
        if item > 0 && item <= 128
            target = UInt128(1) << (item - 1)
            set.content = set.content | target
        end
    end

    function pop!(set :: FixedBinarySet128, item :: Int64)
        if item > 0 && item <= 128
            target = UInt128(1) << (item - 1)
            set.content = set.content ⊻ target
        end
    end

    function have_items(set :: FixedBinarySet128, list_items :: Array{Int64,1} ) :: Array{Bool,1}
        list_results = Array{Bool,1}()
        for item in list_items
            result = have(set, item)
            Base.push!(list_results, result)
        end

        return list_results
    end

    function have(set :: FixedBinarySet128, item :: Int64) :: Bool
        if item > 0 && item <= 128
            target = UInt128(1) << (item - 1)
            filter_bit = (set.content & target) >>> (item - 1)
            return filter_bit == UInt128(1)
        else
            return false
        end
    end

    function union!(set :: FixedBinarySet128, set_join :: FixedBinarySet128)
        set.content = set.content | set_join.content
    end

    function intersect!(set :: FixedBinarySet128, set_join :: FixedBinarySet128)
        set.content = set.content & set_join.content
    end

    function diff!(set :: FixedBinarySet128, set_join :: FixedBinarySet128)
        set.content = set.content & (~set_join.content)
    end

    function isequal(set_a :: FixedBinarySet128, set_b :: FixedBinarySet128) :: Bool
        set_a.content == set_b.content
    end

end
