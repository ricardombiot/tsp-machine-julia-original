module TSPSimpleBruteForce

    using Main.PathsSet.Alias: Step, Km, Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    mutable struct BrutePath
        length :: Int64
        km :: Km
        route_set :: Set{Color}
        route :: Array{Color, 1}
        last :: Color
    end

    mutable struct BruteSimpleMachine
        graf :: Grafo
        paths :: Array{BrutePath, 1}
        b_max :: Km
        length :: Step

        color_origin :: Color
        path_solution :: Array{BrutePath, 1}
    end

    function new(graf ::Grafo, b_max :: Km, color_origin :: Color)
        path_init = build_init_path(color_origin)

        paths = Array{BrutePath, 1}()
        push!(paths, path_init)
        length = Step(1)
        path_solution = Array{BrutePath, 1}()

        BruteSimpleMachine(graf, paths, b_max, length, color_origin, path_solution)
    end

    function have_solution(machine :: BruteSimpleMachine) :: Bool
        !isempty(machine.path_solution)
    end

    function get_solution(machine :: BruteSimpleMachine) :: Union{BrutePath, Nothing}
        if have_solution(machine)
            return first(machine.path_solution)
        else
            return nothing
        end
    end

    function halt(machine :: BruteSimpleMachine) :: Bool
        return (machine.length == machine.graf.n + 1) || isempty(machine.paths)
    end

    function execute!(machine :: BruteSimpleMachine)
        calc_paths!(machine)

        if (machine.length == machine.graf.n + 1)
            calc_optimal_solutions!(machine)
        end
    end

    function calc_optimal_solutions!(machine :: BruteSimpleMachine)
        for path_selected in machine.paths
            if path_selected.km == machine.b_max
                push!(machine.path_solution, path_selected)
            elseif path_selected.km < machine.b_max
                machine.b_max = path_selected.km
                machine.path_solution = [path_selected]
            end
        end
    end

    function calc!(machine :: BruteSimpleMachine)
        if !half(machine)
            paths = machine.paths
            machine.paths = Array{BrutePath, 1}()

            for path_selected in paths
                derive_selected_path!(machine, path_selected)
            end

            machine.length += Step(1)
            calc!(machine)
        end
    end

    function derive_selected_path!(machine :: BruteSimpleMachine, path_selected :: BrutePath )
        if machine.length == machine.graf.n
            derive_return_to_origin!(machine, path_selected)
        else
            derive_go_to_middle!(machine, path_selected)
        end
    end

    function derive_go_to_middle!(machine :: BruteSimpleMachine, path_selected :: BrutePath )
        copy_path = deepcopy(path_selected)

        for (destine, weight) in Graf.get_destines(machine.graf, copy_path.last)

            have_visited = destine in copy_path.route_set
            if !have_visited
                make_visit!(copy_path, destine, weight)
                save_derive_path!(machine, copy_path)
                copy_path = deepcopy(machine.path_selected)
            end
        end
    end

    function derive_return_to_origin!(machine :: BruteSimpleMachine, path_selected :: BrutePath )
        copy_path = deepcopy(path_selected)
        weight = Graf.get_weight(machine.graf, copy_path.last, machine.color_origin)

        have_edge = weight != nothing
        if have_edge
            make_visit!(copy_path, machine.color_origin, weight)
            save_derive_path!(machine, copy_path)
        end
    end

    function make_visit!(path :: BrutePath, color :: Color, weight :: Weight)
        path.length += 1
        path.last = color
        path.route = [path.route; color]
        push!(path.route_set, color)
        path.km += Km(weight)
    end

    function save_derive_path!(machine :: BruteSimpleMachine, path :: BrutePath)
        push!(machine.paths , path)
    end


    function to_string_solutions(machine :: BruteSimpleMachine) :: String
        to_string_paths(machine.path_solution)
    end

    function to_string_paths(paths :: Array{BrutePath, 1})
        txt_solution_path = ""
        for path in paths
            txt_solution_path *= to_string_path(path)
            txt_solution_path *= "\n"
        end

        return txt_solution_path
    end

    function to_string_path(path :: BrutePath) :: String
        txt = ""
        for color in path.route
            txt *= "$color, "
        end

        return chop(txt, tail = 2)
    end


end
