module FlexibleFeeds
  class Feed < ActiveRecord::Base
    include FlexibleFeeds::PolymorphicJoin

    belongs_to :feedable, polymorphic: true

    has_many :event_joins, dependent: :destroy
    has_many :events, through: :event_joins
    has_many :follows, dependent: :destroy
    has_many :moderator_joins, dependent: :destroy

    polymorphically_joined_through :moderator_joins,
                                    association_name: :moderators,
                                    singular_association_name: :moderator

    polymorphically_joined_through :follows,
                                    association_name: :followers,
                                    singular_association_name: :follower

    validate :unique_name_per_feedable

    private
    def unique_name_per_feedable
      if feedable.present? && feedable.respond_to?(:feeds) &&
        feedable.feed_named(self.name).present?
          errors[:base] << I18n.t("activerecord.errors.models.feed.attributes.name.not_unique")
      end
    end

  end
end
