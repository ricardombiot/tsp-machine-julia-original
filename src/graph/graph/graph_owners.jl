function add_node_as_owner(graph :: Graph, node :: Node)
    # Add node in the
    #Owners.push!(graph.owners, node.step, node.id)
    #Owners.push!(node.owners, node.step, node.id)
end


#=
No es necesaria porque se inicializa con owners
function add_owners_new_node!(graph :: Graph, node :: Node)
    PathNode.init_owners!(node, graph.table_lines)
end
=#

#=
function add_owners_new_edge!(graph :: Graph, edge :: Edge)
    node_origin = get_node(graph, edge.id.origin_id)
    EdgeRelation.init_owners_by_parent!(edge, node_origin.owners)
end
=#
