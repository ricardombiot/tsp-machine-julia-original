module GrafGenerator
    using Main.PathsSet.Alias: Color, Weight
    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo
    using TSPLIB

    function completo(n :: Color, peso :: Weight = Weight(1)) :: Grafo
        g = Graf.new(n)

        for origen=0:n-1
            for destino=0:n-1
                if origen != destino
                    Graf.add_bidirectional!(g, origen, destino, peso)
                end
            end
        end

        return g
    end

    function cycle(n :: Color, peso :: Weight = Weight(1)) :: Grafo
        g = Graf.new(n)
        for i in 0:n-1
            next = i+1
            if next > n-1
                next = 0
            end

            Graf.add_bidirectional!(g, Color(i), Color(next), peso)
        end

        return g
    end

    function read_tsplib_file(name :: String, path :: String = "./../../../../tsplib", extension :: String = ".tsp") :: Grafo
        file_path = "$path/$(name)$(extension)"
        lib = readTSP(joinpath(@__DIR__, file_path))

        n = Color(lib.dimension)
        g = Graf.new(n)

        for origin in 1:lib.dimension
            ori = Color(origin-1)

            for destine in 1:lib.dimension
                dest = Color(destine-1)

                peso = Weight(lib.weights[origin, destine])
                if ori != dest && peso > 0
                    Graf.add_bidirectional!(g, ori, dest, peso)
                end
            end
        end

        return g
    end

    #=
                0   -  1
            /    \    /  \
            4 -   2   -  3
    =#
    function grafo_ciclo_simple() :: Grafo
        n = Color(5)
        g = Graf.new(n)

        Graf.add_bidirectional!(g, Color(0), [Color(1), Color(2), Color(4)])
        Graf.add_bidirectional!(g, Color(1), [Color(0), Color(2), Color(3)])
        Graf.add_bidirectional!(g, Color(2), [Color(0), Color(1), Color(3), Color(4)])
        Graf.add_bidirectional!(g, Color(3), [Color(1), Color(2)])
        Graf.add_bidirectional!(g, Color(4), [Color(0), Color(2)])

        return g
    end

    function dodecaedro() :: Grafo
        n = Color(20)
        g = Graf.new(n)

        Graf.add_bidirectional!(g, Color(0), [Color(1), Color(2), Color(5)])
        Graf.add_bidirectional!(g, Color(1), [Color(0), Color(3), Color(7)])
        Graf.add_bidirectional!(g, Color(2), [Color(0), Color(4), Color(13)])
        Graf.add_bidirectional!(g, Color(3), [Color(1), Color(4), Color(9)])
        Graf.add_bidirectional!(g, Color(4), [Color(2), Color(3), Color(11)])
        Graf.add_bidirectional!(g, Color(5), [Color(0), Color(6), Color(14)])
        Graf.add_bidirectional!(g, Color(6), [Color(5), Color(7), Color(16)])
        Graf.add_bidirectional!(g, Color(7), [Color(1), Color(6), Color(8)])
        Graf.add_bidirectional!(g, Color(8), [Color(7), Color(9), Color(17)])
        Graf.add_bidirectional!(g, Color(9), [Color(3), Color(8), Color(10)])
        Graf.add_bidirectional!(g, Color(10), [Color(9), Color(18), Color(11)])
        Graf.add_bidirectional!(g, Color(11), [Color(4), Color(12), Color(10)])
        Graf.add_bidirectional!(g, Color(12), [Color(11), Color(13), Color(19)])
        Graf.add_bidirectional!(g, Color(13), [Color(2), Color(14), Color(12)])
        Graf.add_bidirectional!(g, Color(14), [Color(5), Color(15), Color(13)])
        Graf.add_bidirectional!(g, Color(15), [Color(14), Color(16), Color(19)])
        Graf.add_bidirectional!(g, Color(16), [Color(15), Color(6), Color(17)])
        Graf.add_bidirectional!(g, Color(17), [Color(16), Color(18), Color(8)])
        Graf.add_bidirectional!(g, Color(18), [Color(17), Color(19), Color(10)])
        Graf.add_bidirectional!(g, Color(19), [Color(12), Color(18), Color(15)])

        return g
    end

end
