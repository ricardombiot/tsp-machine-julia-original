include("./../../src/main.jl")
include("./build_grafs_12.jl")
function main(args)
      n = parse(UInt128,first(args))

      path = "./data/grafs$n"

      create_directories(path)
      builder = BuildGraf.new(n, path)

      BuildGraf.generate(builder)
end

function create_directories(path :: String)
      println("$path")
      if !isdir("$path")
            mkdir(path)
      end

      if !isdir("$path/tsp")
            mkdir("$path/tsp")
      end

      if !isdir("$path/hcp")
            mkdir("$path/hcp")
      end
end

main(ARGS)
