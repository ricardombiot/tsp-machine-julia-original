#bbnn = b^2*n^2
#owner_set = OwnersSet.new(bbnn)
#OwnersSet.push!(owner_set, key)


function test_push_and_pop_key()
    n= Color(4)
    b= Km(10)
    bbnn = UniqueNodeKey(b^2*n^2)
    owners_set = OwnersSet.new(bbnn)
    key = NodeIdentity.calc_key(n, b, ActionId(1), ActionId(1))

    @test OwnersSet.isempty(owners_set)
    OwnersSet.push!(owners_set, key)
    @test !OwnersSet.isempty(owners_set)
    OwnersSet.pop!(owners_set, key)
    @test OwnersSet.isempty(owners_set)
end


function test_operationes_owner_set()
    n= Color(10)
    b= Km(20)

    key1_1 = NodeIdentity.calc_key(n, b, ActionId(1), ActionId(1))
    key2_1 = NodeIdentity.calc_key(n, b, ActionId(2), ActionId(1))
    key3_1 = NodeIdentity.calc_key(n, b, ActionId(3), ActionId(1))
    key4_1 = NodeIdentity.calc_key(n, b, ActionId(4), ActionId(1))
    key6_1 = NodeIdentity.calc_key(n, b, ActionId(6), ActionId(1))

    bbnn = UniqueNodeKey(b^2*n^2)
    owners_set_a = OwnersSet.new(bbnn)
    owners_set_b = OwnersSet.new(bbnn)

    OwnersSet.push!(owners_set_a, key1_1)
    OwnersSet.push!(owners_set_a, key2_1)
    OwnersSet.push!(owners_set_a, key3_1)
    OwnersSet.push!(owners_set_a, key4_1)

    @test OwnersSet.have(owners_set_a, key1_1)
    @test OwnersSet.have(owners_set_a, key2_1)
    @test OwnersSet.have(owners_set_a, key3_1)
    @test OwnersSet.have(owners_set_a, key4_1)


    OwnersSet.push!(owners_set_b, key2_1)
    OwnersSet.push!(owners_set_b, key4_1)
    OwnersSet.push!(owners_set_b, key6_1)

    @test OwnersSet.have(owners_set_b, key2_1)
    @test OwnersSet.have(owners_set_b, key4_1)
    @test OwnersSet.have(owners_set_b, key6_1)


    # UNION

    owners_set_a_copy = deepcopy(owners_set_a)
    OwnersSet.union!(owners_set_a_copy, owners_set_b)

    @test OwnersSet.have(owners_set_a_copy, key1_1)
    @test OwnersSet.have(owners_set_a_copy, key2_1)
    @test OwnersSet.have(owners_set_a_copy, key3_1)
    @test OwnersSet.have(owners_set_a_copy, key4_1)
    @test OwnersSet.have(owners_set_a_copy, key6_1)

    # intersect!

    owners_set_a_copy = deepcopy(owners_set_a)
    OwnersSet.intersect!(owners_set_a_copy, owners_set_b)

    @test OwnersSet.have(owners_set_a_copy, key1_1) == false
    @test OwnersSet.have(owners_set_a_copy, key2_1) == true
    @test OwnersSet.have(owners_set_a_copy, key3_1) == false
    @test OwnersSet.have(owners_set_a_copy, key4_1) == true
    @test OwnersSet.have(owners_set_a_copy, key6_1) == false

    # diff! a / b

    owners_set_a_copy = deepcopy(owners_set_a)
    OwnersSet.diff!(owners_set_a_copy, owners_set_b)

    @test OwnersSet.have(owners_set_a_copy, key1_1) == true
    @test OwnersSet.have(owners_set_a_copy, key2_1) == false
    @test OwnersSet.have(owners_set_a_copy, key3_1) == true
    @test OwnersSet.have(owners_set_a_copy, key4_1) == false
    @test OwnersSet.have(owners_set_a_copy, key6_1) == false

    # diff! b / a

    owners_set_b_copy = deepcopy(owners_set_b)
    OwnersSet.diff!(owners_set_b_copy, owners_set_a)

    @test OwnersSet.have(owners_set_b_copy, key1_1) == false
    @test OwnersSet.have(owners_set_b_copy, key2_1) == false
    @test OwnersSet.have(owners_set_b_copy, key3_1) == false
    @test OwnersSet.have(owners_set_b_copy, key4_1) == false
    @test OwnersSet.have(owners_set_b_copy, key6_1) == true

end


function test_not_colisions_keys_in_owner_set(n :: Color, b :: Km)
    bbnn = UniqueNodeKey(b^2*n^2)
    owners_set = OwnersSet.new(bbnn)
    total_keys = 0
    total_keys_expected = b^2*n^2
    for km_origin in 0:b-1
        for color_origin in 0:n-1

            action_id_parent = GeneratorIds.get_action_id(Color(n), Km(km_origin), Color(color_origin))
            #print(" $action_id_parent [")
            for km_destine in km_origin:b-1
                for color_destine in 0:n-1
                    action_id= GeneratorIds.get_action_id(Color(n), Km(km_destine), Color(color_destine))

                    key = NodeIdentity.calc_key(n, b, action_id, action_id_parent)

                    if OwnersSet.have(owners_set, key)
                        @test false
                    else
                        @test true
                        OwnersSet.push!(owners_set, key)
                        total_keys+= 1
                    end

                    #print(" $key ($action_id, $action_id_parent) ")
                end
            end
            #println("]")
        end
    end

    @test total_keys < total_keys_expected
end

function test_not_collision_keys_hamiltonian_in_owner_set()
    n= Color(4)
    b= Km(4)
    test_not_colisions_keys_in_owner_set(n, b)
end

function test_not_colisions_keys_tsp_in_owner_set()
    n= Color(5)
    b= Km(10)
    test_not_colisions_keys_in_owner_set(n, b)
end

test_push_and_pop_key()
test_not_collision_keys_hamiltonian_in_owner_set()
test_not_colisions_keys_tsp_in_owner_set()
test_operationes_owner_set()
