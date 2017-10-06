require_relative 'request_handler_service'
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
          data = Service::RequestHandlerService.new(target_url: target_url, source: source, passphrase: passphrase).execute
          if data
            
          end
        end
      end

      attr_reader :target_url, :sources, :passphrase
      private
    end
  end
end
