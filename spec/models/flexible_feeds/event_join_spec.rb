require 'spec_helper'

module FlexibleFeeds
  describe EventJoin do

    context "validates" do
      before :each do
        @event_join = FactoryGirl.build(:flexible_feeds_event_join)
      end

      it "the presence of an event" do
        expect(@event_join).to validate_presence_of :event
      end

      it "the presence of a feed" do
        expect(@event_join).to validate_presence_of :feed
      end
    end

    context "belongs to" do
      before :each do
        @event_join = FactoryGirl.build(:flexible_feeds_event_join)
      end

      it "an event" do
        expect(@event_join).to belong_to(:event)
      end

      it "a feed" do
        expect(@event_join).to belong_to(:feed)
      end
    end

  end
end
