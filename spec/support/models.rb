class User < ActiveRecord::Base
  attr_accessor :username
end

class MongoidModel
  include Mongoid::Document
end

class Email < ActiveRecord::Base
  serialize :attachments, Array
end
