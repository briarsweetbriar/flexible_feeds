class Picture < ActiveRecord::Base
  acts_as_eventable is_child: true
end