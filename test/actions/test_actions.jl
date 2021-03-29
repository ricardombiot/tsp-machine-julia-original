function test_create_action()
    n = Color(10)
    b = Km(10)
    color_origin = Color(0)
    action = Actions.new_init(n, b, color_origin)

    @test action.up_color == Color(0)
    @test action.props_graph != nothing
end


test_create_action()
