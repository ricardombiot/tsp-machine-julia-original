function read_km(timeline :: TimelineDisk, km :: Km) :: Array{String, 1}
    path = get_path_km(timeline, km)

    if isdir(path)
        return readdir(path)
    else
        return Array{String, 1}()
    end
end


function read_cell_parents(timeline :: TimelineDisk, km :: Km, color :: Color) :: Array{String, 1}
    path = get_path_cell_parents(timeline, km, color)

    if isdir(path)
        return readdir(path)
    else
        return Array{String, 1}()
    end
end
