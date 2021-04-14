module MachineJumper
    using Main.PathsSet.Alias: Km

    using Main.PathsSet.FBSet
    using Main.PathsSet.FBSet: FixedBinarySet

    mutable struct Jumper
        set :: FixedBinarySet
    end

    function new(b_max :: Int64)
        set = FBSet.new(b_max)
        Jumper(set)
    end

    function cast_km_to_int64(km :: Km) :: Int64
        convert(Int64, km)
    end

    function cast_int64_to_km(km_int64 :: Int64) :: Km
        convert(UInt128, km_int64)
    end


    function register_km!(jumper :: Jumper,  km :: Km)
        FBSet.push!(jumper.set, cast_km_to_int64(km))
    end

    function next_km!(jumper :: Jumper,  last_km :: Km = Km(1)) :: Union{Km, Nothing}
        km = FBSet.get_next(jumper.set, cast_km_to_int64(last_km))

        if km != nothing
            FBSet.pop!(jumper.set, km)
            return cast_int64_to_km(km)
        else
            return nothing
        end
    end

end
