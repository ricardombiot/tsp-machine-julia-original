function test_paths_timeline_disk()
    n = Color(10)
    path = "./machine/timeline/data"
    timeline = TableTimelineDisk.new(n, path)


    @test TableTimelineDisk.get_path_km(timeline, Km(1)) == "./machine/timeline/data/timeline/km1"
    @test TableTimelineDisk.get_path_cell(timeline, Km(100), Color(5)) == "./machine/timeline/data/timeline/km100/color5"
    @test TableTimelineDisk.get_path_cell_parents(timeline, Km(200), Color(10)) == "./machine/timeline/data/timeline/km200/color10/parents"
    #@test TableTimelineDisk.get_path_cell_action_id(timeline, Km(300), Color(25)) == "./machine/timeline/data/timeline/km300/color25/action_id"

end

function test_read_paths_timeline_disk()
    n = Color(10)
    path = "./machine/timeline/data_test"
    timeline = TableTimelineDisk.new(n, path)

    @test TableTimelineDisk.read_km(timeline, Km(1)) == ["color1", "color4"]
    @test TableTimelineDisk.read_cell_parents(timeline, Km(1), Color(1)) == ["parent_10.txt", "parent_12.txt"]
    #@test TableTimelineDisk.read_cell_action_id(timeline, Km(1), Color(1)) == ["action_id_20.txt"]

    @test TableTimelineDisk.read_cell_parents(timeline, Km(1), Color(4)) == ["parent_10.txt", "parent_13.txt"]
    #@test TableTimelineDisk.read_cell_action_id(timeline, Km(1), Color(4)) == ["action_id_22.txt"]


    @test TableTimelineDisk.get_line(timeline, Km(1)) == [Color(1), Color(4)]
    @test TableTimelineDisk.have_km(timeline, Km(1)) == true
    @test TableTimelineDisk.have_cell(timeline, Km(1), Color(1)) == true
    @test TableTimelineDisk.have_cell(timeline, Km(1), Color(2)) == false
    @test TableTimelineDisk.have_cell(timeline, Km(1), Color(3)) == false
    @test TableTimelineDisk.have_cell(timeline, Km(1), Color(4)) == true
    @test TableTimelineDisk.have_km(timeline, Km(2)) == false

    @test TableTimelineDisk.get_parents_cell(timeline, Km(1), Color(1)) == ActionsIdSet([ActionId(10), ActionId(12)])
    @test TableTimelineDisk.get_parents_cell(timeline, Km(1), Color(4)) == ActionsIdSet([ActionId(10), ActionId(13)])
    @test TableTimelineDisk.get_action_id_cell(timeline, Km(1), Color(4)) == GeneratorIds.get_action_id(n, Km(1), Color(4))
end




function test_create_timeline()
    n = Color(10)
    path = "./machine/timeline/data"
    timeline = TableTimelineDisk.new(n, path)

    #@test TableTimelineDisk.have_cell(timeline, Km(20), Color(10)) == false
    TableTimelineDisk.create_cell!(timeline, Km(20), Color(10))
    @test TableTimelineDisk.have_cell(timeline, Km(20), Color(10)) == true
end



function test_init_timeline()
    n = Color(10)
    path = "./machine/timeline/data"
    timeline = TableTimelineDisk.new(n, path)

    TableTimelineDisk.put_init!(timeline, n, Color(0))
    @test TableTimelineDisk.have_cell(timeline, Km(0), Color(0)) == true
    @test TableTimelineDisk.get_line(timeline, Km(0)) == [Color(0)]
end



function test_push_parent_timeline()
    n = Color(10)
    path = "./machine/timeline/data"
    timeline = TableTimelineDisk.new(n, path)

    TableTimelineDisk.push_parent!(timeline, Km(15), Color(2), ActionId(8))
    TableTimelineDisk.push_parent!(timeline, Km(15), Color(2), ActionId(10))
    TableTimelineDisk.push_parent!(timeline, Km(15), Color(2), ActionId(12))
    @test TableTimelineDisk.have_cell(timeline, Km(15), Color(2)) == true

    parents = TableTimelineDisk.get_parents_cell(timeline, Km(15), Color(2))
    @test parents == ActionsIdSet([ActionId(8), ActionId(10), ActionId(12)])

end

function test_execute_cell()
    n = Color(4)
    b = Color(4)
    color_origin = Color(0)
    path = "./machine/timeline/data"
    timeline = TableTimelineDisk.new(n, path)
    db = DatabaseActions.new(n, b, color_origin)



    TableTimelineDisk.put_init!(timeline, n, color_origin)

    action_id_init = GeneratorIds.get_action_id(n, Km(0), color_origin)
    TableTimelineDisk.push_parent!(timeline, Km(1), Color(2), action_id_init)

    (flag, action_id) = TableTimelineDisk.execute!(timeline, db, Km(1), Color(2))
    @test flag == true
    @test action_id == ActionId(7)

end


test_paths_timeline_disk()
test_read_paths_timeline_disk()
test_create_timeline()
test_init_timeline()
test_push_parent_timeline()
test_execute_cell()
