require 'csv'
# base module neo
module Neo
  # services module
  module Service
    # sniffers parser class
    class SniffersDataParserService
      def initialize()
        @nodes_hash = Hash.new
      end

      def execute
        nodes_hash = routes_file_parser
        nodes_details
        nodes_hash
      end

      attr_reader :nodes_hash

      private

      def routes_file_parser
        file = File.open('tmp/sniffers/routes.csv')
        csv = CSV.parse(file.read.gsub(/\"/, "").gsub(" ", ""), headers: false)
        csv.each_with_index do | row, index |
          next if index == 0
          nodes_hash[row[0]] = {source: 'sniffers', start_time: row[1].concat(row[2])}
        end
        nodes_hash
      end

      def nodes_details
        seq = Hash.new
        file = File.open('tmp/sniffers/sequences.csv')
        csv = CSV.parse(file.read.gsub(/\"/, "").gsub(" ", ""), headers: false)
        csv.each_with_index do | row, index |
          next if index == 0
          if seq[row[0]]
            seq[row[0]][:end_node] = row[1]
          else
            seq[row[0]] = {start_node: row[1]}
          end
        end

        node_details = Hash.new
        file = File.open('tmp/sniffers/node_times.csv')
        csv = CSV.parse(file.read.gsub(/\"/, "").gsub(" ", ""), headers: false)
        csv.each_with_index do | row, index |
          next if index == 0
          node_details[row[0]] = {start_node: row[1], end_node: row[2], duration: row[3]}
        end
        nodes_hash.keys.each do |key|
          nodes_hash[key][:start_node] =  node_details[seq[key][:start_node]][:start_node] rescue nil
          nodes_hash[key][:end_node] =  node_details[seq[key][:end_node]][:end_node]  rescue nil
          nodes_hash[key][:end_time] =  ( (Time.parse(nodes_hash[key][:start_time]) + node_details[seq[key][:duration]].to_i / 100 ).strftime( "%Y-%m-%dT%H:%M:%S" ))
          nodes_hash[key][:start_time] = Time.parse(nodes_hash[key][:start_time]).strftime( "%Y-%m-%dT%H:%M:%S")
        end
      end
    end
  end
end
