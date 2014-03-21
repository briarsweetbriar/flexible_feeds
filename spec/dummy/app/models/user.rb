class User < ActiveRecord::Base
  acts_as_moderator
  acts_as_follower
  acts_as_voter
  flexible_feeds
end