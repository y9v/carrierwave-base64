require "active_record"
require "carrierwave/base64/orm/base_db_adapter"

ActiveRecord::Base.extend Carrierwave::Base64::BaseDBAdapter
