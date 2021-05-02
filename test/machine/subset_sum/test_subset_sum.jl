

function test_subset_sum()

    lista = [1, -3, 7, -4, -2, -7, 9, -3, -5, 1, -8]
    n = length(lista)
    b = Color(0)
    k = Color(n)
    machine = SubsetSumMachine.new(b, k, lista, true)

    SubsetSumMachine.execute!(machine)

    subset = SubsetSumSolver.get_one_subset_solution(machine)
    println("One Solution:")
    println(subset)
end

test_subset_sum()
