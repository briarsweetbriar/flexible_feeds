module FlexibleFeeds
  class Vote < ActiveRecord::Base
    belongs_to :event
    belongs_to :voter, polymorphic: true

    validates :value, inclusion: { in: [-1, 1] }, presence: true
    validates :event, presence: true
    validates :voter, presence: true

    after_save :calculate_event_stats
    after_destroy :calculate_event_stats

    def self.cast_vote(params)
      vote = find_by(voter: params[:voter], event: params[:event])
      return create(params) if vote.nil?
      vote.toggle_by_value(params[:value])
    end

    def toggle_by_value(submitted_value)
      if value == submitted_value
        destroy
      else
        update_attributes(value: submitted_value)
      end
    end

    private
    def calculate_event_stats
      event.calculate_stats
    end
  end
end
