class User < ActiveRecord::Base
  attr_accessor :username
end

class MongoidModel
  include Mongoid::Document
end
