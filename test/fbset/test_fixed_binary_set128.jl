function test_push_and_pop_item()

    for item in 1:128
        set = FBSet128.new()
        @test FBSet128.isempty(set)
        FBSet128.push!(set, item)
        @test set.content == UInt128(1) << (item-1)
        FBSet128.pop!(set, item)
        @test FBSet128.isempty(set)
    end

end

function test_push_item()

    for item in 1:128
        set = FBSet128.new()
        FBSet128.push!(set, item)
        @test set.content == UInt128(1) << (item-1)
        binary_txt = bitstring(set.content)
        bit_number = 128 - (item-1)
        @test binary_txt[bit_number] == '1'
        @test FBSet128.have(set, item)
    end

end

function build_full_set()
    set = FBSet128.new()

    for item in 1:128
        FBSet128.push!(set, item)
    end

    return set
end

function test_full_set()
    set = build_full_set()

    @test FBSet128.isfull(set)
end

function test_pop_item()
    set_full = build_full_set()

    for item in 1:128
        set = deepcopy(set_full)
        FBSet128.pop!(set, item)
        @test !FBSet128.isfull(set)
        binary_txt = bitstring(set.content)
        bit_number = 128 - (item-1)
        @test binary_txt[bit_number] == '0'
    end

end

function test_union_sets()

    set_pares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 0
            FBSet128.push!(set_pares, item)
        end
    end

    set_impares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 1
            FBSet128.push!(set_impares, item)
        end
    end
    @test !FBSet128.isfull(set_pares)
    @test !FBSet128.isfull(set_impares)


    FBSet128.union!(set_pares, set_impares)
    set_union = deepcopy(set_pares)
    @test FBSet128.isfull(set_union)
end


function test_intersection_sets()

    set_pares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 0
            FBSet128.push!(set_pares, item)
        end
    end

    set_impares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 1
            FBSet128.push!(set_impares, item)
        end
    end

    # al conjunto completo
    set_full = build_full_set()
    @test FBSet128.isfull(set_full)
    # le quito interseciono los impares, conjunto completo pasa a ser impares.
    FBSet128.intersect!(set_full, set_impares)
    @test set_full.content == set_impares.content
    @test FBSet128.isequal(set_full, set_impares)

    # si le uno el conjunto de pares, vuelve a estar completo
    @test !FBSet128.isfull(set_full)
    FBSet128.union!(set_full, set_pares)
    @test FBSet128.isfull(set_full)
end


function test_diff_sets()

    set_pares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 0
            FBSet128.push!(set_pares, item)
        end
    end

    set_impares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 1
            FBSet128.push!(set_impares, item)
        end
    end

    # al conjunto completo
    set_full = build_full_set()
    @test FBSet128.isfull(set_full)

    # Si hago la diferencia del conjunto completo con los impares obtengo los pares
    FBSet128.diff!(set_full, set_impares)
    @test set_full.content == set_pares.content

    # Si hago la union con los impares entonces obtengo el conjunto completo.
    @test !FBSet128.isfull(set_full)
    FBSet128.union!(set_full, set_impares)
    @test FBSet128.isfull(set_full)

    # Si hago la diferencia del conjunto pares y impares, no hay cambios
    set_pares_original = deepcopy(set_pares)
    FBSet128.diff!(set_pares, set_impares)

    @test FBSet128.isequal(set_pares, set_pares_original)

    # Si hago la diferencia del conjunto impares y pares, no hay cambios
    set_impares_original = deepcopy(set_impares)
    FBSet128.diff!(set_pares_original, set_impares)

    @test FBSet128.isequal(set_impares, set_impares_original)
end


function test_diff_equal_sets()
    # La differencia entre dos conjuntos iguales es vacio

    set_pares = FBSet128.new()
    for item in 1:128
        if rem(item,2) == 0
            FBSet128.push!(set_pares, item)
        end
    end

    set_pares_copy = deepcopy(set_pares)
    @test FBSet128.isequal(set_pares_copy, set_pares)
    FBSet128.diff!(set_pares_copy, set_pares)
    @test FBSet128.isempty(set_pares_copy)
end

function test_to_empty_and_to_full()
    set = FBSet128.new()
    @test FBSet128.isempty(set)

    FBSet128.to_full!(set)
    @test !FBSet128.isempty(set)
    @test FBSet128.isfull(set)

    FBSet128.to_empty!(set)
    @test FBSet128.isempty(set)
    @test !FBSet128.isfull(set)
end


function test_out_range()
    set = FBSet128.new()
    @test FBSet128.have(set, 0) == false
    @test FBSet128.have(set, 129) == false
end

function test_operaciones_conjuntos()
    set_a = FBSet128.new()
    set_b = FBSet128.new()

    FBSet128.push!(set_a, [1, 2, 3, 4])
    FBSet128.push!(set_b, [2, 4, 6])

    @test FBSet128.have_items(set_a, [1, 2, 3, 4, 6]) == [true, true, true, true, false]
    @test FBSet128.have_items(set_b, [1, 2, 3, 4, 6]) == [false, true, false, true, true]


    # uniones
    set_a_mutable = deepcopy(set_a)
    FBSet128.union!(set_a_mutable, set_b)
    @test FBSet128.have_items(set_a_mutable, [1, 2, 3, 4, 6]) == [true, true, true, true, true]

    set_b_mutable = deepcopy(set_b)
    FBSet128.union!(set_b_mutable, set_a)
    @test FBSet128.have_items(set_b_mutable, [1, 2, 3, 4, 6]) == [true, true, true, true, true]

    # intersect
    set_a_mutable = deepcopy(set_a)
    FBSet128.intersect!(set_a_mutable, set_b)
    @test FBSet128.have_items(set_a_mutable, [1, 2, 3, 4, 6]) == [false, true, false, true, false]

    set_b_mutable = deepcopy(set_b)
    FBSet128.intersect!(set_b_mutable, set_a)
    @test FBSet128.have_items(set_b_mutable, [1, 2, 3, 4, 6]) == [false, true, false, true, false]


    # diff
    set_a_mutable = deepcopy(set_a)
    FBSet128.diff!(set_a_mutable, set_b)
    @test FBSet128.have_items(set_a_mutable, [1, 2, 3, 4, 6]) == [true, false, true, false, false]

    set_b_mutable = deepcopy(set_b)
    FBSet128.diff!(set_b_mutable, set_a)
    @test FBSet128.have_items(set_b_mutable, [1, 2, 3, 4, 6]) == [false, false, false, false, true]


end

test_push_item()
test_push_and_pop_item()
test_full_set()
test_pop_item()
test_union_sets()
test_intersection_sets()
test_diff_sets()
test_to_empty_and_to_full()
test_out_range()

test_diff_equal_sets()

test_operaciones_conjuntos()
