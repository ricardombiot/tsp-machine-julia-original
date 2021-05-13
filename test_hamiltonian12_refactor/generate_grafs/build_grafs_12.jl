module BuildGraf
    using Main.PathsSet.Alias: Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo
    using Main.PathsSet.GrafGenerator
    using Main.PathsSet.GrafWriter

    using Serialization

    mutable struct Builder
        n :: Color
        num_graf :: Int64
        lista_grafos :: Array{Grafo, 1}
        graf_selected :: Union{Grafo, Nothing}
        path :: String
    end

    function new(n :: Color, path :: String)
        init_graf = GrafGenerator.completo(n, Weight(1))

        num_graf = 0
        lista_grafos = Array{Grafo, 1}()
        push!(lista_grafos, init_graf)

        Builder(n, num_graf, lista_grafos, nothing, path)
    end

    function generate(builder :: Builder)
        while !isempty(builder.lista_grafos)
        #if !isempty(builder.lista_grafos)
            graf = popfirst!(builder.lista_grafos)

            builder.graf_selected = graf
            write_graf_seleted!(builder)
            derive_graf_seleted!(builder)
            #generate(builder)
        end
    end

    function write_graf_seleted!(builder :: Builder)
        write_graf!(builder.graf_selected, builder.path, builder.num_graf)
        builder.num_graf += 1
    end

    function write_graf!(graf :: Grafo, path :: String, num_graf :: Int64)
        name = "$(num_graf)"
        comment = "Graf $(num_graf) of all graphs $(graf.n) range {1,2}"
        path_tsp = "$(path)/hcp"
        GrafWriter.write_matrix_hcp!(graf, path_tsp, name, comment)

        path_tsp = "$(path)/tsp"
        GrafWriter.write_tsp!(graf, path_tsp, name, comment)


        println("Write graf $(num_graf) in $path")
    end

    function derive_graf_seleted!(builder :: Builder)
        #derive!(builder, false)
        derive!(builder)
    end

    function derive!(builder :: Builder)
        graf = deepcopy(builder.graf_selected)

        last_dos = get_last_dos(graf)

        if last_dos == nothing
            derive_partial!(builder, Color(0), Color(0))
        else
            #println(last_dos)
            derive_partial!(builder, last_dos[1], last_dos[2])
        end
    end

    function derive_partial!(builder :: Builder, init_origin :: Color, init_destine :: Color)
        graf = deepcopy(builder.graf_selected)
        flag_found_2 = false

        for origen=init_origin:builder.n-1
            for destino=origen:builder.n-1
                #println(" $origen, $destino ")
                weight = Graf.get_weight(graf, origen, destino)

                if destino == init_destine
                    flag_found_2 = true
                end

                if weight == 1 && flag_found_2
                    Graf.add_bidirectional!(graf, origen, destino, Weight(2))
                    push!(builder.lista_grafos, graf)
                    graf = deepcopy(builder.graf_selected)
                end
            end
        end
    end

    function get_last_dos(graf :: Grafo) :: Union{Tuple{Color,Color}, Nothing}
        last_dos = nothing

        for origen=0:graf.n-1
            for destino=origen+1:graf.n-1
                #println(" $origen, $destino ")
                weight = Graf.get_weight(graf, origen, destino)

                if weight == 2
                    last_dos = (origen, destino)
                end
            end
        end

        return last_dos
    end
end
