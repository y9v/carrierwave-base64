module Carrierwave
  module Base64
    # Module with helper functions for mounting uploaders
    module MountingHelper
      module_function

      # Returns a file name for the uploaded file.
      # @private
      #
      # @param model_instance [Object] the model instance object
      # @param options [Hash{Symbol => Object}] the uploader options
      # @return [String] File name without extension
      def file_name(model_instance, options)
        options[:file_name].call(model_instance).to_s
      end

      # Defines an attribute writer method on the class with mounted uploader.
      # @private
      #
      # @param klass [Class] the class with mounted uploader
      # @param attr [Symbol] the attribute for which the writer will be defined
      # @param options [Hash{Symbol => Object}] a set of options
      # @return [Symbol] the defined writer method name
      def define_writer(klass, attr, options)
        klass.send(:define_method, "#{attr}=") do |data|
          # rubocop:disable Lint/NonLocalExitFromIterator
          return if data == send(attr).to_s
          # rubocop:enable Lint/NonLocalExitFromIterator

          send("#{attr}_will_change!") if respond_to?("#{attr}_will_change!")

          return send("remove_#{attr}=", true) if data.to_s.strip == ''

          return super(data) unless data.is_a?(String) && data.strip.start_with?('data')

          super Carrierwave::Base64::Base64StringIO.new(
            data.strip,
            Carrierwave::Base64::MountingHelper.file_name(self, options)
          )
        end
      end
    end
  end
end
