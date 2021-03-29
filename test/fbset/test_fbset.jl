function test_push_item()
    set = FBSet.new(1000)

    FBSet.push!(set, 100)
    @test FBSet.have(set, 100)
end

function test_out_index()
    set = FBSet.new(1000)

    FBSet.push!(set, 1)
    @test FBSet.have(set, 1) == true
    @test FBSet.have(set, 0) == false

    FBSet.push!(set, 1000)
    @test FBSet.have(set, 1000) == true
    @test FBSet.have(set, 1001) == false
end

function test_push_and_pop_item()
    set = FBSet.new(1000)

    for i in 1:1000
        FBSet.push!(set, i)
        @test FBSet.have(set, i)
        FBSet.pop!(set, i)
        @test !FBSet.have(set, i)
    end

    @test !FBSet.isempty(set)
end

function build_fbset_full(n)
    set = FBSet.new(n)

    for i in 1:n
        FBSet.push!(set, i)
    end

    return set
end


function test_full_to_empty()
    set_full = build_fbset_full(1000)

    @test !FBSet.isempty(set_full)
    FBSet.to_empty!(set_full)
    @test FBSet.isempty(set_full)
end

function test_full_1k()
    set_full = build_fbset_full(1000)

    for i in 1:1000
        @test FBSet.have(set_full, i)
    end

    @test !FBSet.isempty(set_full)
    @test FBSet.isfull(set_full)


end

function test_equals()

    set_a = FBSet.new(500)
    set_b = FBSet.new(500)
    @test FBSet.isequal(set_a, set_b) == true

    set_full = build_fbset_full(1000)
    set_empty = FBSet.new(500)
    @test FBSet.isequal(set_empty, set_full) == false

    set_empty = FBSet.new(1000)
    @test FBSet.isequal(set_empty, set_full) == false
end

function test_not_full_last_subset()
    set_full = build_fbset_full(1000)
    for i in 897:1000
        FBSet.pop!(set_full, i)
    end
    @test !FBSet.isfull(set_full)
end

function test_not_full_middle()
    set_full = build_fbset_full(1000)
    FBSet.pop!(set_full, 500)
    @test !FBSet.isfull(set_full)
end

function test_not_full_one_subset()
    set_full = build_fbset_full(1000)
    for i in 129:128+128
        FBSet.pop!(set_full, i)
    end

    @test !FBSet.isfull(set_full)
end


function test_union_sets_1k()

    set_pares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 0
            FBSet.push!(set_pares, item)
        end
    end

    set_impares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 1
            FBSet.push!(set_impares, item)
        end
    end
    @test !FBSet.isfull(set_pares)
    @test !FBSet.isfull(set_impares)


    FBSet.union!(set_pares, set_impares)
    set_union = deepcopy(set_pares)
    @test FBSet.isfull(set_union)
end

function test_intersection_sets_1k()

    set_pares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 0
            FBSet.push!(set_pares, item)
        end
    end

    set_impares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 1
            FBSet.push!(set_impares, item)
        end
    end

    # al conjunto completo
    set_full = build_fbset_full(1000)
    @test FBSet.isfull(set_full)
    # le quito interseciono los impares, conjunto completo pasa a ser impares.
    FBSet.intersect!(set_full, set_impares)
    FBSet.isequal(set_full, set_impares)

    # si le uno el conjunto de pares, vuelve a estar completo
    @test !FBSet.isfull(set_full)
    FBSet.union!(set_full, set_pares)
    @test FBSet.isfull(set_full)
end

function test_diff_sets_1k()

    set_pares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 0
            FBSet.push!(set_pares, item)
        end
    end

    set_impares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 1
            FBSet.push!(set_impares, item)
        end
    end

    # al conjunto completo
    set_full = build_fbset_full(1000)
    @test FBSet.isfull(set_full)

    # Si hago la diferencia del conjunto completo con los impares obtengo los pares
    FBSet.diff!(set_full, set_impares)
    FBSet.isequal(set_full, set_pares)

    # Si hago la union con los impares entonces obtengo el conjunto completo.
    @test !FBSet.isfull(set_full)
    FBSet.union!(set_full, set_impares)
    @test FBSet.isfull(set_full)
end

function test_diff_equal_fbsets()
    # La differencia entre dos conjuntos iguales es vacio

    set_pares = FBSet.new(1000)
    for item in 1:1000
        if rem(item,2) == 0
            FBSet.push!(set_pares, item)
        end
    end

    set_pares_copy = deepcopy(set_pares)
    @test FBSet.isequal(set_pares_copy, set_pares)
    FBSet.diff!(set_pares_copy, set_pares)
    @test FBSet.isempty(set_pares_copy)
end

function create_subsets_pares_impares()

    set_subsets_pares = FBSet.new(1000)
    for item in 1:1000
        id = FBSet.get_subset_id(set_subsets_pares, item)
        if rem(id,2) == 0
            FBSet.push!(set_subsets_pares, item)
        end
    end

    set_subsets_impares = FBSet.new(1000)
    for item in 1:1000
        id = FBSet.get_subset_id(set_subsets_impares, item)
        if rem(id,2) == 1
            FBSet.push!(set_subsets_impares, item)
        end
    end

    return (set_subsets_pares, set_subsets_impares)
end


