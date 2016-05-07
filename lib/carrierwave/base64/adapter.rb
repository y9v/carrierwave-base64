module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          if data.present? && data.is_a?(String) && data.strip.start_with?("data")
            send "#{attribute}_will_change!" if data.present?
            super(Carrierwave::Base64::Base64StringIO.new(data.strip))
          else
            super(data)
          end
        end
      end

      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          send "#{attribute}_will_change!" if data.present?

          if data.is_a?(Array)
            base64_data = data
          elsif data.is_a?(String)
            base64_data = JSON.parse(data)
          else
            base64_data = []
          end

          if data.present? && base64_data.all? {|d| d.is_a?(String) and d.strip.start_with?("data")}
            super(base64_data.map{|d| Carrierwave::Base64::Base64StringIO.new(d.strip)})
          else
            super([data])
          end
        end
      end
    end
  end
end
