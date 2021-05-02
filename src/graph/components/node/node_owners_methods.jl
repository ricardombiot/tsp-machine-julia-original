
function push_owner!(node :: Node, node_owner :: Node)
    push_owner!(node, node_owner.step, node_owner.id)
end
function push_owner!(node :: Node, step :: Step, node_id :: NodeId)
    Owners.push!(node.owners, step, node_id)
end


function pop_owner!(node :: Node, node_owner :: Node)
    pop_owner!(node, node_owner.step, node_owner.id)
end
function pop_owner!(node :: Node, step :: Step, node_id :: NodeId)
    Owners.pop!(node.owners, step, node_id)
end


function have_owner(node :: Node, node_owner :: Node) :: Bool
    have_owner(node, node_owner.step, node_owner.id)
end


function have_owner(node :: Node, step :: Step, node_id :: NodeId) :: Bool
    Owners.have(node.owners, step, node_id)
end

function intersect_owners!(node :: Node, owners_graph :: OwnersByStep)
    Owners.intersect!(node.owners, owners_graph)
end
