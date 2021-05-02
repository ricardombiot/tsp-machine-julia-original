function test_create_controller()
    path = "./actions/disk"
    controller = DatabaseMemoryControllerDisk.new(path)
    DatabaseMemoryControllerDisk.init!(controller)

    DatabaseMemoryControllerDisk.register!(controller, Km(10), ActionId(100))
    DatabaseMemoryControllerDisk.register!(controller, Km(10), ActionId(101))


    list = DatabaseMemoryControllerDisk.read_km(controller, Km(10))
    @test list == ["action_100.txt", "action_101.txt"]

end

function test_free_controller()
    path = "./actions/disk"
    controller = DatabaseMemoryControllerDisk.new(path)
    DatabaseMemoryControllerDisk.init!(controller)


    n = Color(10)
    b = Color(1000)
    color_origin = Color(0)
    db = DatabaseActions.new(n, b, color_origin)

    action_init = ActionId(1)
    km = Km(20)
    action_id1 = DatabaseActions.register_up!(db, km, Color(1), ActionsIdSet([action_init]))
    action_id2 = DatabaseActions.register_up!(db, km, Color(2), ActionsIdSet([action_init]))


    DatabaseMemoryControllerDisk.register!(controller, Km(20), action_id1)
    DatabaseMemoryControllerDisk.register!(controller, Km(20), action_id2)


    list = DatabaseMemoryControllerDisk.read_km(controller, Km(20))
    @test list == ["action_$action_id1.txt", "action_$action_id2.txt"]

    action1 = DatabaseActions.get_action(db, action_id1)
    @test action1 != nothing

    action2 = DatabaseActions.get_action(db, action_id2)
    @test action2 != nothing

    DatabaseMemoryControllerDisk.free_memory_actions_step!(controller, Km(20), db)

    action1 = DatabaseActions.get_action(db, action_id1)
    @test action1 == nothing

    action2 = DatabaseActions.get_action(db, action_id2)
    @test action2 == nothing

    list = DatabaseMemoryControllerDisk.read_km(controller, Km(20))
    @test list == []

end

test_create_controller()
test_free_controller()
