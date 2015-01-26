module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :image_format

      def initialize(encoded_image)
        description, encoded_bytes = encoded_image.split(",")

        raise ArgumentError unless encoded_bytes

        @image_format = get_image_format description
        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      def original_filename
        File.basename("image.#{@image_format}")
      end

      private

      def get_image_format(description)
        regex = /\Adata:image\/([a-z]+);base64\z/i
        regex.match(description).try(:[], 1)
      end
    end
  end
end
