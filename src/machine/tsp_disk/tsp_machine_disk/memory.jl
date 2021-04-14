function save_info!(machine :: TravellingSalesmanMachineDisk)
    copy_info = deepcopy(machine.info)
    TSPMachineInfoDisk.write!(copy_info, machine.path)
end

function free_memory!(machine :: TravellingSalesmanMachineDisk)
    if machine.info.actual_km > 1
        clear_km = machine.info.actual_km - 1
        #DatabaseMemoryController.free_memory_actions_step!(machine.db_controller, clear_km, machine.db)
        TableTimelineDisk.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end
