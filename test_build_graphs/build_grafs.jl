module BuildGraf
    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo
    using Serialization

    mutable struct Builder
        graf :: Grafo
        number_edge :: Int64
        num_graf :: Int64
        path :: String
        limit :: Int64
    end

    function new(graf :: Grafo, limit :: Int64, path :: String) :: Builder
        builder = Builder(graf, 0, 0, path, limit)
        write_graf!(builder)

        return builder
    end

    function stop_by_limit(builder :: Builder) :: Bool
        if builder.limit == -1
            return false
        end

        return builder.num_graf < builder.limit
    end

    function generate_graf!(builder :: Builder)
        if !stop_by_limit(builder)
            copy_graf = deepcopy(builder.graf)
            copy_number_edge = deepcopy(builder.number_edge)
            if add_one_arista!(builder.graf, builder.number_edge)
                println("End with complete graph")
                write_graf!(builder)

                builder.number_edge = 0
                generate_graf!(builder)

                builder.graf = copy_graf
                builder.number_edge = copy_number_edge + 1
                generate_graf!(builder)
            end
        end
    end

    function write_graf!(builder :: Builder)
        path = "$(builder.path)/$(builder.num_graf).graf"

        serialize(path, builder.graf)
        builder.num_graf += 1

        println("Write graf $(builder.num_graf) in $path")
    end


    # Añade la arista que no esta numero (number_edge)
    function add_one_arista!(graf :: Grafo, number_edge :: Int64) :: Bool
        n = graf.n

        for origen=0:n-1
            for destino=0:n-1
                if origen != destino
                    if !Graf.have_arista(graf, origen,  destino)
                        if number_edge == 0
                            Graf.add_bidirectional!(graf, origen, destino)
                            return true
                        else
                            number_edge -= 1
                        end
                    end
                end
            end
        end

        return false
    end


end