function test_union_sets_subsets_1k()
    (set_subsets_pares, set_subsets_impares) = create_subsets_pares_impares()

    @test !FBSet.isfull(set_subsets_pares)
    @test !FBSet.isfull(set_subsets_impares)


    FBSet.union!(set_subsets_pares, set_subsets_impares)
    set_union = deepcopy(set_subsets_pares)
    @test FBSet.isfull(set_union)
end

function test_intersection_sets_subsets_1k()

    (set_subsets_pares, set_subsets_impares) = create_subsets_pares_impares()

    # al conjunto completo
    set_full = build_fbset_full(1000)
    @test FBSet.isfull(set_full)
    # le quito interseciono los impares, conjunto completo pasa a ser impares.
    FBSet.intersect!(set_full, set_subsets_impares)
    FBSet.isequal(set_full, set_subsets_impares)

    # si le uno el conjunto de pares, vuelve a estar completo
    @test !FBSet.isfull(set_full)
    FBSet.union!(set_full, set_subsets_pares)
    @test FBSet.isfull(set_full)

    # Si hago la intersecion del conjunto impares con el de pares obtengo vacio
    FBSet.intersect!(set_subsets_pares, set_subsets_impares)
    @test FBSet.isempty(set_subsets_pares)
end


function test_diff_sets_subsets_1k()
    (set_subsets_pares, set_subsets_impares) = create_subsets_pares_impares()

    # al conjunto completo
    set_full = build_fbset_full(1000)
    @test FBSet.isfull(set_full)

    # Si hago la diferencia del conjunto completo con los impares obtengo los pares
    FBSet.diff!(set_full, set_subsets_impares)
    FBSet.isequal(set_full, set_subsets_pares)

    # Si hago la union con los impares entonces obtengo el conjunto completo.
    @test !FBSet.isfull(set_full)
    FBSet.union!(set_full, set_subsets_impares)
    @test FBSet.isfull(set_full)

    # Si hago la diferencia del conjunto pares y impares, no hay cambios
    set_subsets_pares_original = deepcopy(set_subsets_pares)
    FBSet.diff!(set_subsets_pares, set_subsets_impares)

    @test FBSet.isequal(set_subsets_pares, set_subsets_pares_original)

    # Si hago la diferencia del conjunto impares y pares, no hay cambios
    set_subsets_impares_original = deepcopy(set_subsets_impares)
    FBSet.diff!(set_subsets_pares_original, set_subsets_impares)

    @test FBSet.isequal(set_subsets_impares, set_subsets_impares_original)
end

function test_operaciones_conjuntos()
    set_a = FBSet.new(1000)
    set_b = FBSet.new(1000)

    FBSet.push!(set_a, [1, 200, 300, 400])
    FBSet.push!(set_b, [200, 400, 600])

    @test FBSet.have_items(set_a, [1, 200, 300, 400, 600]) == [true, true, true, true, false]
    @test FBSet.have_items(set_b, [1, 200, 300, 400, 600]) == [false, true, false, true, true]


    # uniones
    set_a_mutable = deepcopy(set_a)
    FBSet.union!(set_a_mutable, set_b)
    @test FBSet.have_items(set_a_mutable, [1, 200, 300, 400, 600]) == [true, true, true, true, true]

    set_b_mutable = deepcopy(set_b)
    FBSet.union!(set_b_mutable, set_a)
    @test FBSet.have_items(set_b_mutable, [1, 200, 300, 400, 600]) == [true, true, true, true, true]

    # intersect
    set_a_mutable = deepcopy(set_a)
    FBSet.intersect!(set_a_mutable, set_b)
    @test FBSet.have_items(set_a_mutable, [1, 200, 300, 400, 600]) == [false, true, false, true, false]

    set_b_mutable = deepcopy(set_b)
    FBSet.intersect!(set_b_mutable, set_a)
    @test FBSet.have_items(set_b_mutable, [1, 200, 300, 400, 600]) == [false, true, false, true, false]


    # diff
    set_a_mutable = deepcopy(set_a)
    FBSet.diff!(set_a_mutable, set_b)
    @test FBSet.have_items(set_a_mutable, [1, 200, 300, 400, 600]) == [true, false, true, false, false]

    set_b_mutable = deepcopy(set_b)
    FBSet.diff!(set_b_mutable, set_a)
    @test FBSet.have_items(set_b_mutable, [1, 200, 300, 400, 600]) == [false, false, false, false, true]


end

function println_subsets(set)
    for id in 1:set.n_subsets
        if haskey(set.subsets, id)
            txt = bitstring(set.subsets[id].content)
            println(txt)
        else
            println("nothing")
        end
    end
end

#==#
test_push_item()
test_out_index()
test_full_1k()
test_full_to_empty()
test_push_and_pop_item()

test_equals()
test_not_full_middle()
test_not_full_one_subset()
test_not_full_last_subset()


test_union_sets_1k()
test_intersection_sets_1k()
test_diff_sets_1k()

test_union_sets_subsets_1k()
test_intersection_sets_subsets_1k()
test_diff_sets_subsets_1k()
test_diff_equal_fbsets()

test_operaciones_conjuntos()

#=
println("##### FBSet: ##### ")
println("##### [FBSet] build_full: ##### ")
@timev set_full = build_fbset_full(10000)
using Serialization
io = IOBuffer();
serialize(io, set_full)

size = length(String(take!(io)))
println("SIZE FULL SET: $size" )
=#
