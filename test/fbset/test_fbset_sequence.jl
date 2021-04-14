function test_seq()
    set = FBSet.new(1000)

    # You can insert in sequence without order.
    FBSet.push!(set, 1)
    FBSet.push!(set, 100)
    FBSet.push!(set, 10)
    FBSet.push!(set, 1000)
    FBSet.push!(set, 500)

    list = FBSet.to_list(set)
    @test list == [1,10,100,500,1000]

    @test FBSet.get_next(set, 1) == 1
    @test FBSet.get_next(set, 1) == 1
    @test FBSet.get_next(set, 1) == 1
    FBSet.pop!(set, 1)
    @test FBSet.get_next(set, 1) == 10
    @test FBSet.get_next(set, 1) == 10
    FBSet.pop!(set, 10)
    @test FBSet.get_next(set, 10) == 100
    FBSet.pop!(set, 100)


    @test FBSet.get_next(set, 100) == 500
    FBSet.pop!(set, 500)

    @test FBSet.get_next(set, 500) == 1000
    FBSet.pop!(set, 1000)

    @test FBSet.get_next(set, 1000) == nothing
end

test_seq()
