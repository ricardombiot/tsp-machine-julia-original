module TestBuilder
    using Main.PathsSet.Alias: Color, Km
    using Test

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.HalMachine
    using Main.PathsSet.SolutionGraphReader
    using Main.PathsSet.PathReader

    function create_by_n_instance(n_color)
        return GrafGenerator.not_hamiltonian_node_isolated(Color(n_color))
    end

    # crear diferentes instancias por cada iteracion
    function create_by_iter_instance(n_color)
        return nothing
    end

    function test_instance(graf :: Grafo, log :: Bool)
        color_origin = Color(0)
        machine = HalMachine.new(graf, color_origin)
        HalMachine.execute!(machine)

        @test SolutionGraphReader.have_solution(machine) == false
    end

end
