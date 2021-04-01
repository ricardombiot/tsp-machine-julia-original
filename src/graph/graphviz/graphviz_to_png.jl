function to_png(graph :: Graph, name :: String, path :: String = "./test_visual/graphs")
    txt = Graphviz.to_dot(graph)
    input_file = "$path/$name.dot"
    output_file = "$path/$name.png"
    open(input_file, "w") do io
        print(io, txt)
    end
    run(`dot -Tpng $input_file -o $output_file`)
end
