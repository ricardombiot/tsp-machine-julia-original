function new(graf :: Grafo, color_origin :: Color = Color(0))
    n = graf.n
    b = Km(n)
    actual_km = Km(0)
    timeline = TableTimeline.new()


    db = DatabaseActions.new(n, b, color_origin)
    db_controller = DatabaseMemoryController.new()
    machine = HamiltonianMachine(n, actual_km, color_origin, graf, timeline, db, db_controller)
    init!(machine)

    return machine
end

function init!(machine :: HamiltonianMachine)
    TableTimeline.put_init!(machine.timeline, machine.n, machine.color_origin)
    send_destines!(machine, machine.color_origin)
    machine.actual_km += Km(1)
end
