module PathChecker
    using Main.PathsSet.Alias: Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.PathReader
    using Main.PathsSet.PathReader: PathSolutionReader

    mutable struct Checker
        actual :: Union{Color, Nothing}
        route :: Array{Color, 1}
        graf :: Grafo
        weight :: Union{Weight, Nothing}
        weight_check :: Weight
        valid :: Bool
    end

    function new(graf :: Grafo, path :: PathSolutionReader, weight_check :: Weight)
        route = deepcopy(path.route)
        route = reverse!(route)
        actual = pop!(route)
        weight = nothing
        valid = true
        Checker(actual, route, graf, weight, weight_check, valid)
    end

    function check_all!(graf :: Grafo, paths :: Array{PathSolutionReader, 1}, weight_check :: Weight) :: Bool
        for path in paths
            checker = new(graf, path, weight_check)
            check!(checker)

            if !checker.valid
                println("Invalid Weight: $(checker.weight)")
                return false
            end
        end

        return true
    end

    function check!(checker :: Checker) :: Bool
        if checker.valid
            if !isempty(checker.route)
                go_to_next!(checker)
                check!(checker)
            else
                checker.valid = checker.weight == checker.weight_check
            end
        end

        return checker.valid
    end

    function go_to_next!(checker :: Checker)
        next = pop!(checker.route)
        #println("Checker step: $(checker.actual) to $next")

        if Graf.have_arista(checker.graf, checker.actual, next)
            weight_arista = Graf.get_weight(checker.graf, checker.actual, next)
            #println(" WEIGHT: $weight_arista")
            add_weight!(checker, weight_arista)
            checker.actual = next

            if checker.weight > checker.weight_check
                checker.valid = false
            end
        else
            checker.valid = false
        end
    end


    function add_weight!(checker :: Checker, weight_arista :: Weight)
        if checker.weight == nothing
            checker.weight = weight_arista
        else
            checker.weight += weight_arista
        end
    end
end
