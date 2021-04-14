module TableTimelineDisk
    using Main.PathsSet.Alias: Km, Color, ActionId, ActionsIdSet

    using Main.PathsSet.Actions
    using Main.PathsSet.Actions: Action

    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions
    using Main.PathsSet.GeneratorIds
    using Main.PathsSet.ExecuteActions

    #=
        /km $km
            /color $color
                /parents
                    /parent_$id_parent.txt
                    /parent_$id_parent.txt
                    /...
                /action_id
                    /action_id_$action_id.txt
    =#
    mutable struct TimelineDisk
        n :: Color
        path :: String
        #cells :: Dict{Km, Dict{Color, TimelineCell}}
    end

    function new(n :: Color, path :: String)
        #cells = Dict{Km, Dict{Color, TimelineCell}}()
        TimelineDisk(n, path)
    end

    include("./table_disk_getters_paths.jl")
    include("./table_disk_read_paths.jl")
    include("./table_disk_cast.jl")


    function have_cell(timeline :: TimelineDisk, km :: Km, color :: Color) :: Bool
        path = get_path_cell(timeline, km, color)
        return isdir(path)
    end

    function have_km(timeline :: TimelineDisk, km :: Km) :: Bool
        path = get_path_km(timeline, km)
        return isdir(path)
    end

    function get_line(timeline :: TimelineDisk, km :: Km) :: Union{Array{Color, 1}, Nothing}
        if have_km(timeline, km)
            list_colors = Array{Color, 1}()
            for dir_color in read_km(timeline, km)
                color = cast_dir_color_to_color(dir_color)
                push!(list_colors, color)
            end

            return list_colors
        else
            return nothing
        end
    end

    function get_action_id_cell(timeline :: TimelineDisk, km :: Km, color :: Color) :: Union{ActionId, Nothing}
        action_id = GeneratorIds.get_action_id(timeline.n, km, color)
        return action_id
    end

    function get_action_cell(timeline :: TimelineDisk, db :: IDBActions, km :: Km, color :: Color) :: Union{Action, Nothing}
        if have_cell(timeline, km, color)
            action_id = get_action_id_cell(timeline, km, color)
            return DatabaseInterface.get_action(db, action_id)
        else
            return nothing
        end
    end

    function create_cell!(timeline :: TimelineDisk, km :: Km, color :: Color)
        if !have_km(timeline, km)
            path = get_path_km(timeline, km)
            println("Create dir: $path")
            mkdir(path)
        end

        if !have_cell(timeline, km, color)
            path = get_path_cell(timeline, km, color)
            mkdir(path)

            path = get_path_cell_parents(timeline, km, color)
            mkdir(path)
        end

        #=
        if !have_cell(timeline, km, color)
            path = get_path_cell_parents(timeline, km, color)
            mkpath(path)
        end
        =#
    end

    function put_init!(timeline :: TimelineDisk, n :: Color, color_origin :: Color)
        km = Km(0)
        create_cell!(timeline, km, color_origin)
    end

    function push_parent!(timeline :: TimelineDisk, km :: Km, color :: Color, parent_id :: ActionId)
        if !have_cell(timeline, km, color)
            create_cell!(timeline, km, color)
        end

        path = get_path_cell_parents(timeline, km, color)
        path_parent_file = "$(path)/parent_$(parent_id).txt"

        if !isfile(path_parent_file)
            shell_command = `touch $(path_parent_file)`
            run(shell_command)
        end
    end


    function get_parents_cell(timeline :: TimelineDisk, km :: Km, color :: Color) :: Union{ActionsIdSet, Nothing}
        if have_cell(timeline, km, color)
            set_parents = ActionsIdSet()
            for file_parent_id in read_cell_parents(timeline, km, color)
                action_id = cast_file_parent_id_to_action_id(file_parent_id)
                push!(set_parents, action_id)
            end

            return set_parents
        else
            return nothing
        end
    end

    #=
    function get_action_id_cell(timeline :: TimelineDisk, km :: Km, color :: Color) :: Union{ActionId, Nothing}
        if have_cell(timeline, km, color)
            list = read_cell_action_id(timeline, km, color)
            if isempty(list)
                return nothing
            else
                action_id = cast_file_action_id_to_action_id(first(list))
                return action_id
            end
        else
            return nothing
        end
    end
    =#

    function execute!(timeline :: TimelineDisk, db :: IDBActions, km :: Km, color :: Color) :: Tuple{Bool, Union{ActionId,Nothing}}
        if have_cell(timeline, km, color)
            return execute_cell!(timeline, db, km, color)
        else
            return (false, nothing)
        end
    end

    function execute_cell!(timeline :: TimelineDisk, db :: IDBActions, km :: Km, color :: Color) :: Tuple{Bool, Union{ActionId,Nothing}}
        parents = get_parents_cell(timeline, km, color)
        action_id = DatabaseInterface.register_up!(db, km, color, parents)
        ExecuteActions.run!(db, action_id)

        action = get_action_cell(timeline, db, km, color)
        return (action.valid, action.id)
    end

    #=
    function remove!(timeline :: TimelineDisk, km :: Km)
        if haskey(timeline.cells, km)
            delete!(timeline.cells, km)
        end
    end
    =#
end
