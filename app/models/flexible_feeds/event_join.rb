module FlexibleFeeds
  class EventJoin < ActiveRecord::Base
    belongs_to :event
    belongs_to :feed

    validates :event, presence: true
    validates :feed, presence: true
    validates :sticky, inclusion: { in: [true, false] }
  end
end
