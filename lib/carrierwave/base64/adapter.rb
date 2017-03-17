module Carrierwave
  module Base64
    module Adapter
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          return if data == send(attribute).to_s

          if respond_to?("#{attribute}_will_change!") && data.present?
            send "#{attribute}_will_change!"
          end

          return super(data) unless data.is_a?(String) &&
                                    data.strip.start_with?('data')

          options[:file_name] ||= -> { attribute }
          if options[:file_name].is_a?(Proc) && options[:file_name].arity == 1
            options[:file_name] = options[:file_name].curry[self]
          end
          super(Carrierwave::Base64::Base64StringIO.new(
            data.strip, options[:file_name]
          ))
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity
      end
    end
  end
end
