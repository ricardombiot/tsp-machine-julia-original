function create_grafo_reduce3sat()
   # (x1 + x2 + !x3) * (!x2 + x3 + x4) * (x1 + !x2 + x4)
   # Example: https://opendsa-server.cs.vt.edu/ODSA/Books/Everything/html/threeSAT_to_hamiltonianCycle.html
   n = Color(29)
   g = Graf.new(n)

   Graf.add!(g, Color(0), Color(1))
   Graf.add!(g, Color(0), Color(6))

   Graf.add!(g, Color(1), Color(2))
   Graf.add!(g, Color(1), Color(7))
   Graf.add!(g, Color(1), Color(12))
   Graf.add!(g, Color(1), Color(26))

   Graf.add!(g, Color(2), Color(1))
   Graf.add!(g, Color(2), Color(3))

   Graf.add!(g, Color(3), Color(2))
   Graf.add!(g, Color(3), Color(4))

   Graf.add!(g, Color(4), Color(3))
   Graf.add!(g, Color(4), Color(5))

   Graf.add!(g, Color(5), Color(4))
   Graf.add!(g, Color(5), Color(6))
   Graf.add!(g, Color(5), Color(28))

   Graf.add!(g, Color(6), Color(5))
   Graf.add!(g, Color(6), Color(12))
   Graf.add!(g, Color(6), Color(7))

   Graf.add!(g, Color(7), Color(8))
   Graf.add!(g, Color(7), Color(13))
   Graf.add!(g, Color(7), Color(18))
   Graf.add!(g, Color(7), Color(26))

   Graf.add!(g, Color(8), Color(7))
   Graf.add!(g, Color(8), Color(9))

   Graf.add!(g, Color(9), Color(8))
   Graf.add!(g, Color(9), Color(10))

   Graf.add!(g, Color(10), Color(9))
   Graf.add!(g, Color(10), Color(11))
   Graf.add!(g, Color(10), Color(27))

   Graf.add!(g, Color(11), Color(10))
   Graf.add!(g, Color(11), Color(12))

   Graf.add!(g, Color(12), Color(11))
   Graf.add!(g, Color(12), Color(13))
   Graf.add!(g, Color(12), Color(18))
   Graf.add!(g, Color(12), Color(28))

   Graf.add!(g, Color(13), Color(14))
   Graf.add!(g, Color(13), Color(19))
   Graf.add!(g, Color(13), Color(24))

   Graf.add!(g, Color(14), Color(13))
   Graf.add!(g, Color(14), Color(15))
   Graf.add!(g, Color(14), Color(26))

   Graf.add!(g, Color(15), Color(14))
   Graf.add!(g, Color(15), Color(16))
   Graf.add!(g, Color(15), Color(27))

   Graf.add!(g, Color(16), Color(15))
   Graf.add!(g, Color(16), Color(17))

   Graf.add!(g, Color(17), Color(16))
   Graf.add!(g, Color(17), Color(18))

   Graf.add!(g, Color(18), Color(17))
   Graf.add!(g, Color(18), Color(19))
   Graf.add!(g, Color(18), Color(24))

   Graf.add!(g, Color(19), Color(20))
   Graf.add!(g, Color(19), Color(25))

   Graf.add!(g, Color(20), Color(19))
   Graf.add!(g, Color(20), Color(21))

   Graf.add!(g, Color(21), Color(20))
   Graf.add!(g, Color(21), Color(22))
   Graf.add!(g, Color(21), Color(27))

   Graf.add!(g, Color(22), Color(21))
   Graf.add!(g, Color(22), Color(23))

   Graf.add!(g, Color(23), Color(22))
   Graf.add!(g, Color(23), Color(24))
   Graf.add!(g, Color(23), Color(28))

   Graf.add!(g, Color(24), Color(23))
   Graf.add!(g, Color(24), Color(25))

   Graf.add!(g, Color(25), Color(0))

   Graf.add!(g, Color(26), Color(2))
   Graf.add!(g, Color(26), Color(8))
   Graf.add!(g, Color(26), Color(13))

   Graf.add!(g, Color(27), Color(9))
   Graf.add!(g, Color(27), Color(16))
   Graf.add!(g, Color(27), Color(22))

   Graf.add!(g, Color(28), Color(6))
   Graf.add!(g, Color(28), Color(11))
   Graf.add!(g, Color(28), Color(24))

   return g
end



function test_dode_step_by_step_unvalid_path()
   graf = create_grafo_reduce3sat()
   dir = "./machine/hamiltonian/visual_graphs/grafo_reduce3sat_steps_unvalid"

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   dict :: Dict{Step, SetColors} = Dict{Step, SetColors}()
   dict[Step(0)] = SetColors([Color(0)])
   dict[Step(1)] = SetColors([Color(1)])
   dict[Step(2)] = SetColors([Color(7)])
   dict[Step(3)] = SetColors([Color(8)])
   dict[Step(4)] = SetColors([Color(9)])
   dict[Step(5)] = SetColors([Color(10)])
   dict[Step(6)] = SetColors([Color(11)])
   dict[Step(7)] = SetColors([Color(12)])

   dict[Step(8)] = SetColors([Color(18)])
   dict[Step(9)] = SetColors([Color(17)])
   dict[Step(10)] = SetColors([Color(16)])
   dict[Step(11)] = SetColors([Color(15)])
   dict[Step(12)] = SetColors([Color(14)])
   dict[Step(13)] = SetColors([Color(26)])
   dict[Step(14)] = SetColors([Color(13)])
   dict[Step(15)] = SetColors([Color(14)])
   #=
   dict[Step(13)] = SetColors([Color(7)])
   dict[Step(14)] = SetColors([Color(13)])
   dict[Step(15)] = SetColors([Color(14)])
   =#

   println("## Calc. Reduce3Sat step by step...")

   for step in 1:15
      HalMachine.make_step!(machine)
      actual_step = machine.actual_km-1
      line = TableTimeline.get_line(machine.timeline, actual_step)
      for (origin, cell) in line
          action_id = cell.action_id

          if origin in dict[actual_step]
            println("$actual_step Origin/ActId: $origin / $action_id")
            action = HalMachine.get_action(machine, action_id)

            graph = Actions.get_max_graph(action)
            graph_state = graph.valid
            Graphviz.to_png(graph,"action_$(action_id)_$(graph_state)",dir)

          end
      end
   end



end

test_dode_step_by_step_unvalid_path()
