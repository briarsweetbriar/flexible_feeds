class Group < ActiveRecord::Base
  acts_as_moderator
  acts_as_follower
  acts_as_feedable has_many: true
end