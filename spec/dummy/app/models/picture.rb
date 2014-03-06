class Picture < ActiveRecord::Base
  acts_as_eventable
  acts_as_child
end