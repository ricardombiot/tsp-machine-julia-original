using Dates

function test_jumper()
    b_max = 1000
    jumper = MachineJumper.new(b_max)


    MachineJumper.register_km!(jumper, Km(1))
    MachineJumper.register_km!(jumper, Km(200))
    MachineJumper.register_km!(jumper, Km(400))
    MachineJumper.register_km!(jumper, Km(1000))

    list = FBSet.to_list(jumper.set)
    @test list == [1,200,400,1000]

    last = Km(1)
    last = MachineJumper.next_km!(jumper, last)
    @test last == Km(1)
    last = MachineJumper.next_km!(jumper, last)
    @test last == Km(200)
    last = MachineJumper.next_km!(jumper, last)
    @test last == Km(400)
    last = MachineJumper.next_km!(jumper, last)
    @test last == Km(1000)
    last = MachineJumper.next_km!(jumper, last)
    @test last == nothing
end



function test_comparative()
    b_max = 100000

    time = now()
    actual_km = 1
    while actual_km < b_max
        actual_km += 1
        println("#KM $actual_km")
    end
    time_execute_step_by_step = now() - time

    jumper = MachineJumper.new(b_max)

    MachineJumper.register_km!(jumper, Km(1))
    MachineJumper.register_km!(jumper, Km(200))
    MachineJumper.register_km!(jumper, Km(400))
    MachineJumper.register_km!(jumper, Km(1000))
    MachineJumper.register_km!(jumper, Km(10000))
    MachineJumper.register_km!(jumper, Km(100000))
    #MachineJumper.register_km!(jumper, Km(1000000))
    #MachineJumper.register_km!(jumper, Km(100000000))

    time = now()
    last = Km(1)
    while last != nothing
        last = MachineJumper.next_km!(jumper, last)
        println("KM JUMP $last")
    end
    time_execute_jumper = now() - time


    println("# Step by step: $time_execute_step_by_step")
    println("# Jumper: $time_execute_jumper")


end

test_jumper()
#test_comparative()
