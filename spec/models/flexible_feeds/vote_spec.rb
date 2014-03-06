require 'spec_helper'

module FlexibleFeeds
  describe Vote do

    context "validates" do
      before :each do
        @vote = FactoryGirl.build(:flexible_feeds_vote)
      end

      it "the presence of an event" do
        expect(@vote).to validate_presence_of :event
      end

      it "the presence of a value" do
        expect(@vote).to validate_presence_of :value
      end

      it "that the value is -1 or 1" do
        expect(@vote).to ensure_inclusion_of(:value).in_array([-1, 1])
      end

      it "the presence of a voter" do
        expect(@vote).to validate_presence_of :voter
      end
    end

    context "belongs to" do
      before :each do
        @vote = FactoryGirl.build(:flexible_feeds_vote)
      end

      it "event" do
        expect(@vote).to belong_to(:event)
      end

      it "voter" do
        expect(@vote).to belong_to(:voter)
      end
    end

    context "handles voting" do
      before :each do
        @event = FactoryGirl.create(:flexible_feeds_event)
        @user = FactoryGirl.create(:user)
      end

      it "by creating new votes" do
        vote = @event.cast_vote(voter: @user, value: -1)
        expect(vote.value).to eq -1
      end

      it "by updating votes to newly submitted values" do
        vote = @event.cast_vote(voter: @user, value: -1)
        @event.cast_vote(voter: @user, value: 1)
        vote.reload
        expect(vote.value).to eq 1
      end

      it "by deleting repeat votes" do
        vote = @event.cast_vote(voter: @user, value: -1)
        @event.cast_vote(voter: @user, value: -1)
        expect(Vote.find_by(id: vote.id)).to be nil
      end
    end

    context "adjusts the stats of its event by" do
      before :each do
        @event = FactoryGirl.create(:flexible_feeds_event)
        @event.cast_vote(voter: FactoryGirl.create(:user), value: 1)
        @event.cast_vote(voter: FactoryGirl.create(:user), value: 1)
        @event.cast_vote(voter: FactoryGirl.create(:user), value: -1)
      end

      it "summing the event's votes" do
        expect(@event.votes_sum).to eq 1
      end

      it "summing the votes for the event" do
        expect(@event.votes_for).to eq 2
      end

      it "summing the votes against the event" do
        expect(@event.votes_for).to eq 2
      end

      it "calculating the event's controversy" do
        expect(@event.controversy).to eq 50
      end

      it "calculating the event's popularity" do
        expect(@event.popularity).to eq @event.send(:calculate_popularity,
          @event.votes_for, @event.votes_against + @event.votes_for)
      end
    end
  end
end
