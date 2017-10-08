require_relative 'request_handler_service'
require_relative 'data_unzipper_service'
require_relative 'sentinels_data_parser_service'
require_relative 'sniffers_data_parser_service'
require_relative 'loopholes_data_parser_service'
require_relative 'pushing_data_service'
# base module neo
module Neo
  # services module
  module Service
    # data feature class
    class FetchingCollectedDataService
      def initialize
        @target_url = 'http://challenge.distribusion.com/the_one/routes'
        @sources = %i[sentinels sniffers loopholes]
        @passphrase = 'Kans4s-i$-g01ng-by3-bye'
      end

      def execute
        sources.each do |source|
          zipped_data = Service::RequestHandlerService.new(target_url: target_url, source: source, passphrase: passphrase).execute
          if zipped_data
            Service::DataUnzipperService.new(zipped_data: zipped_data, source: source).execute
            nodes_hash = case source
                         when :sentinels
                           Service::SentinelsDataParserService.new().execute
                         when :sniffers
                           Service::SniffersDataParserService.new().execute
                         when :loopholes
                           Service::LoopholesDataParserService.new().execute
                         end
            Service::PushingDataSevice.new(target_url: target_url, source: source, passphrase: passphrase, nodes_hash: nodes_hash).execute
          end
        end
      end

      attr_reader :target_url, :sources, :passphrase
      private
    end
  end
end
