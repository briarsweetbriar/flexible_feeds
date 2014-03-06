module FlexibleFeeds
  module HasFlexibleFeed
    extend ActiveSupport::Concern
 
    module ClassMethods
      def flexible_feeds(options = {})

        cattr_accessor :has_many_feeds
        self.has_many_feeds = options[:has_many] || false

        if has_many_feeds == true
          has_many :feeds, as: :feedable, class_name: "FlexibleFeeds::Feed",
            dependent: :destroy
        else
          has_one :feed, as: :feedable, class_name: "FlexibleFeeds::Feed",
            dependent: :destroy
          after_create :create_feed
        end

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def feed_named(name)
        feeds.find_by(name: name)
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::HasFlexibleFeed