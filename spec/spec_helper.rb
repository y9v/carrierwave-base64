require "rubygems"
require "bundler/setup"

require "pry"
require "sham_rack"

require "rails"
require "active_record"
require "mongoid"

require "carrierwave"
require "carrierwave/mongoid"
require "carrierwave/orm/activerecord"

require "carrierwave/base64"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
Mongoid.configure { |config| config.connect_to("carrierwave_test") }

load "support/schema.rb"
require "support/models"

def file_path(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), *paths))
end
