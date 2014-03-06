module FlexibleFeeds
  class Follow < ActiveRecord::Base
    belongs_to :follower, polymorphic: true
    belongs_to :feed

    validates :follower, presence: true
    validates :feed, presence: true
    validate :the_join_table_is_unique

    private
    def the_join_table_is_unique
      if FlexibleFeeds::Follow.where(feed: self.feed, follower: self.follower).
        exists?
          errors[:base] << I18n.t("activerecord.errors.models.follow.not_unique")
      end
    end
  end
end
