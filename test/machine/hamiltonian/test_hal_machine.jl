
function write_log_owners(graph, name, path)
    input_file = "$path/$(name).txt"
    txt = to_string_nodes_owners(graph)
    open(input_file, "w") do io
        print(io, txt)
    end
end

function to_string_nodes_owners(graph) :: String
    txt = ""
    for (step, nodes) in graph.table_lines
        txt *= "LINE $step \n"
        for node_id in nodes
            node = PathGraph.get_node(graph, node_id)
            txt *= "OWNERS NODE: $(node.step), $(node.color)"
            txt *= "\n"
            txt *= Owners.to_string(node.owners)
            txt *= "\n"
        end
        txt *= "\n"
    end

    return txt
end

function test_create_machine()
    n = Color(3)
    graf = GrafGenerator.completo(n)
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    @test machine.actual_km == Km(1)
    @test HalMachine.make_step!(machine) == true
    @test machine.actual_km == Km(2)
    @test HalMachine.make_step!(machine) == true
    @test machine.actual_km == Km(3)

    graph = SolutionReader.get_one_solution_graph(machine)

    #println(pwd())
    Graphviz.to_png(graph,"solucion_k3","./machine/hamiltonian/visual_graphs/k3")

end

function test_create_machine_k(n :: Color)
    graf = GrafGenerator.completo(n)
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)

    println("Start execution... k$n ")
    time_execution = @timev HalMachine.execute!(machine)
    println("Time execution  k$n: $time_execution ")
    graph = SolutionGraphReader.get_one_solution_graph(machine)

    #println(graph)
    #println(pwd())
    Graphviz.to_png(graph,"solucion_k$n","./machine/hamiltonian/visual_graphs/grafo_kn")

    b = Km(n)
    #

    path = PathReader.new(n, b, graph)
    println(Owners.to_string(graph.owners))
    println(graph.owners.valid)




    println("START CALC! PATH")
    for step in 0:n
        PathReader.next_step!(path)
        Graphviz.to_png(path.graph,"solucion_k$(n)_step$(step)","./machine/hamiltonian/visual_graphs/grafo_kn/pathreader")

        ##write_log_owners(path.graph, "solucion_k$(n)_step$(step)_owners","./machine/hamiltonian/visual_graphs/grafo_kn/pathreader")
        #=
        println("Owner Path $(path.owners.valid)")
        println(Owners.to_string(path.owners))

        println("Owner graph $(path.graph.owners.valid)")
        println(Owners.to_string(path.graph.owners))
        =#
    end

    println(path.route)

    tour = PathReader.load!(n, b, graph)
    println(tour)
end

#test_create_machine()

test_create_machine_k(Color(4))
#test_create_machine_k(Color(8))
