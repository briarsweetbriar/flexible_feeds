module FlexibleFeeds
  class Event < ActiveRecord::Base
    belongs_to :ancestor, class_name: "FlexibleFeeds::Event"
    belongs_to :creator, polymorphic: true
    belongs_to :eventable, polymorphic: true
    belongs_to :parent, class_name: "FlexibleFeeds::Event"

    has_many :children, class_name: "FlexibleFeeds::Event",
      foreign_key: :parent_id
    has_many :event_joins, dependent: :destroy
    has_many :feeds, through: :event_joins
    has_many :votes

    validates :children_count, presence: true,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :controversy, presence: true
    validates :eventable, presence: true
    validates :votes_sum, presence: true
    validates :popularity, presence: true

    scope :newest, -> { order("updated_at DESC") }
    scope :oldest, -> { order("updated_at ASC") }
    scope :loudest, -> { order("children_count DESC") }
    scope :quietest, -> { order("children_count ASC") }
    scope :simple_popular, -> { order("votes_sum DESC") }
    scope :simple_unpopular, -> { order("votes_sum ASC") }
    scope :popular, -> { order("popularity DESC") }
    scope :unpopular, -> { order("popularity ASC") }
    scope :controversial, -> { order("controversy DESC") }
    scope :uncontroversial, -> { order("controversy ASC") }

    def cast_vote(params)
      Vote.cast_vote(params.merge({event: self}))
    end

    def calculate_stats
      self.votes_for = votes.where(value: 1).count
      self.votes_against = votes.where(value: -1).count
      self.votes_sum = votes_for - votes_against
      self.controversy = calculate_controversy(votes_for, votes_against)
      self.popularity = calculate_popularity(votes_for,
        votes_for + votes_against)
      save
    end

    private
    def calculate_controversy(pos, neg)
      return 0 if pos == 0 || neg == 0
      100.0 * (pos > neg ? neg.to_f / pos.to_f : pos.to_f / neg.to_f)
    end

    # Thanks to Evan Miller
    # http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
    def calculate_popularity(pos, n)
      PopularityCalculator.new(pos, n).get_popularity
    end
  end
end
