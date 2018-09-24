module Carrierwave
  module Base64
    # Module with .mount_base64_uploader method, that is mixed in to
    # ActiveRecord::Base or Mongoid::Document::ClassMethods
    module Adapter
      # Mounts the carrierwave uploader that can accept a base64 encoded
      # string as input. It also accepts regular file uploads.
      #
      # @param attribute [Symbol] the attribute to mount this uploader on
      # @param uploader_class [Carrierwave::Uploader] the uploader class to
      #   mount
      # @param options [Hash{Symbol => Object}] a set of options
      # @option options [Proc] :file_name Proc that must return a file name
      #   without extension
      #
      # @example Mount the uploader and specify the file name
      #   mount_base64_uploader :image, ImageUploader,
      #     file_name: -> (u) { u.username }
      #
      # @return [Symbol] the defined writer method name
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
