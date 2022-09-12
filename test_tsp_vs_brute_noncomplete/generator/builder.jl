module BuildGraf
    using Main.PathsSet.Alias: Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.GrafWriter

    function generate(n :: Color, path :: String, min :: Int64, max :: Int64, total :: Int64)
        for num_graf in 0:total-1
            graf_random = GrafGenerator.dirgraf_random(n, min, max)
            write_graf!(graf_random,  path, num_graf)
        end
    end

    function write_graf!(graf :: Grafo, path :: String, num_graf :: Int64)
        name = "$(num_graf)"
        comment = "Graf $(num_graf) random"

        path_tsp = "$(path)"
        GrafWriter.write_tsp!(graf, path_tsp, name, comment)


        println("Write graf $(num_graf) in $path")
    end

end
