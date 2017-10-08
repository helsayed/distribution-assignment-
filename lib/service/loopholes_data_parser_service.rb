require 'json'
# base module neo
module Neo
  # services module
  module Service
    # loopholes parser class
    class LoopholesDataParserService
      def initialize()

      end

      def execute
        routes_hash = Hash.new
        file = File.open('tmp/loopholes/routes.json')
        routes_hash = JSON.parse(file.read)['routes']

        file = File.open('tmp/loopholes/node_pairs.json')
        node_pairs_hash = JSON.parse(file.read)['node_pairs']

        nodes_hash = Hash.new
        routes_hash.each do |k|
          if nodes_hash[k['route_id']]
            nodes_hash[k['route_id']]['end_node'] =  node_pairs_hash.select{ |np| np['id'] == k['node_pair_id'] }.last['end_node']
            nodes_hash[k['route_id']]['end_time'] = Time.parse(k['end_time']).strftime( "%Y-%m-%dT%H:%M:%S")
          else
            nodes_hash[k['route_id']] = Hash.new
            nodes_hash[k['route_id']]['start_node'] =  (node_pairs_hash.select{ |np| np['id'] == k['node_pair_id'] }.last['start_node']) rescue nil
            nodes_hash[k['route_id']]['end_node'] =  (node_pairs_hash.select{ |np| np['id'] == k['node_pair_id'] }.last['end_node']) rescue nil
            nodes_hash[k['route_id']]['start_time'] = Time.parse(k['start_time']).strftime( "%Y-%m-%dT%H:%M:%S")
            nodes_hash[k['route_id']]['end_time'] = Time.parse(k['end_time']).strftime( "%Y-%m-%dT%H:%M:%S")
            nodes_hash[k['route_id']]['source'] = 'loopholes'
          end
        end

        nodes_hash
      end
    end
  end
end
