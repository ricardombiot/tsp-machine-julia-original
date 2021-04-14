module SubsetSumProgram
    using Main.PathsSet.Alias: Km, Color, Weight, ActionId, ActionsIdSet, Step
    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    using Main.PathsSet.PathGraph: Graph
    using Main.PathsSet.Actions: Action

    mutable struct SumProgram
        # B max weight
        base_b :: Km

        # Numero de items
        max_k :: Color

        # (KM Target + fix_b + fix_b + fix_b...
        next_target :: Union{Km, Nothing}

        max_target :: Km

        # Ajuste de B
        fix_b :: Km

        # the nodes values
        table_nodes_values :: Dict{Color, Weight}

        # graf program of machine
        graf :: Union{Grafo, Nothing}

        # table of graphs solutions by Lenght
        table_graphs_solutions :: Dict{Step, Array{Graph,1}}
        have_solution :: Bool
    end

    function new(b :: Km, k :: Color, lista :: Array{Int64,1})
        min = minimum(lista)
        if min < 0
            fix_b = abs(min) + 1
        else
            fix_b = 1
        end

        lista = map(x -> x+fix_b, lista)
        b = b + fix_b
        next_target = b
        max_target = Km(b*k)
        graf = nothing
        table_nodes_values = Dict{Color, Weight}()
        table_graphs_solutions = Dict{Step, Array{Graph,1}}()
        have_solution = false
        program = SumProgram(b, k, next_target, max_target, fix_b,
            table_nodes_values, graf, table_graphs_solutions, have_solution)

        init!(program, lista)

        return program
    end

    function init!(program :: SumProgram, lista :: Array{Int64,1})
        build_table_values!(program, lista)
        build_graf!(program, lista)
    end

    function build_graf!(program :: SumProgram, lista :: Array{Int64,1})
        n = length(lista)

        graf = Graf.new(Color(n+1))
        for (origin, weight_to_origin) in program.table_nodes_values
            for (destine, weight_to_destine) in program.table_nodes_values
                if origin != destine
                    Graf.add!(graf, origin, destine, weight_to_destine)
                    Graf.add!(graf, destine, origin, weight_to_origin)
                end
            end
        end

        program.graf = graf
    end


    function build_table_values!(program :: SumProgram, lista :: Array{Int64,1})
        program.table_nodes_values[Color(0)] = Weight(1)

        color = Color(1)
        for value in lista
            program.table_nodes_values[color] = Weight(value)
            color += 1
        end
    end

    function get_value(program :: SumProgram, color :: Color) :: Union{Weight, Nothing}
        if haskey(program.table_nodes_values, color)
            return program.table_nodes_values[color]
        end

        return nothing
    end

    function get_original_value(program :: SumProgram, color :: Color) :: Union{Int64, Nothing}
        value = get_value(program, color)

        if color == Color(0) || value == nothing
            return nothing
        else
            return Int64(value) - Int64(program.fix_b)
        end
    end

    function get_route_original_values(program :: SumProgram, route_solution :: Array{Color, 1}) :: Array{Int64, 1}
        subset = Array{Int64, 1}()
        for color in route_solution
            value = get_original_value(program, color)
            if value != nothing
                push!(subset, value)
            end
        end

        return subset
    end


    function get_max_target(program :: SumProgram) :: Km
        return program.max_target
    end

    function get_next_target(program :: SumProgram) :: Union{Km, Nothing}
        return program.next_target
    end

    function inc_next_target!(program :: SumProgram)
        if program.next_target >= get_max_target(program)
            println("next_target: $(program.next_target)")
            println("max_target: $(program.max_target)")
            program.next_target = nothing
        else
            program.next_target = program.next_target + program.fix_b
        end
    end

    function save_graphs_solution_of_action!(program :: SumProgram, km :: Km, action :: Action)
        for (steps_length, graph) in action.props_graph
            if is_valid_graph(program, km, steps_length)
                program.have_solution = true
                push_graphs_solution!(program, steps_length - 1, deepcopy(graph))
            end
        end
    end

    function is_valid_graph(program :: SumProgram, km :: Km, steps_length :: Step) :: Bool
        value_target = Int64(program.base_b) + (max(Int64(steps_length-2),0) * Int64(program.fix_b))
        value_target == km
    end

    function push_graphs_solution!(program :: SumProgram, steps_length :: Step, graph :: Graph)
        if !haskey(program.table_graphs_solutions, steps_length)
            program.table_graphs_solutions[steps_length] = Array{Graph,1}()
        end

        push!(program.table_graphs_solutions[steps_length], graph)
    end

end
