
function test_create_id()
    n = Color(4)
    @test GeneratorIds.get_action_id(n, Km(0), Color(0)) == ActionId(1)
    @test GeneratorIds.get_info_id(n, ActionId(1)) == (Km(0), Color(0))

    @test GeneratorIds.get_action_id(n, Km(1), Color(0)) == ActionId(5)
    @test GeneratorIds.get_info_id(n, ActionId(5)) == (Km(1), Color(0))
end


function test_matriz_ids()
    n= 4
    action_id = ActionId(1)
    for km in 0:n-1
        #print(" $km [")
        for color in 0:n-1
            action_id_result = GeneratorIds.get_action_id(Color(n), Km(km), Color(color))
            (km_result, color_result) = GeneratorIds.get_info_id(Color(n), action_id_result)
            #print(" $action_id_result ($km_result, $color_result) ")


            @test action_id_result == action_id
            @test km_result == km
            @test color_result == color

            action_id += 1
        end

        #println("]")
    end
end


function test_matriz_tsp_ids()
    km = 10
    n= 4
    action_id = ActionId(1)
    for km in 0:km
        #print(" $km [")
        for color in 0:n-1
            action_id_result = GeneratorIds.get_action_id(Color(n), Km(km), Color(color))
            (km_result, color_result) = GeneratorIds.get_info_id(Color(n), action_id_result)
            #print(" $action_id_result ($km_result, $color_result) ")


            @test action_id_result == action_id
            @test km_result == km
            @test color_result == color

            action_id += 1
        end

        #println("]")
    end
end

test_create_id()
test_matriz_ids()
test_matriz_tsp_ids()
