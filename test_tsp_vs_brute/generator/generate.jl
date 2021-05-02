include("./../../src/main.jl")
include("./builder.jl")
function main(args)
      n = parse(UInt128,popfirst!(args))
      total_graf = parse(Int64,popfirst!(args))

      path = "./data/grafs$n"
      create_directories(path)

      #total_graf = 20
      min = 1
      max = 10

      BuildGraf.generate(n, path, min, max, total_graf)
end

function create_directories(path :: String)
      if !isdir("$path")
            mkdir(path)
      end
      if !isdir("$path")
            mkdir("$path")
      end
end

main(ARGS)
