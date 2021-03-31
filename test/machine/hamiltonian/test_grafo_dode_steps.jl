function test_dode_step_by_step()
   graf = GrafGenerator.dodecaedro()
   dir = "./machine/hamiltonian/visual_graphs/dode_step_by_step"

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
             println("Origin/ActId: $origin / $action_id")
             action = HalMachine.get_action(machine, action_id)

             graph = Actions.get_max_graph(action)
              graph_state = graph.valid
             Graphviz.to_png(graph,"action_$(action_id)_$(graph_state)",dir)


             if action_id == 105
                println("Write log")
                PathGraph.log_owners_write(graph,"action_$(action_id)_log", dir)

                graph.required_review_ownwers = true
                PathGraph.review_owners_all_graph!(graph)
                Graphviz.to_png(graph,"action_$(action_id)_$(graph_state)_rev",dir)
             end
          end
      end
   end


end


test_dode_step_by_step()
