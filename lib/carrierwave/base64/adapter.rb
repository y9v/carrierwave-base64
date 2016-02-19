module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          super Carrierwave::Base64::Adapter.handle_data(data)
        end
      end

      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options

        define_method "#{attribute}=" do |data_ary|
          super data_ary.map(&Carrierwave::Base64::Adapter.method(:handle_data))
        end
      end

      def self.handle_data(data)
        if data.present? && data.is_a?(String) && data.strip.start_with?("data")
          Carrierwave::Base64::Base64StringIO.new(data.strip)
        else
          data
        end
      end
    end
  end
end
