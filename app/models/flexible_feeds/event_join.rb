module FlexibleFeeds
  class EventJoin < ActiveRecord::Base
    belongs_to :event, class_name: "FlexibleFeeds::Event"
    belongs_to :feed, class_name: "FlexibleFeeds::Feed"

    validates :event, presence: true, uniqueness: { scope: :feed_id }
    validates :feed, presence: true
    validates :sticky, inclusion: { in: [true, false] }
  end
end
