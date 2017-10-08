# require 'zipruby'
require 'zip'
require 'fileutils'
require_relative '../models/node'
# base module neo
module Neo
  # services module
  module Service
    # unzipper class
    class DataUnzipperService
      def initialize(zipped_data:, source:)
        @zipped_data = zipped_data
        @source = source
      end

      def execute
        download_files
        response_data_unzip
      end

      attr_reader :zipped_data, :source
      private

      def download_files
        File.open(File.join("tmp", "#{source}.data"), 'w') do |file|
          file.puts zipped_data
        end
      end

      def response_data_unzip
        download_files
        data_hash = Hash.new
        puts "tmp/#{source}.data"
        FileUtils::mkdir_p "tmp/#{source}"
        Zip::File.open("tmp/#{source}.data") do |zip_file|
          data_entries = zip_file.glob('{sentinels,sniffers,loopholes}/*.{csv,json}')
          data_entries.each do |entry|
            entry.extract("tmp/#{entry.name}") { true }
          end
        end
      end
    end
  end
end
