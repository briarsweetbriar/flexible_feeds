require 'spec_helper'

module FlexibleFeeds
  describe Feed do

    it "validates a unique name within the scope of its feedable" do
      group = FactoryGirl.create(:group)
      group.feeds.create(name: "My Feed")
      expect(group.feeds.create(name: "My Feed").invalid?).to be true
    end

    context "belongs to" do
      before :each do
        @feed = FactoryGirl.build(:flexible_feeds_feed)
      end

      it "feedable" do
        expect(@feed).to belong_to(:feedable)
      end
    end

    context "has many" do
      before :each do
        @feed = FactoryGirl.build(:flexible_feeds_feed)
      end

      it "event joins" do
        expect(@feed).to have_many(:event_joins).dependent(:destroy)
      end

      it "events" do
        expect(@feed).to have_many(:events).through(:event_joins)
      end

      it "follows" do
        expect(@feed).to have_many(:follows).dependent(:destroy)
      end

      it "moderator joins" do
        expect(@feed).to have_many(:moderator_joins).dependent(:destroy)
      end
    end

    context "manages polymorphic moderators" do
      before :each do
        @feed = FactoryGirl.create(:flexible_feeds_feed)
        @user = FactoryGirl.create(:user)
      end

      it "by adding and listing them" do
        @feed.add_moderator(@user)
        expect(@feed.moderators).to include(@user)
      end

      it "by refusing to add moderators that are already moderators" do
        @feed.add_moderator(@user)
        expect(@feed.add_moderator(@user).invalid?).to be true
      end

      it "by checking if someone is a moderator" do
        @feed.add_moderator(@user)
        expect(@feed.moderators_include?(@user)).to be true
      end

      it "by checking if someone is not a moderator" do
        expect(@feed.moderators_include?(@user)).to be false
      end

      it "by removing them" do
        @feed.add_moderator(@user)
        @feed.remove_moderator(@user)
        expect(@feed.moderators).to_not include(@user)
      end

      it "by only attempting to remove moderators that are present" do
        @feed.remove_moderator(@user)
        expect(@feed.remove_moderator(@user)).to be false
      end
    end

    context "manages polymorphic followers" do
      before :each do
        @feed = FactoryGirl.create(:flexible_feeds_feed)
        @user = FactoryGirl.create(:user)
      end

      it "by adding and listing them" do
        @feed.add_follower(@user)
        expect(@feed.followers).to include(@user)
      end

      it "by checking if someone is a follower" do
        @feed.add_follower(@user)
        expect(@feed.followers_include?(@user)).to be true
      end

      it "by checking if someone is not a follower" do
        expect(@feed.followers_include?(@user)).to be false
      end

      it "by removing them" do
        @feed.add_follower(@user)
        @feed.remove_follower(@user)
        expect(@feed.followers).to_not include(@user)
      end
    end
  end
end
