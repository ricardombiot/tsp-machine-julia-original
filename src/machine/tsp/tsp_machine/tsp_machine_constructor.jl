function new(graf :: Grafo, km_b :: Km, color_origin :: Color = Color(0))
    n = graf.n
    actual_km = Km(0)
    timeline = TableTimeline.new()
    km_solution_recived = nothing


    db = DatabaseActions.new(n, km_b, color_origin)
    db_controller = DatabaseMemoryController.new()
    machine = TravellingSalesmanMachine(n, actual_km, km_b, km_solution_recived, color_origin, graf,
        timeline, db, db_controller)
    init!(machine)

    return machine
end

function init!(machine :: TravellingSalesmanMachine)
    TableTimeline.put_init!(machine.timeline, machine.n, machine.color_origin)
    send_destines!(machine, machine.color_origin)
    machine.actual_km += Km(1)
end
