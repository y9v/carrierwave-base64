module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :file_extension, :file_name

      def initialize(encoded_file, file_name)
        description, encoded_bytes = encoded_file.split(',')

        raise ArgumentError unless encoded_bytes
        raise ArgumentError if encoded_bytes.eql?('(null)')

        encoded_bytes = encoded_bytes.tr(' ', '+')

        @file_name = file_name
        @file_extension = get_file_extension description
        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      def original_filename
        File.basename("#{@file_name}.#{@file_extension}")
      end

      private

      def get_file_extension(description)
        content_type = description.split(';base64').first
        mime_type = MIME::Types[content_type].first
        unless mime_type
          raise ArgumentError, "Unknown MIME type: #{content_type}"
        end
        mime_type.preferred_extension
      end
    end
  end
end
