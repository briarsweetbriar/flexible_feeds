class User < ActiveRecord::Base
  acts_as_moderator
  acts_as_follower
  flexible_feeds
end