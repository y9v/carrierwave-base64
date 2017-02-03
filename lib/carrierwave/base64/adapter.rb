module Carrierwave
  module Base64
    module Adapter
      # rubocop:disable Metrics/MethodLength
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          if respond_to?("#{attribute}_will_change!") && data.present?
            send "#{attribute}_will_change!"
          end

          return super(data) unless data.is_a?(String) &&
                                    data.strip.start_with?('data')

          super(Carrierwave::Base64::Base64StringIO.new(
            data.strip, options[:file_name] || 'file'
          ))
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
