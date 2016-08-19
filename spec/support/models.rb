class Post < ActiveRecord::Base
end


class Email < ActiveRecord::Base
  serialize :attachments, Array
end