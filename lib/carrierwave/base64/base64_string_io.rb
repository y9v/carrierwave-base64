module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :file_format, :file_name

      def initialize(encoded_file, file_name)
        description, encoded_bytes = encoded_file.split(',')

        raise ArgumentError unless encoded_bytes
        raise ArgumentError if encoded_bytes.eql?('(null)')

        @file_name = file_name
        @file_format = get_file_format description
        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      def original_filename
        File.basename("#{@file_name}.#{@file_format}")
      end

      private

      def get_file_format(description)
        regex = /([a-z0-9]+);base64\z/
        regex.match(description).try(:[], 1)
      end
    end
  end
end
