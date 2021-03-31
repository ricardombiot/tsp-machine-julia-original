function test_dode_step_by_step()
   graf = GrafGenerator.dodecaedro()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calc. Dode step by step...")
   for step_dont_display in 1:2
      HalMachine.make_step!(machine)
   end

   for step in 2:4
      HalMachine.make_step!(machine)
      line = TableTimeline.get_line(machine.timeline, machine.actual_km)
      for (origin, cell) in line
          for action_id in cell.parents
             action = HalMachine.get_action(machine, action_id)

             graph = Actions.get_max_graph(action)
             Graphviz.to_png(graph,"action_$action_id","./machine/hamiltonian/visual_graphs/dode_step_by_step")
          end
      end
   end


end


test_dode_step_by_step()
