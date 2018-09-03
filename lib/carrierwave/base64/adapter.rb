module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options
        options[:file_name] ||= proc { attribute }

        Carrierwave::Base64::MountingHelper.check_for_deprecations(options)

        Carrierwave::Base64::MountingHelper.define_writer(
          self, attribute, options
        )
      end
    end
  end
end
