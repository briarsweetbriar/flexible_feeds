class PermittingPost < ActiveRecord::Base
  acts_as_eventable is_parent: { permitted_children: [Comment, Reference] }
end
