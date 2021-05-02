function test_clasification_tsp_machine(n :: Color, id :: Int64, path_results :: String) :: Millisecond
    graf = read_tspgraph_tsplib_file(id, n)

    color_origin = Color(0)
    b_km = Km(n)
    machine = TSPMachine.new(graf, b_km, color_origin)

    time = now()
    TSPMachine.execute!(machine)
    time_execute = now() - time

    is_hamiltonian = SolutionGraphReader.have_solution(machine)
    write_result_is_hamiltonian!(path_results, id, is_hamiltonian)

    return time_execute
end
