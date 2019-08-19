class User < ActiveRecord::Base
  has_many :todos
end

class Todo < ActiveRecord::Base
  belongs_to :user
end
