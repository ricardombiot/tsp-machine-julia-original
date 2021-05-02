function test_get_info_node_id()
    n= Color(4)
    b= Km(10)

    node_id = NodeIdentity.new(n, b, Step(0), ActionId(1), nothing)
    (info, info_parent) = NodeIdentity.get_info_node_id(n, node_id)

    @test node_id.key == UniqueNodeKey(1)
    @test info == (Km(0), Color(0))
    @test info_parent == (Km(0), Color(0))


    node_id = NodeIdentity.new(n, b, Step(1), ActionId(6), ActionId(1))
    (info, info_parent) = NodeIdentity.get_info_node_id(n, node_id)

    @test node_id.key == UniqueNodeKey(1606)
    @test info == (Km(1), Color(1))
    @test info_parent == (Km(0), Color(0))

    node_id = NodeIdentity.new(n, b, Step(2), ActionId(10), ActionId(1))
    (info, info_parent) = NodeIdentity.get_info_node_id(n, node_id)

    @test node_id.key == UniqueNodeKey(3210)
    @test info == (Km(2), Color(1))
    @test info_parent == (Km(0), Color(0))
end

function test_not_colisions_keys(n :: Color, b :: Km)
    set = Set()
    total_keys = 0
    max_keys_expected = b^2*n^3
    max_key = nothing
    min_key = nothing

    colisions = false


    for km_origin in 0:b-1
        for color_origin in 0:n-1
            action_id_parent = GeneratorIds.get_action_id(Color(n), Km(km_origin), Color(color_origin))
            #print(" $action_id_parent [")
            for step in 0:n-1

                #print(" STEP: $step [")
                for km_destine in km_origin:b-1
                    for color_destine in 0:n-1
                        action_id= GeneratorIds.get_action_id(Color(n), Km(km_destine), Color(color_destine))

                        key = NodeIdentity.calc_key(n, b, Step(step), action_id, action_id_parent)

                        if key in set
                            @test false
                            colisions = true
                        else
                            @test true
                            push!(set, key)
                            total_keys+= 1
                        end

                        if max_key == nothing
                            max_key = key
                        elseif max_key < key
                            max_key = key
                        end

                        if min_key == nothing
                            min_key = key
                        elseif min_key > key
                            min_key = key
                        end

                        #print(" STEP: $step [ $key ($action_id, $action_id_parent) ]")
                    end
                end
                #println("]")

            end
        end

        #println("]")
    end

    # Hay que optimizar el espacio pero de momento lo important
    # NO COLISIONES
    #println(" Total keys $total_keys < $max_keys_expected [$min_key ,$max_key]")
    @test total_keys < max_keys_expected
    @test max_key <= max_keys_expected
    @test min_key >= UniqueNodeKey(1)
    @test colisions == false
end

function test_keys_hamiltonian()
    n= Color(4)
    b= Km(4)
    test_not_colisions_keys(n, b)
end

function test_keys_tsp()
    n= Color(4)
    b= Km(10)
    test_not_colisions_keys(n, b)
end

test_get_info_node_id()

test_keys_hamiltonian()
test_keys_tsp()


