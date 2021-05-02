function test_clasification_hal_machine(n :: Color, id :: Int64, path_results :: String) :: Millisecond
    graf = read_hcpgraph_tsplib_file(id, n)

    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    time = now()
    HalMachine.execute!(machine)
    time_execute = now() - time

    is_hamiltonian = SolutionGraphReader.have_solution(machine)
    write_result_is_hamiltonian!(path_results, id, is_hamiltonian)

    return time_execute
end
