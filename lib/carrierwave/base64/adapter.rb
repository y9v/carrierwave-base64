module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_helper_method attribute, options

        define_method "#{attribute}=" do |data|
          super(new_base64_string_io(data))
        end
      end

      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options

        define_helper_method attribute, options

        define_method "#{attribute}=" do |data_array|
          results = data_array.map do |data|
            if data.is_a?(Array)
              new_base64_string_io(data[0], data[1])
            else
              new_base64_string_io(data)
            end
          end
          super(results)
        end
      end

      def define_helper_method(attribute, options)
        define_method 'base64_string?' do |content|
          content.is_a?(String) && content.strip.start_with?('data')
        end

        define_method 'new_base64_string_io' do |content, original_filename = nil|
          send "#{attribute}_will_change!" if content.present?
          if base64_string? content
            Carrierwave::Base64::Base64StringIO.new(
                content.strip, options[:file_name] || 'file', original_filename
            )
          else
            content
          end
        end
      end
    end
  end
end