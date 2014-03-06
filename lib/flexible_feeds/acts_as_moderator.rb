module FlexibleFeeds
  module ActsAsModerator
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_moderator

        has_many :moderator_joins, as: :moderator,
          class_name: "FlexibleFeeds::ModeratorJoin", dependent: :destroy
        has_many :moderated_feeds, through: :moderator_joins, source: :feed,
          class_name: "FlexibleFeeds::Feed"

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def moderate(feed)
        moderator_joins.create(feed: feed)
      end

      def unmoderate(feed)
        join = moderator_joins.find_by(feed: feed)
        return false if join.nil?
        join.destroy
      end

      def is_moderating?(feed)
        moderated_feeds.include?(feed)
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsModerator