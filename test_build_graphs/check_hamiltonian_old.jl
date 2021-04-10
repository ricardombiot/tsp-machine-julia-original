include("./../src/main.jl")
using Serialization
using Test




function check_have_hamiltonian_circuit_graf(graf :: Grafo) :: Bool
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    HalMachine.execute!(machine)

    graph = SolutionGraphReader.get_one_solution_graph(machine)

    b = Km(graf.n)
    (tour, path) = PathReader.load!(graf.n, b, graph)
    is_valid_length = path.step == graf.n+1

    optimal = Weight(graf.n)
    checker = PathChecker.new(graf, path, optimal)
    is_valid_path = PathChecker.check!(checker)

    return is_valid_length && is_valid_path
end

function check_hamiltonian_grafs(directory)
    cd(directory)
    lista_serialize_grafs = readdir()

    total_grafs = 0
    total_ok = 0
    for file_graf in lista_serialize_grafs
        total_grafs += 1
        graf = deserialize(file_graf)
        if check_have_hamiltonian_circuit_graf(graf)
            println("$file_graf [OK]")
            total_ok += 1
        else
            println("$file_graf [FAIL]")
            @test false
        end
    end

    return (total_ok / total_grafs) * 100
end


dir = "./grafs"
ratio_valids = check_hamiltonian_grafs(dir)

println("## Valid hamiltonian circuit detection: $(ratio_valids)% ")
