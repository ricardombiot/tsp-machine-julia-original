function test_create_graf()
    g = Graf.new(Color(4))

    @test g.n == Color(4)

end

function test_is_valid_index()
    graf = Graf.new(Color(4))

    #@test Graf.is_valid_index(Color(-1)) == false
    @test Graf.is_valid_index(graf, Color(0)) == true
    @test Graf.is_valid_index(graf, Color(1)) == true
    @test Graf.is_valid_index(graf, Color(2)) == true
    @test Graf.is_valid_index(graf, Color(3)) == true
    @test Graf.is_valid_index(graf, Color(4)) == false
end


function test_add()
    graf = Graf.new(Color(2))

    Graf.add!(graf, Color(0),  Color(1))
    @test graf.count_aristas == 1

    @test Graf.get_weight(graf, Color(0),  Color(1)) == Weight(1)
    @test Graf.get_weight(graf, Color(1),  Color(0)) == nothing

    @test Graf.have_arista(graf, Color(0),  Color(1)) == true
    @test Graf.have_arista(graf, Color(1),  Color(0)) == false


    Graf.add_bidirectional!(graf, Color(0),  Color(1), Weight(10))
    @test graf.count_aristas == 2

    @test Graf.get_weight(graf, Color(0),  Color(1)) == Weight(10)
    @test Graf.get_weight(graf, Color(1),  Color(0)) == Weight(10)

    @test Graf.have_arista(graf, Color(0),  Color(1)) == true
    @test Graf.have_arista(graf, Color(1),  Color(0)) == true
end


function test_create_subdict_destines()
    graf = Graf.new(Color(2))

    @test Graf.destines!(graf, Color(0)) != nothing
    @test Graf.destines!(graf, Color(1)) != nothing
    @test Graf.destines!(graf, Color(2)) == nothing
end

function test_grafo_completo()
    graf = GrafGenerator.completo(Color(3))

    @test Graf.have_arista(graf, Color(0),  Color(1))
    @test Graf.have_arista(graf, Color(0),  Color(2))

    @test Graf.have_arista(graf, Color(1),  Color(0))
    @test Graf.have_arista(graf, Color(1),  Color(2))

    @test Graf.have_arista(graf, Color(2),  Color(1))
    @test Graf.have_arista(graf, Color(2),  Color(0))
end

function test_grafo_completo_weight()
    graf = GrafGenerator.completo(Color(3), Weight(10))

    @test Graf.get_weight(graf, Color(0),  Color(1)) == Weight(10)
    @test Graf.get_weight(graf, Color(0),  Color(2)) == Weight(10)

    @test Graf.get_weight(graf, Color(1),  Color(0)) == Weight(10)
    @test Graf.get_weight(graf, Color(1),  Color(2)) == Weight(10)

    @test Graf.get_weight(graf, Color(2),  Color(1)) == Weight(10)
    @test Graf.get_weight(graf, Color(2),  Color(0)) == Weight(10)
end

test_create_graf()
test_is_valid_index()
test_add()
test_create_subdict_destines()
test_grafo_completo()
test_grafo_completo_weight()
