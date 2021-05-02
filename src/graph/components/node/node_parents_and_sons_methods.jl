
function add_parent!(node :: Node, parent :: Node)
    add_parent!(node, parent.id)
end
function add_parent!(node :: Node, parent_id :: NodeId)
    edge_id = EdgeIdentity.new(parent_id, node.id)
    node.parents[parent_id] = edge_id
end

function add_son!(node :: Node, parent :: Node)
    add_son!(node, parent.id)
end

function add_son!(node :: Node, son_id :: NodeId)
    edge_id = EdgeIdentity.new(node.id, son_id)
    node.sons[son_id] = edge_id
end

function delete_parent!(node :: Node, parent_node :: Node)
    delete_parent!(node, parent_node.id)
end
function delete_parent!(node :: Node, parent_id :: NodeId)
    if haskey(node.parents, parent_id)
        delete!(node.parents, parent_id)
    end
end

function delete_son!(node :: Node, son_node :: Node)
    delete_son!(node, son_node.id)
end
function delete_son!(node :: Node, son_id :: NodeId)
    if haskey(node.sons, son_id)
        delete!(node.sons, son_id)
    end
end

function have_parents(node :: Node) :: Bool
    !isempty(node.parents)
end

function have_sons(node :: Node) :: Bool
    !isempty(node.sons)
end
