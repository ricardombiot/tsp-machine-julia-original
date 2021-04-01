module Alias

    # Con la actionid podemos identificar
    # (Km, Color) donde se realizo.
    const ActionId = UInt128

    # El step dentro de un path
    const Step = UInt128
    # El Km
    const Km = UInt128

    # El numero del nodo
    const Color = UInt128
    # Peso de las aristas
    const Weight = UInt128




    #=
    # El total de nodos posibles por linea es:
    # ActionId (N) * Up(N)  => N^2
    # El total de nodos posibles por graphs es:
    # Step(N) => N^2

    Numero total de nodos unicos que podrían existir
    # IdNodo = (ActionId,ActionIdParent)
    # ActionId = (Km, Color)
    # (ActionId(KmDestine, ColorDestine),ActionIdParent(KmOrigin, ColorOrigin))
    # 4 Dimensions = B^2 * N^2
    # (km_origin*(b*n^2)) + (color_origin*b*n) + (km_destine*n) + (color_destine)
    =#
    const UniqueNodeKey = Int64
    #@TODO Modificar FBSet con UInt128

    const ActionsIdSet = Set{ActionId}
    const SetSteps = Set{Step}
    const SetColors = Set{Color}

end
