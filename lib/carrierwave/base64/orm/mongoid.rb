require 'mongoid'

module Carrierwave
  module Base64
    module Mongoid

      def mount_base64_uploader(attribute, uploader_class, options = {})
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

Mongoid::Document::ClassMethods.send(:include, Carrierwave::Base64::Mongoid)
