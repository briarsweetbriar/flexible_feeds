class Group < ActiveRecord::Base
  acts_as_moderator
  acts_as_follower
  flexible_feeds has_many: true
end