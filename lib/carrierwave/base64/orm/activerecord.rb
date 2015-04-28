require "active_record"

module Carrierwave
  module Base64
    module ActiveRecord
      def mount_base64_uploader(attribute, uploader_class, options={})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          if data.present? && data.is_a?(String) && data.strip.start_with?("data")
            super(Carrierwave::Base64::Base64StringIO.new(data.strip))
          else
            super(data)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend Carrierwave::Base64::ActiveRecord
