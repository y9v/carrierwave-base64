module Carrierwave
  module Base64
    # Railtie class to load the carrierwave-base64 adapters
    # Loads adapters for ActiveRecord and Mongoid
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend Carrierwave::Base64::Adapter
      end

      ActiveSupport.on_load :mongoid do
        Mongoid::Document::ClassMethods.send :include,
                                             Carrierwave::Base64::Adapter
      end
    end
  end
end
