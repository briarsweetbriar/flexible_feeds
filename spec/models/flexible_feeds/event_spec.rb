require 'spec_helper'

module FlexibleFeeds
  describe Event do

    context "validates" do
      before :each do
        @event = FactoryGirl.build(:flexible_feeds_event)
      end

      it "the presence of children_count" do
        expect(@event).to validate_presence_of :children_count
      end

      it "the that children_count is an integer greater than or equal to 0" do
        expect(@event).to validate_numericality_of(:children_count).
          only_integer.is_greater_than_or_equal_to(0)
      end

      it "the presence of controversy" do
        expect(@event).to validate_presence_of :controversy
      end

      it "the presence of an eventable" do
        expect(@event).to validate_presence_of :eventable
      end

      it "the presence of votes_sum" do
        expect(@event).to validate_presence_of :votes_sum
      end

      it "the presence of popularity" do
        expect(@event).to validate_presence_of :popularity
      end
    end

    context "belongs to" do
      before :each do
        @event = FactoryGirl.build(:flexible_feeds_event)
      end

      it "ancestor" do
        expect(@event).to belong_to(:ancestor)
      end

      it "eventable" do
        expect(@event).to belong_to(:eventable)
      end

      it "parent" do
        expect(@event).to belong_to(:parent)
      end

      it "creator" do
        expect(@event).to belong_to(:creator)
      end
    end

    context "has many" do
      before :each do
        @event = FactoryGirl.build(:flexible_feeds_event)
      end

      it "event joins" do
        expect(@event).to have_many(:event_joins).dependent(:destroy)
      end

      it "feeds" do
        expect(@event).to have_many(:feeds).through(:event_joins)
      end

      it "votes" do
        expect(@event).to have_many(:votes)
      end
    end

    context "is scoped:" do
      before :each do
        @feed = FactoryGirl.create(:flexible_feeds_feed)
        @event1 = FactoryGirl.create(:flexible_feeds_event, children_count: 10,
          votes_sum: 20, popularity: 30, controversy: 40)
        @event2 = FactoryGirl.create(:flexible_feeds_event, children_count: 20,
          votes_sum: 30, popularity: 40, controversy: 10)
        @event3 = FactoryGirl.create(:flexible_feeds_event, children_count: 30,
          votes_sum: 40, popularity: 10, controversy: 20)
        @event4 = FactoryGirl.create(:flexible_feeds_event, children_count: 40,
          votes_sum: 10, popularity: 20, controversy: 30)
        @event5 = FactoryGirl.create(:flexible_feeds_event, children_count: 100,
          votes_sum: 100, popularity: 100, controversy: 100)
        @feed.events << [@event1, @event2, @event3, @event4]
      end

      it "newest" do
        expect(@feed.events.newest.first).to eq(@event4)
      end

      it "oldest" do
        expect(@feed.events.oldest.first).to eq(@event1)
      end

      it "loudest" do
        expect(@feed.events.loudest.first).to eq(@event4)
      end

      it "quietest" do
        expect(@feed.events.quietest.first).to eq(@event1)
      end

      it "simple_popular" do
        expect(@feed.events.simple_popular.first).to eq(@event3)
      end

      it "simple_unpopular" do
        expect(@feed.events.simple_unpopular.first).to eq(@event4)
      end

      it "popular" do
        expect(@feed.events.popular.first).to eq(@event2)
      end

      it "unpopular" do
        expect(@feed.events.unpopular.first).to eq(@event3)
      end

      it "controversial" do
        expect(@feed.events.controversial.first).to eq(@event1)
      end

      it "uncontroversial" do
        expect(@feed.events.uncontroversial.first).to eq(@event2)
      end
    end

    it "can cast votes" do
      event = FactoryGirl.create(:event)
      vote = event.cast_vote(voter: FactoryGirl.create(:user), value: -1)
      expect(event.votes).to include vote
    end
  end
end
