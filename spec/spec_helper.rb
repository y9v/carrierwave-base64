require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'sham_rack'

require 'rails'
require 'active_record'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

require 'carrierwave/base64'

ActiveRecord::Base.raise_in_transactional_callbacks = true
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

load 'support/schema.rb'
require 'support/models'

def file_path(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), *paths))
end
