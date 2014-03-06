class Comment < ActiveRecord::Base
  acts_as_eventable is_parent: { permitted_children: [Comment] }, is_child: true
end