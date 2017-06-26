module Carrierwave
  module Base64
    module Adapter
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      # rubocop:disable Metrics/PerceivedComplexity
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_helper_method attribute, options

        define_method "#{attribute}=" do |data|
          return if data == send(attribute).to_s

          if respond_to?("#{attribute}_will_change!") && data.present?
            send "#{attribute}_will_change!"
          end

          super(base64_string_io(data, filename))
        end
      end

      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options

        define_helper_method attribute, options

        define_method "#{attribute}=" do |data_array|
          return if data_array == send(attribute).to_s

          if respond_to?("#{attribute}_will_change!") && data_array.present?
            send "#{attribute}_will_change!"
          end

          return super(data_array) unless data_array.is_a?(Array)

          results =
            data_array.map.with_index do |content, index|
              base64_string_io(content, "#{filename}_#{index + 1}")
            end.compact
          super(results)
        end
      end

      def define_helper_method(attribute, options)
        name = options[:file_name] || proc { attribute }
        if name.is_a?(String)
          warn(
            '[Deprecation warning] Setting `file_name` option to a string is '\
            'deprecated and will be removed in 3.0.0. If you want to keep the '\
            'existing behaviour, wrap the string in a Proc'
          )
        end

        define_method 'filename' do
          if name.respond_to?(:call)
            name.call(self)
          else
            name
          end.to_s
        end

        define_method 'base64_string_io' do |content, filename|
          if content.is_a?(String) && content.strip.start_with?('data')
            Carrierwave::Base64::Base64StringIO.new(
              content.strip, filename
            )
          else
            content
          end
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
