module Owners
    using Main.PathsSet.Alias: Step, UniqueNodeKey

    using Main.PathsSet.OwnersSet
    using Main.PathsSet.OwnersSet: OwnersFixedSet
    using Main.PathsSet.NodeIdentity: NodeId

    mutable struct OwnersByStep
        bbnn :: UniqueNodeKey

        dict :: Dict{Step, OwnersFixedSet}

        max_step :: Step
        # Si algun step es vacio entonces es invalido
        valid :: Bool
    end

    function new(bbnn :: UniqueNodeKey)
        dict = Dict{Step, OwnersFixedSet}()
        max_step = Step(0)
        valid = true
        OwnersByStep(bbnn, dict, max_step, valid)
    end

    function derive(owners :: OwnersByStep) :: OwnersByStep
        deepcopy(owners)
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

    function push!(owners :: OwnersByStep, step :: Step, node_id :: NodeId)
        if !haskey(owners.dict, step)
            create_step_set(owners, step)
        end
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

                if step_set_a == nothing || step_set_b == nothing
                    owners_a.valid = false
                    break
                else
                    OwnersSet.union!(step_set_a, step_set_b)
                end
            end
        else
            owners_a.valid = false
        end
    end

    function intersect!(owners_a :: OwnersByStep, owners_b :: OwnersByStep)
        if can_be_valid_operation(owners_a, owners_b)
            for step in Step(0):owners_a.max_step
                step_set_a = get_step_set(owners_a, step)
                step_set_b = get_step_set(owners_b, step)

                if step_set_a == nothing || step_set_b == nothing
                    owners_a.valid = false
                    break
                else
                    OwnersSet.intersect!(step_set_a, step_set_b)

                    if OwnersSet.isempty(step_set_a)
                        owners_a.valid = false
                        break
                    end
                end
            end
        else
            owners_a.valid = false
        end
    end

    function diff!(owners_a :: OwnersByStep, owners_b :: OwnersByStep)
        if can_be_valid_operation(owners_a, owners_b)
            for step in Step(0):owners_a.max_step
                step_set_a = get_step_set(owners_a, step)
                step_set_b = get_step_set(owners_b, step)


                if step_set_a == nothing || step_set_b == nothing
                    owners_a.valid = false
                    break
                else
                    OwnersSet.diff!(step_set_a, step_set_b)

                    println("difff $step ")
                    if OwnersSet.isempty(step_set_a)
                        println("difff $step  isempty")
                        owners_a.valid = false
                        break
                    end
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

end
