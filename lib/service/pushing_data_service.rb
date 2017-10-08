require 'rest-client'
# base module neo
module Neo
  # services module
  module Service
    # request class
    class PushingDataSevice
      def initialize(target_url:, source:, passphrase:, nodes_hash:)
        @target_url =  target_url
        @source = source
        @passphrase = passphrase
        @nodes_hash = nodes_hash
      end

      def execute
        nodes_hash.each do |node_id, node_parameters|
          push_node(node_parameters: node_parameters)
        end

      end

      attr_reader :target_url, :source, :passphrase, :nodes_hash

      private

      def push_node(node_parameters:)
        puts node_parameters
        begin
          RestClient.post(target_url, {params: {passphrase: passphrase}.merge(node_parameters) }) { |response, request, result|
            case response.code
            when 301, 302, 307
              response.follow_redirection
            else
              response.return!
            end
          }
        rescue RestClient::ExceptionWithResponse => e
          puts e.response
        end
      end
    end
  end
end
