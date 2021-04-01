function test_read_grafo_tsplib()
    g = GrafGenerator.read_tsplib_file("dj38","./../../../tsplib")
    @test g.n == 38
    #println("Djibouti Max weight: $(g.max_weight)")
end

function test_read_grafo_tsplib_Western_Sahara()
    g = GrafGenerator.read_tsplib_file("wi29")
    @test g.n == 29
    #println("Western_Sahara Max weight: $(g.max_weight)")
end

function test_read_grafo_tsplib_Qatar()
    g = GrafGenerator.read_tsplib_file("qa194")
    @test g.n == 194
    #println("Qatar Max weight: $(g.max_weight)")
end

test_read_grafo_tsplib()
#test_read_grafo_tsplib_Western_Sahara()
#test_read_grafo_tsplib_Qatar()
