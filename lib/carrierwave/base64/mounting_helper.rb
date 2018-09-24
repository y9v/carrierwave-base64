module Carrierwave
  module Base64
    # Module with helper functions for mounting uploaders
    module MountingHelper
      module_function

      # Checks for deprecations and prints a warning if found any.
      # @private
      #
      # @param options [Hash{Symbol => Object}] the uploader options
      # @return [void]
      def check_for_deprecations(options)
        return unless options[:file_name].is_a?(String)

        warn(
          '[Deprecation warning] Setting `file_name` option to a string is '\
          'deprecated and will be removed in 3.0.0. If you want to keep the '\
          'existing behaviour, wrap the string in a Proc'
        )
      end

      # Returns a file name for the uploaded file.
      # @private
      #
      # @param model_instance [Object] the model instance object
      # @param options [Hash{Symbol => Object}] the uploader options
      # @return [String] File name without extension
      def file_name(model_instance, options)
        if options[:file_name].respond_to?(:call)
          options[:file_name].call(model_instance)
        else
          options[:file_name]
        end.to_s
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
          return if data.to_s.empty? || data == send(attr).to_s

          # rubocop:enable Lint/NonLocalExitFromIterator

          send("#{attr}_will_change!") if respond_to?("#{attr}_will_change!")

          return super(data) unless data.is_a?(String) &&
                                    data.strip.start_with?('data')

          super Carrierwave::Base64::Base64StringIO.new(
            data.strip,
            Carrierwave::Base64::MountingHelper.file_name(self, options)
          )
        end
      end
    end
  end
end
