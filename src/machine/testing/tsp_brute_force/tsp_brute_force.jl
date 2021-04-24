module TSPBruteForce
    using Main.PathsSet.Alias: Km, Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo


    mutable struct BrutePath
        length :: Int64
        km :: Km
        route :: Set{Color}
        last :: Color
    end

    mutable struct BruteMachine
        graf :: Grafo
        paths :: Array{BrutePath, 1}
        b_max :: Km

        color_origin :: Color
        path_selected :: Union{BrutePath, Nothing}
        path_solution :: Array{BrutePath, 1}
        search_all_solutions :: Bool
    end

    function new(graf ::Grafo, b_max :: Km, color_origin :: Color, search_all_solutions :: Bool = false)
        path_init = build_init_path(color_origin)

        paths = Array{BrutePath, 1}()
        push!(paths, path_init)
        path_selected = nothing
        path_solution = Array{BrutePath, 1}()

        BruteMachine(graf, paths, b_max, color_origin, path_selected, path_solution, search_all_solutions)
    end

    function have_solution(machine :: BruteMachine) :: Bool
        !isempty(machine.path_solution)
    end

    function get_solution(machine :: BruteMachine) :: Union{BrutePath, Nothing}
        if have_solution(machine)
            return first(machine.path_solution)
        else
            return nothing
        end
    end

    function half(machine :: BruteMachine)
        isempty(machine.paths)
    end

    function execute!(machine :: BruteMachine)
        if !half(machine)
            machine.path_selected = pop!(machine.paths)

            derive_selected_path!(machine)

            if machine.search_all_solutions
                execute!(machine)
            elseif !have_solution(machine)
                execute!(machine)
            end
        end
    end

    function derive_selected_path!(machine :: BruteMachine)
        if machine.path_selected.length == machine.graf.n
            derive_return_to_origin!(machine)
        else
            derive_go_to_middle!(machine)
        end
    end

    function derive_go_to_middle!(machine :: BruteMachine)
        copy_path = deepcopy(machine.path_selected)

        for (destine, weight) in Graf.get_destines(machine.graf, copy_path.last)

            have_visited = destine in copy_path.route
            if !have_visited
                make_visit!(copy_path, destine, weight)
                save_derive_path_if_can_be_solution!(machine, copy_path)
                copy_path = deepcopy(machine.path_selected)
            end

        end
    end

    function derive_return_to_origin!(machine :: BruteMachine)
        copy_path = deepcopy(machine.path_selected)
        weight = Graf.get_weight(machine.graf, copy_path.last, machine.color_origin)

        have_edge = weight != nothing
        if have_edge
            make_visit!(copy_path, machine.color_origin, weight)
            save_derive_path_if_can_be_solution!(machine, copy_path)
        end
    end

    function build_init_path(color_origin :: Color)
        route = Set{Color}()
        push!(route, color_origin)
        BrutePath(1, Km(0), route, color_origin)
    end

    function make_visit!(path :: BrutePath, color :: Color, weight :: Weight)
        path.length += 1
        path.last = color
        push!(path.route, color)
        path.km += Km(weight)
    end

    function save_derive_path_if_can_be_solution!(machine :: BruteMachine, path :: BrutePath)
        if path.km <= machine.b_max
            if path.length == machine.graf.n+1
                push!(machine.path_solution, path)
            else

                push!(machine.paths , path)
            end
        end
    end

end
