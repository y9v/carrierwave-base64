class User < ActiveRecord::Base
  def username
    'batman'
  end
end

class MongoidModel
  include Mongoid::Document
end
