function read_tspgraph_tsplib_file(id :: Int64, n :: Color) :: Grafo
    read_tsplib_file(id, n, "tsp")
end

function read_hcpgraph_tsplib_file(id :: Int64, n :: Color) :: Grafo
    read_tsplib_file(id, n, "hcp")
end

function read_tsplib_file(id :: Int64, n :: Color, type :: String) :: Grafo
    path = get_root_data_path()
    name = "$id"
    if type == "tsp"
        path = "$path/grafs$n/tsp"
        extension = ".tsp"
    elseif type == "hcp"
        path = "$path/grafs$n/hcp"
        extension = ".hcp"
    end

    GrafGenerator.read_tsplib_file(name,path,extension)
end


function cast_time_to_int64(ms :: Millisecond) :: Int64
    ms = replace("$ms"," milliseconds" => "")
    ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms")
end

function prepare_folders_results(base_path :: String, name_algorithm :: String) :: String
    if !isdir(base_path)
        mkdir(base_path)
    end

    base_path = "$base_path/$name_algorithm"

    if !isdir(base_path)
        mkdir(base_path)
    end

    path_hamiltonian = "$base_path/hamiltonian"
    if !isdir(path_hamiltonian)
        mkdir(path_hamiltonian)
    end

    path_non_hamiltonian = "$base_path/non-hamiltonian"
    if !isdir(path_non_hamiltonian)
        mkdir(path_non_hamiltonian)
    end

    return base_path
end
