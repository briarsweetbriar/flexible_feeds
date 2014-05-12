module FlexibleFeeds
  module ActsAsEventable
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_eventable(options = {})

        has_one :event, as: :eventable, class_name: "FlexibleFeeds::Event",
          dependent: :destroy
        has_many :feeds, through: :event, class_name: "FlexibleFeeds::Feed"

        after_save :post_to_default_feeds

        send :include, InstanceMethods

        cattr_accessor :default_feeds
        self.default_feeds = options[:add_to_feeds] || :default_custom_feeds

        if options[:is_parent] === true
          acts_as_parent
        elsif options[:is_parent].present?
          acts_as_parent options[:is_parent]
        end

        if options[:is_child] === true
          acts_as_child
        elsif options[:is_child].present?
          acts_as_child options[:is_child]
        end
      end
    end

    module InstanceMethods
      def post_to_feeds(*destinations)
        destinations = destinations[0] if destinations[0].kind_of?(Array)
        self.class.transaction do
          create_event_for(destinations)
        end
      end

      def touch_event
        event.touch
      end

      def default_custom_feeds
        []
      end

      private
      def post_to_default_feeds
        post_to_feeds(public_send(default_feeds))
      end

      def create_event_if_nil
        create_event! if event.nil?
      end

      def create_event_for(destinations)
        create_event_if_nil
        destinations.each do |feed|
          event.event_joins.where(feed: feed).first_or_create! if feed.present?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsEventable