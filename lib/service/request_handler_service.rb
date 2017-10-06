require 'rest-client'
# base module neo
module Neo
  # services module
  module Service
    # request class
    class RequestHandlerService
      def initialize(target_url:, source:, passphrase:)
        @target_url =  target_url
        @source = source
        @passphrase = passphrase
      end

      def execute
        begin
          response = RestClient.get target_url, {params: {passphrase: passphrase, source: source}}
          response.body
        rescue RestClient::ExceptionWithResponse => e
          puts e.response
        end
      end

      attr_reader :target_url, :source, :passphrase
      private
    end
  end
end
