function test_owners_push_and_pop_key_by_step()
    n= Color(4)
    b= Km(10)
    # Review it testing during migration to Rust... ¿should be b^2*step*n^2?
    bbnn = UniqueNodeKey(b^2*n^2)
    owners = Owners.new(bbnn)
    node_id = NodeIdentity.new(n, b, Step(0), ActionId(1), nothing)


    @test Owners.isempty(owners, Step(0))
    Owners.push!(owners, Step(0), node_id)
    @test Owners.have(owners, Step(0), node_id) == true
    @test !Owners.isempty(owners, Step(0))

    @test Owners.count(owners, Step(0)) == 1

    Owners.pop!(owners, Step(0), node_id)
    @test Owners.have(owners, Step(0), node_id) == false
    @test Owners.isempty(owners, Step(0))
    @test owners.valid == false

    @test Owners.count(owners, Step(0)) == 0
end

#=
        2
/   /         \
5   3         4
|   |         |
4   4         6
\  /          |
  1           1
=#
function test_operations_owner()
    n= Color(10)
    b= Km(20)


    action_id_s0_2 = GeneratorIds.get_action_id(n, Km(0), Color(2))

    action_id_s1_3 = GeneratorIds.get_action_id(n, Km(1), Color(3))
    action_id_s1_4 = GeneratorIds.get_action_id(n, Km(1), Color(4))
    action_id_s1_5 = GeneratorIds.get_action_id(n, Km(1), Color(5))

    action_id_s2_4 = GeneratorIds.get_action_id(n, Km(2), Color(4))
    action_id_s2_6 = GeneratorIds.get_action_id(n, Km(2), Color(6))

    action_id_s3_1 = GeneratorIds.get_action_id(n, Km(3), Color(1))

    node_id_s0_2_2 = NodeIdentity.new(n, Step(0), action_id_s0_2, action_id_s0_2)

    node_id_s1_3_2 = NodeIdentity.new(n, Step(1), action_id_s1_3, action_id_s0_2)
    node_id_s1_4_2 = NodeIdentity.new(n, Step(1),action_id_s1_4, action_id_s0_2)
    node_id_s1_5_2 = NodeIdentity.new(n, Step(1),action_id_s1_5, action_id_s0_2)

    node_id_s2_4_5 = NodeIdentity.new(n, Step(2),action_id_s2_4, action_id_s1_5)
    node_id_s2_4_3 = NodeIdentity.new(n, Step(2),action_id_s2_4, action_id_s1_3)
    node_id_s2_6_4 = NodeIdentity.new(n, Step(2),action_id_s2_6, action_id_s1_4)

    node_id_s3_1_4 = NodeIdentity.new(n, Step(3),action_id_s3_1, action_id_s2_4)
    node_id_s3_1_6 = NodeIdentity.new(n, Step(3),action_id_s3_1, action_id_s2_6)

    bbnn = UniqueNodeKey(b^2*n^2)
    owners_set_a = Owners.new(bbnn)
    owners_set_b = Owners.new(bbnn)

    Owners.push!(owners_set_a, Step(0), node_id_s0_2_2)
    Owners.push!(owners_set_a, Step(1), node_id_s1_3_2)
    Owners.push!(owners_set_a, Step(1), node_id_s1_5_2)
    Owners.push!(owners_set_a, Step(2), node_id_s2_4_3)
    Owners.push!(owners_set_a, Step(2), node_id_s2_4_5)
    Owners.push!(owners_set_a, Step(3), node_id_s3_1_4)

    @test Owners.have(owners_set_a, Step(0), node_id_s0_2_2)
    @test Owners.have(owners_set_a, Step(1), node_id_s1_3_2)
    @test Owners.have(owners_set_a, Step(1), node_id_s1_5_2)
    @test Owners.have(owners_set_a, Step(2), node_id_s2_4_3)
    @test Owners.have(owners_set_a, Step(2), node_id_s2_4_5)
    @test Owners.have(owners_set_a, Step(3), node_id_s3_1_4)

    Owners.push!(owners_set_b, Step(0), node_id_s0_2_2)
    Owners.push!(owners_set_b, Step(1), node_id_s1_4_2)
    Owners.push!(owners_set_b, Step(2), node_id_s2_6_4)
    Owners.push!(owners_set_b, Step(3), node_id_s3_1_6)

    @test Owners.have(owners_set_b, Step(0), node_id_s0_2_2)
    @test Owners.have(owners_set_b, Step(1), node_id_s1_4_2)
    @test Owners.have(owners_set_b, Step(2), node_id_s2_6_4)
    @test Owners.have(owners_set_b, Step(3), node_id_s3_1_6)

    # UNION

    owners_set_a_copy = deepcopy(owners_set_a)
    Owners.union!(owners_set_a_copy, owners_set_b)

    @test Owners.have(owners_set_a_copy, Step(0), node_id_s0_2_2)
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_3_2)
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_5_2)
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_4_3)
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_4_5)
    @test Owners.have(owners_set_a_copy, Step(3), node_id_s3_1_6)

    @test Owners.have(owners_set_a_copy, Step(0), node_id_s0_2_2)
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_4_2)
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_6_4)
    @test Owners.have(owners_set_a_copy, Step(3), node_id_s3_1_6)

    @test Owners.count(owners_set_a_copy, Step(0)) == 1
    @test Owners.count(owners_set_a_copy, Step(1)) == 3
    @test Owners.count(owners_set_a_copy, Step(2)) == 3
    @test Owners.count(owners_set_a_copy, Step(3)) == 2

    # intersect!

    owners_set_a_copy = deepcopy(owners_set_a)
    Owners.intersect!(owners_set_a_copy, owners_set_b)

    @test Owners.have(owners_set_a_copy, Step(0), node_id_s0_2_2) == true
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_3_2) == false
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_5_2) == false
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_4_3) == false
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_4_5) == false
    @test Owners.have(owners_set_a_copy, Step(3), node_id_s3_1_6) == false

    @test Owners.have(owners_set_a_copy, Step(0), node_id_s0_2_2) == true
    @test Owners.have(owners_set_a_copy, Step(1), node_id_s1_4_2) == false
    @test Owners.have(owners_set_a_copy, Step(2), node_id_s2_6_4) == false
    @test Owners.have(owners_set_a_copy, Step(3), node_id_s3_1_6) == false

    @test Owners.count(owners_set_a_copy, Step(0)) == 1
    @test Owners.count(owners_set_a_copy, Step(1)) == 0
    @test Owners.count(owners_set_a_copy, Step(2)) == 0
    @test Owners.count(owners_set_a_copy, Step(3)) == 0

    @test owners_set_a_copy.valid == false

    #=
    # diff! a / b

    owners_set_a_copy = deepcopy(owners_set_a)
    Owners.diff!(owners_set_a_copy, owners_set_b)

    @test Owners.have(owners_set_a_copy, Step(0), node_id_s0_2_2) == false
    @test owners_set_a_copy.valid == false

    # diff! b / a

    owners_set_b_copy = deepcopy(owners_set_b)
    Owners.diff!(owners_set_b_copy, owners_set_a)

    @test Owners.have(owners_set_b_copy, Step(0), node_id_s0_2_2) == false
    @test owners_set_b_copy.valid == false
    =#
