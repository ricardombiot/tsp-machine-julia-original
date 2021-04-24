function state_verification!(data :: DataClassification)
    total_ok = 0
    total_tsp_verficate = 0
    for id in 0:data.total-1
        result_tsp = read_result(data.path_tsp_machine, id)
        result_hal = read_result(data.path_hal_machine, id)

        result_brute = read_result(data.path_tsp_brute, id)
        verificate_tsp = result_tsp == result_brute

        if result_tsp == result_hal && result_tsp != "ERROR"
            total_ok += 1

            if verificate_tsp
                total_tsp_verficate += 1
            end
        else
            println("Error $id")
        end
    end

    data.rate_ok = (total_ok / data.total) * 100
    data.rate_tsp_verificate = (total_tsp_verficate / data.total) * 100
end
