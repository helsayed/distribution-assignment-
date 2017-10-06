require "neo/version"
require 'service/fetching_collected_data_service.rb'
module Neo
  class Hacker
    def execute
      Service::FetchingCollectedDataService.new().execute
    end
  end
end
