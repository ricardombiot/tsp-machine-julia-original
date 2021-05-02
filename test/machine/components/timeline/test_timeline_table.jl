
function test_create_timeline()
    timeline = TableTimeline.new()

    @test TableTimeline.have_cell(timeline, Km(20), Color(10)) == false
    TableTimeline.create_cell!(timeline, Km(20), Color(10))
    @test TableTimeline.have_cell(timeline, Km(20), Color(10)) == true
end

function test_init_timeline()
    n = Color(4)
    timeline = TableTimeline.new()

    @test TableTimeline.have_cell(timeline, Km(0), Color(0)) == false
    TableTimeline.put_init!(timeline, n, Color(0))
    @test TableTimeline.have_cell(timeline, Km(0), Color(0)) == true

    cell = TableTimeline.get_cell(timeline, Km(0), Color(0))

    @test cell.km == Km(0)
    @test cell.color == Color(0)
    @test cell.parents == ActionsIdSet([])
    @test cell.action_id == ActionId(1)
end

function test_push_parent_timeline()
    timeline = TableTimeline.new()

    @test TableTimeline.have_cell(timeline, Km(20), Color(10)) == false
    TableTimeline.push_parent!(timeline, Km(20), Color(10), ActionId(10))
    @test TableTimeline.have_cell(timeline, Km(20), Color(10)) == true

    cell = TableTimeline.get_cell(timeline, Km(20), Color(10))

    @test cell.km == Km(20)
    @test cell.color == Color(10)
    @test cell.parents == ActionsIdSet([ActionId(10)])
    @test cell.action_id == nothing
end

function test_execute_cell()
    n = Color(4)
    b = Color(4)
    color_origin = Color(1)
    timeline = TableTimeline.new()
    db = DatabaseActions.new(n, b, color_origin)

    @test TableTimeline.have_cell(timeline, Km(0), Color(1)) == false
    TableTimeline.put_init!(timeline, n, color_origin)

    @test TableTimeline.have_cell(timeline, Km(1), Color(2)) == false
    TableTimeline.push_parent!(timeline, Km(1), Color(2), ActionId(2))

    (flag, action_id) = TableTimeline.execute!(timeline, db, Km(1), Color(2))
    @test flag == true
    @test action_id == ActionId(7)

end

test_create_timeline()
test_init_timeline()
test_push_parent_timeline()
test_execute_cell()
