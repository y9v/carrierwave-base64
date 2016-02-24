module Carrierwave
  module Base64
    module Adapter
      extend ActiveSupport::Concern

      class_methods do
        def mount_base64_uploader(attribute, uploader_class, options = {})
          mount_uploader attribute, uploader_class, options

          define_method "#{attribute}=" do |data|
            super handle_base64_image_data(data)
          end
        end

        def mount_base64_uploaders(attribute, uploader_class, options = {})
          mount_uploaders attribute, uploader_class, options

          define_method "#{attribute}=" do |data_ary|
            super data_ary.map(&method(:handle_base64_image_data))
          end
        end
      end

      private

      def handle_base64_image_data(data)
        return data unless data.present?

        if data.is_a?(String) && data.strip.start_with?("data")
          Carrierwave::Base64::Base64StringIO.new(data.strip)
        elsif data.is_a?(Hash)
          binding.pry
        end
      end
    end
  end
end
