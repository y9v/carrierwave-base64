class User < ActiveRecord::Base
  attr_accessor :username
end

class MongoidModel
  include Mongoid::Document
end

class Email < ActiveRecord::Base
  attr_accessor :subject
  serialize :attachments, Array
end
