module Owners
    using Main.PathsSet.Alias: Step, UniqueNodeKey

    using Main.PathsSet.OwnersSet
    using Main.PathsSet.OwnersSet: OwnersFixedSet
    using Main.PathsSet.NodeIdentity: NodeId

    mutable struct OwnersByStep
        # The space of all possible keys
        bbnn :: UniqueNodeKey
        # Group of set of nodes id key by step
        dict :: Dict{Step, OwnersFixedSet}
        # The last step
        max_step :: Step
        # If any step have a empty step then is invalid
        valid :: Bool
    end

    function new(bbnn :: UniqueNodeKey)
        dict = Dict{Step, OwnersFixedSet}()
        max_step = Step(0)
        valid = true
        OwnersByStep(bbnn, dict, max_step, valid)
    end

    function derive(owners :: OwnersByStep) :: OwnersByStep
        return deepcopy(owners)
    end

    function empty_derive(owners :: OwnersByStep) :: OwnersByStep
        return new(owners.bbnn)
    end

    function create_step_set(owners :: OwnersByStep, step :: Step) :: OwnersFixedSet
        owners.dict[step] = OwnersSet.new(owners.bbnn)
    end

    function get_step_set(owners :: OwnersByStep, step :: Step) :: Union{OwnersFixedSet, Nothing}
        if haskey(owners.dict, step)
            return owners.dict[step]
        else
            return nothing
        end
    end

    function if_dont_existe_create_step(owners :: OwnersByStep, step :: Step)
        if !haskey(owners.dict, step)
            create_step_set(owners, step)

            if step > Step(0)
                last_step_dont_exist = !haskey(owners.dict, step-1)
                if last_step_dont_exist
                    owners.valid = false
                end
            end
        end
    end

    function push!(owners :: OwnersByStep, step :: Step, node_id :: NodeId)
        if_dont_existe_create_step(owners, step)

        step_set = get_step_set(owners, step)

        key = node_id.key
        OwnersSet.push!(step_set, key)

        if step > owners.max_step
            owners.max_step = step
        end
    end

    function pop!(owners :: OwnersByStep, step :: Step, node_id :: NodeId)
        step_set = get_step_set(owners, step)

        if step_set != nothing
            key = node_id.key
            OwnersSet.pop!(step_set, key)

            if OwnersSet.isempty(step_set)
                delete!(owners.dict, step)
                owners.valid = false
            end
        end
    end

    function isempty(owners :: OwnersByStep, step :: Step) :: Bool
        step_set = get_step_set(owners, step)

        if step_set != nothing
            return OwnersSet.isempty(step_set)
        else
            return true
        end
    end

    function have(owners :: OwnersByStep, step :: Step, node_id :: NodeId) :: Bool
        step_set = get_step_set(owners, step)

        if step_set != nothing
            key = node_id.key
            return OwnersSet.have(step_set, key)
        else
            return false
        end
    end


    function union!(owners_a :: OwnersByStep, owners_b :: OwnersByStep)
        if can_be_valid_operation(owners_a, owners_b)
            for step in Step(0):owners_a.max_step
                step_set_a = get_step_set(owners_a, step)
                step_set_b = get_step_set(owners_b, step)

                OwnersSet.union!(step_set_a, step_set_b)
            end
        else
            owners_a.valid = false
        end
    end

    function intersect!(owners_a :: OwnersByStep, owners_b :: OwnersByStep)
        max_step = min(owners_a.max_step, owners_b.max_step)
        if both_valids(owners_a, owners_b)
            for step in Step(0):Step(max_step)
                step_set_a = get_step_set(owners_a, step)
                step_set_b = get_step_set(owners_b, step)

                if step_set_a != nothing && step_set_b != nothing
                    OwnersSet.intersect!(step_set_a, step_set_b)

                    if OwnersSet.isempty(step_set_a)
                        owners_a.valid = false
                    end
                else
                    owners_a.valid = false
                end
            end
        else
            owners_a.valid = false
        end
    end

    function can_be_valid_operation(owners_a :: OwnersByStep, owners_b :: OwnersByStep) :: Bool
        both_valids = owners_a.valid == true && owners_b.valid == true
        both_eq_max_step = owners_a.max_step == owners_b.max_step

        both_valids && both_eq_max_step
    end

    function both_valids(owners_a :: OwnersByStep, owners_b :: OwnersByStep) :: Bool
        owners_a.valid == true && owners_b.valid == true
    end



    function to_string(owners :: OwnersByStep) :: String
        txt = ""
        for step in Step(0):owners.max_step
            step_set = get_step_set(owners, step)

            txt = OwnersSet.to_string(step_set)
            txt *= "\n"
            txt *= "[$step] $txt"
            txt *= "\n"
        end

        return txt
    end

    function to_string_list(owners :: OwnersByStep) :: String
        txt = ""
        for step in Step(0):owners.max_step
            step_set = get_step_set(owners, step)

            list = OwnersSet.to_list(step_set)
            txt *= "\n"
            txt *= "[$step]"
            txt *= "\n"
            for key in list
                txt *= "K$key"
            end
        end

        return txt
    end

    function count(owners :: OwnersByStep, step :: Step) :: Int64
        step_set = get_step_set(owners, step)

        if step_set != nothing
            return OwnersSet.count(step_set)
        else
            return 0
        end
    end

    function to_list(owners :: OwnersByStep, step :: Step) :: Array{Int64,1}
        step_set = get_step_set(owners, step)

        if step_set != nothing
            return OwnersSet.to_list(step_set)
        else
            return Array{Int64,1}()
        end
    end

    function isequal(owners_a :: OwnersByStep, owners_b :: OwnersByStep) :: Bool
        if !can_be_valid_operation(owners_a, owners_b)
            return false
        end

        for step in Step(0):owners_a.max_step
            owners_step_set_a = get_step_set(owners_a, step)
            owners_step_set_b = get_step_set(owners_b, step)
            
            if !OwnersSet.isequal(owners_step_set_a, owners_step_set_b)
                return false
            end
        end

        return true
    end

end
