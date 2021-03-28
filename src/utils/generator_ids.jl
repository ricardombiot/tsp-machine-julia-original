module GeneratorIds
    using Main.PathsSet.Alias: Color, Km, ActionId, UniqueNodeKey

    function get_action_id(n :: Color, km :: Km, up_color :: Color) :: ActionId
        row = (km * n)
        coll = mod(up_color, n) + 1
        return ActionId(row + coll)
    end

    function get_info_id(n :: Color, id :: ActionId) :: Tuple{Km,Color}
        if id-1 == ActionId(0)
            km = Km(0)
        else
            km = Km(floor((id-1) / n))
        end

        color = Color(mod(id-1, n))
        return (km, color)
    end

end
