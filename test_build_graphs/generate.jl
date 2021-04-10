include("./../src/main.jl")
include("./build_grafs.jl")

n = Color(6)
g = Graf.new(n)
Graf.add_bidirectional!(g, Color(0), Color(1))
Graf.add_bidirectional!(g, Color(1), Color(2))
Graf.add_bidirectional!(g, Color(2), Color(3))
Graf.add_bidirectional!(g, Color(3), Color(4))
Graf.add_bidirectional!(g, Color(4), Color(5))
Graf.add_bidirectional!(g, Color(5), Color(0))

limit = -1
path = "./grafs6"
builder = Main.BuildGraf.new(g, limit, path)

Main.BuildGraf.generate_graf!(builder)
