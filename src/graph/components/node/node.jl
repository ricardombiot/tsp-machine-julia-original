module PathNode
    using Main.PathsSet.Alias: ActionId, Step, Color, Km

    using Main.PathsSet.NodeIdentity
    using Main.PathsSet.EdgeIdentity
    using Main.PathsSet.Owners

    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.EdgeIdentity: EdgeId
    using Main.PathsSet.Owners: OwnersByStep

    mutable struct Node
        id :: NodeId
        action_id :: ActionId
        color :: Color
        step :: Step

        parents :: Dict{NodeId, EdgeId}
        sons :: Dict{NodeId, EdgeId}

        owners :: OwnersByStep
    end

    function new(n :: Color, b :: Km, step :: Step, color :: Color, owners_graph :: OwnersByStep, action_id :: ActionId, action_parent_id :: Union{ActionId, Nothing} = nothing)
        node_id = NodeIdentity.new(n, b, action_id, action_parent_id)
        parents = Dict{NodeId, EdgeId}()
        sons = Dict{NodeId, EdgeId}()
        owners = Owners.derive(owners_graph)

        Node(node_id, action_id, color, step, parents, sons, owners)
    end

    function is_root(node :: Node) :: Bool
        NodeIdentity.is_root(node.id)
    end

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

    function delete_parent!(node :: Node, parent_id :: NodeId)
        if haskey(node.parents, parent_id)
            delete!(node.parents, parent_id)
        end
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

end
