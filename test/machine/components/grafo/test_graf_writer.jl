function test_write_grafo_completo()
    n = Color(3)
    graf = GrafGenerator.completo(n, Weight(1))

    path = "./machine/components/grafo/samples"
    name = "sample1"
    comment = "sample1"
    GrafWriter.write_tsp!(graf, path, name, comment)

    path = "./../../../../test/machine/components/grafo/samples"
    g = GrafGenerator.read_tsplib_file("sample1",path)

    @test Graf.isequal(graf, g)
end


function test_write_hcp_grafo_completo()
    n = Color(4)
    graf = GrafGenerator.completo(n, Weight(1))

    Graf.remove_bidirectional!(graf, Color(0), Color(3))
    Graf.remove_bidirectional!(graf, Color(1), Color(2))

    path = "./machine/components/grafo/samples"
    name = "sample_hcp1"
    comment = "sample_hcp1"
    GrafWriter.write_matrix_hcp!(graf, path, name, comment)

    path = "./../../../../test/machine/components/grafo/samples"
    g = GrafGenerator.read_tsplib_file("sample_hcp1",path,".hcp")

    @test Graf.get_weight(g, Color(0), Color(3)) == nothing
    @test Graf.get_weight(g, Color(1), Color(2)) == nothing

    @test Graf.isequal(graf, g)
end


test_write_grafo_completo()

test_write_hcp_grafo_completo()
