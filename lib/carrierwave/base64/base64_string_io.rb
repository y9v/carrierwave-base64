module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :file_format, :file_name

      def initialize(encoded_file, options = {})
        description, encoded_bytes = encoded_file.split(",")

        raise ArgumentError unless encoded_bytes
        raise ArgumentError if encoded_bytes.eql?("(null)")

        @file_format = get_file_format description
        @file_name = options[:file_name].try(:split, '.').try(:first) || 'file'
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
