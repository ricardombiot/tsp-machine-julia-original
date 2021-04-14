function new(graf :: Grafo, km_b :: Km, color_origin :: Color, path :: String)

    was_init = true
    info = TSPMachineInfoDisk.read!(path)
    if info == nothing
        was_init = false
        info = TSPMachineInfoDisk.new(graf.n, km_b, color_origin)
    end


    timeline = TableTimelineDisk.new(info.n, path)
    db = DatabaseActionsDisk.new(info.n, info.km_b, info.color_origin, path)
    db_controller = DatabaseMemoryControllerDisk.new(path)
    machine = TravellingSalesmanMachineDisk(path, info, graf, timeline, db, db_controller)

    if !was_init
        init!(machine)
    end

    return machine
end

function init!(machine :: TravellingSalesmanMachineDisk)
    DatabaseActionsDisk.init!(machine.db)
    TableTimelineDisk.init!(machine.timeline)
    DatabaseMemoryControllerDisk.init!(machine.db_controller)

    TableTimelineDisk.put_init!(machine.timeline, machine.info.n, machine.info.color_origin)
    send_destines!(machine, machine.info.color_origin)
    machine.info.actual_km += Km(1)
end
