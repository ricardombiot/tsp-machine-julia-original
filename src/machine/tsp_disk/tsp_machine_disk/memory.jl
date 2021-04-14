function save_info!(machine :: TravellingSalesmanMachineDisk)
    copy_info = deepcopy(machine.info)
    TSPMachineInfoDisk.write!(copy_info, machine.path)
end

function free_memory!(machine :: TravellingSalesmanMachineDisk)
    if machine.info.actual_km > 1
        clear_km = machine.info.actual_km - 1
        DatabaseMemoryControllerDisk.free_memory_actions_step!(machine.db_controller, clear_km, machine.db)
        #DatabaseMemoryController.free_memory_actions_step!(machine.db_controller, clear_km, machine.db)
        TableTimelineDisk.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end



function register_action_to_clean!(machine :: TravellingSalesmanMachineDisk, km_destine_max :: Km, action_id :: ActionId)
    DatabaseMemoryControllerDisk.register!(machine.db_controller, km_destine_max, action_id)
end
