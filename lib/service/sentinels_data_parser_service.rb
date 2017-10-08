require 'csv'
# base module neo
module Neo
  # services module
  module Service
    # sentinels parser class
    class SentinelsDataParserService
      def initialize()

      end

      def execute
        nodes_hash = Hash.new
        file = File.open('tmp/sentinels/routes.csv')
        csv = CSV.parse(file.read.gsub(/\"/, "").gsub(" ", ""), headers: false)
        csv.each_with_index do | row, index |
          next if index == 0
          if nodes_hash[row[0]]
            nodes_hash[row[0]][:end_node] = row[1]
            nodes_hash[row[0]][:end_time] = Time.parse(row[3]).strftime( "%Y-%m-%dT%H:%M:%S")
          else
            nodes_hash[row[0]] = {source: 'sentinels', start_node: row[1], start_time: Time.parse(row[3]).strftime("%Y-%m-%dT%H:%M:%S")}
          end
        end
        nodes_hash
      end
    end
  end
end
