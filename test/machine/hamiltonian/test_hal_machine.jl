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
    graph = SolutionReader.get_one_solution_graph(machine)

    #println(graph)
    #println(pwd())
    Graphviz.to_png(graph,"solucion_k$n","./machine/hamiltonian/visual_graphs/grafo_kn")


    #path = PathSolution.load!(graph)
    #println(path)
end

#test_create_machine()

test_create_machine_k(Color(4))
#test_create_machine_k(Color(8))
