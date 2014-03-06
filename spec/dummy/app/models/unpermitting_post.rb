class UnpermittingPost < ActiveRecord::Base
  acts_as_eventable
  acts_as_parent unpermitted_children: [Reference]
end
