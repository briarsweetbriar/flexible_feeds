class FeedPost < ActiveRecord::Base
  attr_accessor :author
  
  acts_as_eventable add_to_feeds: :custom_feeds

  def custom_feeds
    [FlexibleFeeds::Feed.first, FlexibleFeeds::Feed.last]
  end
end
