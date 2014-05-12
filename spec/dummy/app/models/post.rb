class Post < ActiveRecord::Base
  acts_as_eventable is_parent: true
end
