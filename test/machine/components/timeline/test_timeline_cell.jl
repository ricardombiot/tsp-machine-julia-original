
function test_create_cell()
    cell = Cell.new(Km(0), Color(10), ActionId(0))

    @test cell.km == Km(0)
    @test cell.color == Color(10)
    @test cell.action_id == ActionId(0)
end

test_create_cell()
