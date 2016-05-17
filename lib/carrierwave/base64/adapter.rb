module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        if options[:file_name].blank? || options[:file_name] == true
          options[:file_name] = "#{attribute}_file_name"
          options[:file_name] = "file_name" if attribute.to_s == 'file'
        end

        define_method :file_name_field do
          options[:file_name]
        end

        attr_accessor options[:file_name]

        define_method "#{attribute}=" do |data|
          send "#{attribute}_will_change!" if data.present?

          if data.present? && data.is_a?(String) && data.strip.start_with?("data")
            data_obj = Carrierwave::Base64::Base64StringIO.new(
              data.strip, file_name: try(file_name_field)
            )
            super(data_obj)
          else
            super(data)
          end
        end

        define_method 'attributes=' do |new_attributes|
          # Ensure file_name is assigned before actual file
          super new_attributes.slice(file_name_field.to_s)
          super new_attributes
        end

        define_method 'assign_attributes' do |new_attributes|
          # Ensure file_name is assigned before actual file
          super new_attributes.slice(file_name_field.to_s)
          super new_attributes
        end
      end
    end
  end
end
