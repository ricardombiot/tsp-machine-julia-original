module TestBuilder
    using Main.PathsSet.Alias: Color, Km
    using Test

    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.ParallelTSPMachine
    using Main.PathsSet.SolutionGraphReader
    using Main.PathsSet.PathReader

    function create_by_n_instance(n_color)
        return GrafGenerator.completo(Color(n_color))
    end

    # crear diferentes instancias por cada iteracion
    function create_by_iter_instance(n_color)
        return nothing
    end

    function test_instance(graf :: Grafo, log :: Bool)
        color_origin = Color(0)
        b_km = Km(graf.n)
        machine = ParallelTSPMachine.new(graf, b_km, color_origin)
        ParallelTSPMachine.execute!(machine)

        if log
           println("## Search solution.. ")
        end
        graph = SolutionGraphReader.get_one_solution_graph(machine)


        if log
           println("## Read tour.. ")
        end
        b = Km(graf.n)
        (tour, path) = PathReader.load!(graf.n, b, graph)
        if log
           println(tour)
        end
        @test path.step == graf.n+1
    end

end
