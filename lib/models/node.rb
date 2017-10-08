class Node
  attr_reader :route_id, :node_name, :node_index, :node_time

  def initialize(route_id:, node_name:, node_index:, node_time:)
    @route_id = route_id
    @node_name = node_name
    @node_index = node_index
    @node_time = route_id
  end
end
