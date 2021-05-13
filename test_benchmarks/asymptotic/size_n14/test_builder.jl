module TestBuilder
    using Main.PathsSet.Alias: Color, Km
    using Test

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.HalMachine
    using Main.PathsSet.SolutionGraphReader
    using Main.PathsSet.PathReader

    function create_by_n_instance(n_color)
        return n_color
    end

    # crear diferentes instancias por cada iteracion
    function create_by_iter_instance(n_color)
        return nothing
    end

    function test_instance(n , log :: Bool)
        simulate_asymptotic(n , 14)
    end

    function simulate_asymptotic(n , k)
        lista = Array{Int8, 1}()
        recursive_simulate_asymptotic!(n , k, lista)
    end

    function recursive_simulate_asymptotic!(n , k , lista)
        if k == 0
            for i in 1:n
                push!(lista, Int8(1))
            end
        else
            for i in 1:n
                recursive_simulate_asymptotic!(n , k-1 , lista)
            end
        end
    end

end
