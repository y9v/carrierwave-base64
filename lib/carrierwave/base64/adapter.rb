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
      
      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options
        
        define_method "#{attribute}=" do |data|
          send "#{attribute}_will_change!" if data.present?
          
          new_data = data.map.with_index do |elem, index|
            if elem.is_a?(String) && elem.strip.start_with?('data')
              Carrierwave::Base64::Base64StringIO.new(
                elem.strip,
                "#{options[:file_name] || 'file'}#{index}"
                )
            else
              elem
            end
          end
          
          super(new_data)
        end
      end
    end
  end
end
