module GrafWriter

    using Main.PathsSet.Alias: Color, Weight
    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    function write_tsp!(graf :: Grafo, path :: String, name :: String, comment :: String)
        path = "$path/$name.tsp"

        open(path, "w") do io
            write(io, "NAME : $name \n")
            write(io, "TYPE: TSP \n")
            write(io, "COMMENT : $comment \n")
            write(io, "DIMENSION : $(graf.n) \n")
            write(io, "EDGE_WEIGHT_TYPE: EXPLICIT \n")
            write(io, "EDGE_WEIGHT_FORMAT: FULL_MATRIX \n")
            write(io, "EDGE_WEIGHT_SECTION\n")

            for origen=0:graf.n-1
                for destino=0:graf.n-1

                    if origen == destino
                        write(io, "0")
                    else
                        if Graf.have_arista(graf, origen, destino)
                            weight = Graf.get_weight(graf, origen, destino)
                            write(io, "$weight")
                        else
                            write(io, "0")
                        end
                    end

                    if destino != graf.n-1
                        write(io, " ")
                    end
                end
                write(io, "\n")
            end

            write(io, "EOF")
        end
    end


    function write_matrix_hcp!(graf :: Grafo, path :: String, name :: String, comment :: String)
        path = "$path/$name.hcp"

        open(path, "w") do io
            write(io, "NAME : $name \n")
            write(io, "TYPE: HCP \n")
            write(io, "COMMENT : $comment \n")
            write(io, "DIMENSION : $(graf.n) \n")
            write(io, "EDGE_WEIGHT_TYPE: EXPLICIT \n")
            write(io, "EDGE_WEIGHT_FORMAT: FULL_MATRIX \n")
            write(io, "EDGE_WEIGHT_SECTION\n")

            for origen=0:graf.n-1
                for destino=0:graf.n-1

                    if origen == destino
                        write(io, "0")
                    else
                        if Graf.have_arista(graf, origen, destino)
                            weight = Graf.get_weight(graf, origen, destino)

                            if weight == Weight(1)
                                write(io, "1")
                            else
                                write(io, "0")
                            end
                        else
                            write(io, "0")
                        end
                    end

                    if destino != graf.n-1
                        write(io, " ")
                    end
                end
                write(io, "\n")
            end

            write(io, "EOF")
        end
    end

    #=
    TSPLIB julia dont support hcp...
    function write_hcp!(graf :: Grafo, path :: String, name :: String, comment :: String)
        path = "$path/$name.hcp"

        open(path, "w") do io
            write(io, "NAME : $name \n")
            write(io, "TYPE: HCP \n")
            write(io, "COMMENT : $comment \n")
            write(io, "DIMENSION : $(graf.n) \n")
            write(io, "EDGE_WEIGHT_TYPE: EXPLICIT \n")
            write(io, "EDGE_DATA_FORMAT : EDGE_LIST \n")
            write(io, "EDGE_DATA_SECTION \n")

            for origen=0:graf.n-1
                for destino=0:graf.n-1
                    if origen != destino
                        if Graf.have_arista(graf, origen, destino)
                            weight = Graf.get_weight(graf, origen, destino)

                            if weight == Weight(1)
                                write(io, "$origen $destino\n")
                            end
                        end
                    end
                end
            end

            write(io, "EOF")
        end
    end
    =#

end
