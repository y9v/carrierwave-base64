module Carrierwave
  module Base64
    # Class that decodes a base64 string, builds a StringIO for the
    # decoded bytes, and extracts the file MIME type to build a file
    # name with extension.
    class Base64StringIO < StringIO
      attr_reader :file_extension, :file_name

      # Returns a StringIO with decoded bytes from the base64 encoded
      # string and builds a file name with extension for the uploaded file,
      # based on the MIME type specified in the base64 encoded string.
      #
      # @param encoded_file [String] the base64 encoded file contents
      # @param file_name [String] the file name without extention
      #
      # @raise [ArgumentError] If the base64 encoded string is empty
      #
      # @return [StringIO] StringIO with decoded bytes
      def initialize(encoded_file, file_name)
        description, encoded_bytes = encoded_file.split(',')

        raise ArgumentError unless encoded_bytes
        raise ArgumentError if encoded_bytes.eql?('(null)')

        @file_name = file_name
        @file_extension = get_file_extension description
        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      # Returns a file name with extension, based on the MIME type specified
      # in the base64 encoded string.
      #
      # @return [String] File name with extention
      def original_filename
        File.basename("#{@file_name}.#{@file_extension}")
      end

      private

      def get_file_extension(description)
        content_type = description.split(';base64').first
        mime_type = MIME::Types[content_type].first
        unless mime_type
          raise Carrierwave::Base64::UnknownMimeTypeError,
                "Unknown MIME type: #{content_type}"
        end
        mime_type.preferred_extension
      end
    end
  end
end
