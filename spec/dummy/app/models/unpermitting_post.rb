class UnpermittingPost < ActiveRecord::Base
  acts_as_eventable is_parent: { unpermitted_children: [Reference] }
end
