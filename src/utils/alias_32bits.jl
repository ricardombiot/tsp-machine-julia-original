module Alias
    ## Estimation: 65% reduction of Memory vs 128bits version.
    ## NonHamiltonian N:14 33gb (128bits) vs 20gb (32bits) reduccion en un 65%
    ## FIXED SET DONT SUPPORTED
    ## OVERFLOW: bbnnn :: UniqueNodeKey = (b+1)^2*(n+1)^3

    # Con la actionid podemos identificar
    # (Km, Color) donde se realizo.
    const ActionId = UInt32

    # El step dentro de un path
    const Step = UInt32
    # El Km
    const Km = UInt32

    # El numero del nodo
    const Color = UInt32
    # Peso de las aristas
    const Weight = UInt32




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
    const UniqueNodeKey = Int32
    #@TODO Modificar FBSet con UInt128

    const ActionsIdSet = Set{ActionId}
    const SetSteps = Set{Step}
    const SetColors = Set{Color}

end
