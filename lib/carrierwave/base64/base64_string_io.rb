module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :file_format, :content_type

      def initialize(encoded_file)
        description, encoded_bytes = encoded_file.split(",")

        raise ArgumentError unless encoded_bytes
        raise ArgumentError if encoded_bytes.eql?("(null)")

        @content_type = get_content_type description
        @file_format = get_file_format @content_type

        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      def original_filename
        File.basename("file.#{@file_format}")
      end

      private

      def get_content_type(description)
        regex = /([a-z0-9\/]+);base64\z/
        regex.match(description).try(:[], 1)
      end

      def get_file_format(content_type)
        content_type.split('/').try(:last)
      end
    end
  end
end
