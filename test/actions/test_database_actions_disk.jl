function test_database_actions()
    path = "./actions/disk"
    n = Color(10)
    b = Color(100)
    color_origin = Color(0)
    db = DatabaseActionsDisk.new(n, b, color_origin, path)
    DatabaseActionsDisk.init!(db)

    @test db.n == n
    @test db.b == b

    action0 = DatabaseActionsDisk.get_action(db, ActionId(1))
    @test action0.id == ActionId(1)
    @test action0.km == Km(0)
    @test action0.up_color == color_origin
    @test action0.props_parents == ActionsIdSet(ActionsIdSet([]))
    @test action0.props_graph != nothing
    @test action0.valid == true

    return db
end

function test_generate_action_id()
    path = "./actions/disk"
    n = Color(10)
    b = Color(100)
    color_origin = Color(0)
    db = DatabaseActionsDisk.new(n, b, color_origin, path)
    DatabaseActionsDisk.init!(db)

    expected_action_id = ActionId(1)
    for km in 0:n-1
        #txt_line = "$km => "
        for color in 0:n-1
            color = Color(color)
            km = Color(km)
            action_id = DatabaseActionsDisk.generate_action_id(db, km, color)

            #txt_line *= "| $action_id "
            @test expected_action_id == action_id
            expected_action_id += 1
        end
        #println(txt_line)
    end

end



function test_execute()

    db = test_database_actions()

    action_init = ActionId(1)
    km = Step(1)
    # 0 -> 1
    action_id1 = DatabaseActionsDisk.register_up!(db, km, Color(1),ActionsIdSet([action_init]))
    @test action_id1 == ActionId(12)
    # 0 -> 2
    action_id2 = DatabaseActionsDisk.register_up!(db, km, Color(2),ActionsIdSet([action_init]))
    @test action_id2 == ActionId(13)
    # 0 -> 3
    action_id3 = DatabaseActionsDisk.register_up!(db, km, Color(3),ActionsIdSet([action_init]))
    @test action_id3 == ActionId(14)

    ExecuteActions.run!(db, ActionId(12))
    ExecuteActions.run!(db, ActionId(13))
    ExecuteActions.run!(db, ActionId(14))

    action1 = DatabaseActionsDisk.get_action(db, action_id1)
    @test action1.id == ActionId(12)
    @test action1.km == Km(1)
    @test action1.up_color == Color(1)
    @test action1.props_parents == ActionsIdSet([ActionId(1)])
    @test action1.props_graph != nothing


    action2 = DatabaseActionsDisk.get_action(db, action_id2)
    @test action2.id == ActionId(13)
    @test action2.km == Km(1)
    @test action2.up_color == Color(2)
    @test action2.props_parents == ActionsIdSet([ActionId(1)])
    @test action2.props_graph != nothing

    action3 = DatabaseActionsDisk.get_action(db, action_id3)
    @test action3.id == ActionId(14)
    @test action3.km == Km(1)
    @test action3.up_color == Color(3)
    @test action3.props_parents == ActionsIdSet([ActionId(1)])
    @test action3.props_graph != nothing

end

test_execute()
test_generate_action_id()
