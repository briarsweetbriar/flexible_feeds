require 'spec_helper'

module FlexibleFeeds
  describe ActsAsModerator do

    context "has many" do
      before :each do
        @user = FactoryGirl.build(:user)
      end

      it "moderator_joins" do
        expect(@user).to have_many(:moderator_joins).
          class_name("FlexibleFeeds::ModeratorJoin").dependent(:destroy)
      end

      it "moderated_feeds" do
        expect(@user).to have_many(:moderated_feeds).
          class_name("FlexibleFeeds::Feed")
      end
    end

    context "can list the feeds a moderator moderates" do
      before :each do
        @feed1 = FactoryGirl.create(:feed)
        @feed2 = FactoryGirl.create(:feed)
        @feed3 = FactoryGirl.create(:feed)
        @user = FactoryGirl.create(:user)
        @user.moderate(@feed1)
        @user.moderate(@feed3)
      end

      it "entirely" do
        expect(@user.moderated_feeds).to include @feed1, @feed3
      end

      it "excluding unmoderated feeds" do
        expect(@user.moderated_feeds).to_not include @feed2
      end
    end

    context "can set a moderator" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "successfully" do
        @user.moderate(@feed)
        expect(@feed.moderators).to include @user
      end

      it "but will not set a moderator twice" do
        @user.moderate(@feed)
        expect(@user.moderate(@feed).invalid?).to be true
      end
    end

    context "can remove a moderator" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "successfully" do
        @user.moderate(@feed)
        @user.unmoderate(@feed)
        expect(@feed.moderators).to_not include @user
      end

      it "but not if it isn't moderating the feed" do
        expect(@user.unmoderate(@feed)).to be false
      end
    end

    context "can tell if it" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "is a moderator of a feed" do
        @user.moderate(@feed)
        expect(@user.is_moderating?(@feed)).to be true
      end

      it "is not a moderator of a feed" do
        expect(@user.is_moderating?(@feed)).to be false
      end
    end

  end
end
