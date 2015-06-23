class Post < ActiveRecord::Base
end

class MongoidPost
  include Mongoid::Document
end
