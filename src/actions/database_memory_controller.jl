module DatabaseMemoryController
    using Main.PathsSet.Alias: Km, ActionId, SetActions

    using Main.PathsSet.DatabaseActions
    using Main.PathsSet.DatabaseActions: DBActions

    mutable struct DBMemoryController
        table :: Dict{Km, SetActions}
    end

    function new()
        table = Dict{Km, SetActions}()
        DBMemoryController(table)
    end

    function register!(controller :: DBMemoryController, action_id :: ActionId, km_last_use :: Km)
        if !haskey(controller.table, km_last_use)
            controller.table[km_last_use] = SetActions()
        end

        push!(controller.table[km_last_use], action_id)
    end

    function free_memory_actions_step!(controller :: DBMemoryController, km :: Km, db :: DBActions)
        if haskey(controller.table, km)
            for action_id in controller.table[km]
                DatabaseActions.remove!(db, action_id)
            end
            delete!(controller.table, km)
        end
    end


end
