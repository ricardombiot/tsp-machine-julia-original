
function join!(node :: Node, node_join :: Node)
    union_parents!(node, node_join)
    union_sons!(node, node_join)
    Owners.union!(node.owners, node_join.owners)
end

function union_parents!(node :: Node, node_join :: Node)
    for (parent_id, edge_id) in node_join.parents
        if !haskey(node.parents, parent_id)
            node.parents[parent_id] = edge_id
        end
    end
end

function union_sons!(node :: Node, node_join :: Node)
    for (son_id, edge_id) in node_join.sons
        if !haskey(node.sons, son_id)
            node.sons[son_id] = edge_id
        end
    end
end
