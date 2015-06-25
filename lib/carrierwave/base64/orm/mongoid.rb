require "mongoid"
require "carrierwave/base64/orm/base_db_adapter"

Mongoid::Document::ClassMethods.send(:include, Carrierwave::Base64::BaseDBAdapter)
