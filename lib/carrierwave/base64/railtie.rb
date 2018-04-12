module Carrierwave
  module Base64
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