end


function test_operations_not_valid_cases()
    n= Color(10)
    b= Km(20)

    action_id_s0_2 = GeneratorIds.get_action_id(n, Km(0), Color(2))
    action_id_s1_3 = GeneratorIds.get_action_id(n, Km(1), Color(3))
    action_id_s2_4 = GeneratorIds.get_action_id(n, Km(2), Color(4))

    node_id_s0_2_2 = NodeIdentity.new(n, Step(0), action_id_s0_2, action_id_s0_2)
    node_id_s1_3_2 = NodeIdentity.new(n, Step(1), action_id_s1_3, action_id_s0_2)
    node_id_s2_1_4 = NodeIdentity.new(n, Step(2), action_id_s2_4, action_id_s1_3)

    bbnn = UniqueNodeKey(b^2*n^2)
    owners_set_a = Owners.new(bbnn)
    owners_set_b = Owners.new(bbnn)

    Owners.push!(owners_set_a, Step(0), node_id_s0_2_2)
    Owners.push!(owners_set_a, Step(2), node_id_s2_1_4)

    @test owners_set_a.valid == false

    Owners.push!(owners_set_b, Step(1), node_id_s2_1_4)

    @test owners_set_b.valid == false


    # union!

    #owners_set_a_copy = deepcopy(owners_set_a) or derive
    owners_set_a_copy = Owners.derive(owners_set_a)
    Owners.union!(owners_set_a_copy, owners_set_b)
    @test owners_set_a_copy.valid == false

    # intersect!

    owners_set_a_copy = deepcopy(owners_set_a)
    Owners.intersect!(owners_set_a_copy, owners_set_b)
    @test owners_set_a_copy.valid == false

    #=
    # diff
    owners_set_a_copy = deepcopy(owners_set_a)
    Owners.diff!(owners_set_a_copy, owners_set_b)

    @test owners_set_a_copy.valid == false

    owners_set_b_copy = deepcopy(owners_set_b)
    Owners.diff!(owners_set_b_copy, owners_set_a)

    @test owners_set_b_copy.valid == false

    =#

end

test_owners_push_and_pop_key_by_step()
test_operations_owner()


test_operations_not_valid_cases()
