require "carrierwave/base64/version"
require "carrierwave/base64/base64_string_io"

module Carrierwave
  module Base64
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :active_record do
        require "carrierwave/base64/orm/activerecord"
      end
      ActiveSupport.on_load :mongoid do
        require "carrierwave/base64/orm/mongoid"
      end
    end
  end
end
