class Post < ActiveRecord::Base
  attr_accessor :author

  acts_as_eventable created_by: :author
  acts_as_parent
end
