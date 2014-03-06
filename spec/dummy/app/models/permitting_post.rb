class PermittingPost < ActiveRecord::Base
  acts_as_eventable
  acts_as_parent permitted_children: [Comment, Reference]
end
