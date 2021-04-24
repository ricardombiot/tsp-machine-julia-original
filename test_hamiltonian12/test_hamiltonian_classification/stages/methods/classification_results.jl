function write_result_is_hamiltonian!(path :: String, id :: Int64, is_hamiltonian :: Bool)
    if is_hamiltonian
        path_file = "$(path)/hamiltonian/$(id)"
    else
        path_file = "$(path)/non-hamiltonian/$(id)"
    end

    if !isfile(path_file)
        shell_command = `touch $(path_file)`
        run(shell_command)
    end
end


function read_result(path :: String, id :: Int64) :: String
    path_hal_file = "$(path)/hamiltonian/$(id)"
    path_nonhal_file = "$(path)/non-hamiltonian/$(id)"

    if isfile(path_hal_file) && !isfile(path_nonhal_file)
        return "HAMILTONIAN"
    elseif !isfile(path_hal_file) && isfile(path_nonhal_file)
        return "NON-HAMILTONIAN"
    else
        return "ERROR"
    end
end
