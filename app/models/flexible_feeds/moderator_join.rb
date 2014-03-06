module FlexibleFeeds
  class ModeratorJoin < ActiveRecord::Base
    belongs_to :feed
    belongs_to :moderator, polymorphic: true

    validates :feed, presence: true
    validates :moderator, presence: true
    validate :the_join_table_is_unique

    private
    def the_join_table_is_unique
      if FlexibleFeeds::ModeratorJoin.where(feed: self.feed,
        moderator: self.moderator).exists?
          errors[:base] << I18n.t("activerecord.errors.models.moderator_join.not_unique")
      end
    end
  end
end
