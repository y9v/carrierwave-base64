require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'sham_rack'

require 'rails'
require 'active_record'
require 'mongoid'

require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/mongoid'

require 'carrierwave/base64'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

load 'support/schema.rb'
require 'support/models'
require 'support/custom_expectations/warn_expectation'

def file_path(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), *paths))
end

CarrierWave.root = ''

# Add preferred file types similar to how users would implement custom types
content_types = {
  'audio/mpeg' => 'mp3'
}
content_types.each do |content_type, extension|
  MIME::Types.add(
    MIME::Type.new(content_type).tap do |type|
      type.preferred_extension = extension
    end
  )
end
