module FlexibleFeeds
  module ActsAsFollower
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_follower

        has_many :follows, as: :follower, class_name: "FlexibleFeeds::Follow",
          dependent: :destroy
        has_many :followed_feeds, through: :follows, source: :feed,
          class_name: "FlexibleFeeds::Feed"
        has_many :aggregate_follows, -> { group 'flexible_feeds_events.id' },
          through: :followed_feeds, source: :events,
          class_name: "FlexibleFeeds::Event"

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def follow(feed)
        follows.create(feed: feed)
      end

      def unfollow(feed)
        join = follows.find_by(feed: feed)
        return false if join.nil?
        join.destroy
      end

      def is_following?(feed)
        followed_feeds.include?(feed)
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsFollower