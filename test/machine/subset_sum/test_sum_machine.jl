function test_mochilla_machine_negatives()

    lista = [1, 2, -3]
    n = length(lista)
    b = Color(0)
    k = Color(n)
    machine = SubsetSumMachine.new(b, k, lista)

    SubsetSumMachine.execute!(machine)

    list_graphs = SubsetSumSolver.get_all_solution_graphs(machine)

    #println(list_graphs)

    i = 1
    for graph in list_graphs
        name = "graph_$i"
        Graphviz.to_png(graph,name,"./machine/subset_sum/visual_graphs/simple")
        subset = SubsetSumSolver.get_subset_solution_of_graph(machine, graph)
        println("plot graph solution $name")
        println(subset)
        i += 1
    end

end

function test_mochilla_machine_positives()

    lista = [1, 2, 3]
    n = length(lista)
    b = Color(3)
    k = Color(n)
    machine = SubsetSumMachine.new(b, k, lista)

    SubsetSumMachine.execute!(machine)

    subset = SubsetSumSolver.get_one_subset_solution(machine)
    println("One Solution:")
    println(subset)

    list_graphs = SubsetSumSolver.get_all_solution_graphs(machine)
    for graph in list_graphs
        subset = SubsetSumSolver.get_subset_solution_of_graph(machine, graph)
        println("Solution:")
        println(subset)
    end
end

test_mochilla_machine_negatives()
test_mochilla_machine_positives()
