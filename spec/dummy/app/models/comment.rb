class Comment < ActiveRecord::Base
  acts_as_eventable
  acts_as_parent permitted_children: [Comment]
  acts_as_child
end