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

        cattr_accessor :created_by
        self.created_by = options[:created_by]

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
      def creator
        send(created_by) if created_by.present?
      end

      def post_to_default_feeds
        post_to_feeds(public_send(default_feeds))
      end

      def create_event_for(destinations)
        create_event!(creator: creator) if event.nil?
        destinations.each do |feed|
          event.event_joins.create!(feed: feed) if feed.present?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsEventable