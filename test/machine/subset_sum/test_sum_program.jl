function test_create_program_negative()
    lista = [1, 2, -3]
    n = length(lista)
    b = Color(0)
    k = Color(n)
    program = SubsetSumProgram.new(b, k, lista)

    @test program.base_b == 4
    @test program.max_k == 3
    @test program.next_target == 4
    @test program.fix_b == 4


    @test SubsetSumProgram.get_value(program, Color(0)) == Weight(1)
    @test SubsetSumProgram.get_value(program, Color(1)) == Weight(5)
    @test SubsetSumProgram.get_value(program, Color(2)) == Weight(6)
    @test SubsetSumProgram.get_value(program, Color(3)) == Weight(1)

    @test SubsetSumProgram.get_original_value(program, Color(0)) == nothing
    @test SubsetSumProgram.get_original_value(program, Color(1)) == 1
    @test SubsetSumProgram.get_original_value(program, Color(2)) == 2
    @test SubsetSumProgram.get_original_value(program, Color(3)) == -3

    route_solution = [Color(0), Color(1), Color(2), Color(3)]
    subset_expected = [1, 2, -3]
    @test SubsetSumProgram.get_route_original_values(program, route_solution) == subset_expected

    @test Graf.get_weight(program.graf, Color(0), Color(1)) == Weight(5)
    @test Graf.get_weight(program.graf, Color(0), Color(2)) == Weight(6)
    @test Graf.get_weight(program.graf, Color(0), Color(3)) == Weight(1)

    @test Graf.get_weight(program.graf, Color(1), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(1), Color(2)) == Weight(6)
    @test Graf.get_weight(program.graf, Color(1), Color(3)) == Weight(1)

    @test Graf.get_weight(program.graf, Color(2), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(2), Color(1)) == Weight(5)
    @test Graf.get_weight(program.graf, Color(2), Color(3)) == Weight(1)

    @test Graf.get_weight(program.graf, Color(3), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(3), Color(1)) == Weight(5)
    @test Graf.get_weight(program.graf, Color(3), Color(2)) == Weight(6)

end

function test_create_program_positive()
    lista = [1, 2, 3]
    n = length(lista)
    b = Color(3)
    k = Color(n)
    program = SubsetSumProgram.new(b, k, lista)

    @test program.base_b == 4
    @test program.max_k == 3
    @test program.next_target == 4
    @test program.fix_b == 1


    @test SubsetSumProgram.get_value(program, Color(0)) == Weight(1)
    @test SubsetSumProgram.get_value(program, Color(1)) == Weight(2)
    @test SubsetSumProgram.get_value(program, Color(2)) == Weight(3)
    @test SubsetSumProgram.get_value(program, Color(3)) == Weight(4)

    @test SubsetSumProgram.get_original_value(program, Color(0)) == nothing
    @test SubsetSumProgram.get_original_value(program, Color(1)) == 1
    @test SubsetSumProgram.get_original_value(program, Color(2)) == 2
    @test SubsetSumProgram.get_original_value(program, Color(3)) == 3

    @test Graf.get_weight(program.graf, Color(0), Color(1)) == Weight(2)
    @test Graf.get_weight(program.graf, Color(0), Color(2)) == Weight(3)
    @test Graf.get_weight(program.graf, Color(0), Color(3)) == Weight(4)

    @test Graf.get_weight(program.graf, Color(1), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(1), Color(2)) == Weight(3)
    @test Graf.get_weight(program.graf, Color(1), Color(3)) == Weight(4)

    @test Graf.get_weight(program.graf, Color(2), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(2), Color(1)) == Weight(2)
    @test Graf.get_weight(program.graf, Color(2), Color(3)) == Weight(4)

    @test Graf.get_weight(program.graf, Color(3), Color(0)) == Weight(1)
    @test Graf.get_weight(program.graf, Color(3), Color(1)) == Weight(2)
    @test Graf.get_weight(program.graf, Color(3), Color(2)) == Weight(3)

end

test_create_program_negative()
test_create_program_positive()
