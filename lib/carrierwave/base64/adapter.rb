module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          send "#{attribute}_will_change!" if data.present?

          return super(data) unless data.is_a?(String) &&
                                    data.strip.start_with?('data')

          super(Carrierwave::Base64::Base64StringIO.new(
            data.strip, options[:file_name] || 'file'
          ))
        end
      end
    end
  end
end
