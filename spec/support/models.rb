class Post < ActiveRecord::Base
  serialize :images, Array
end
