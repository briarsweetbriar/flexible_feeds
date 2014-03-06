require 'spec_helper'

module FlexibleFeeds
  describe ActsAsFollower do

    context "has many" do
      before :each do
        @user = FactoryGirl.build(:user)
      end

      it "follows" do
        expect(@user).to have_many(:follows).
          class_name("FlexibleFeeds::Follow").dependent(:destroy)
      end

      it "followed_feeds" do
        expect(@user).to have_many(:followed_feeds).
          class_name("FlexibleFeeds::Feed")
      end
    end

    context "can list the feeds a follower follows" do
      before :each do
        @feed1 = FactoryGirl.create(:feed)
        @feed2 = FactoryGirl.create(:feed)
        @feed3 = FactoryGirl.create(:feed)
        @user = FactoryGirl.create(:user)
        @user.follow(@feed1)
        @user.follow(@feed3)
      end

      it "entirely" do
        expect(@user.followed_feeds).to include @feed1, @feed3
      end

      it "excluding unfollowed feeds" do
        expect(@user.followed_feeds).to_not include @feed2
      end
    end

    context "can create an aggregate of followed feeds" do
      before :each do
        @feed1 = FactoryGirl.create(:feed)
        @feed2 = FactoryGirl.create(:feed)
        @feed3 = FactoryGirl.create(:feed)
        @post1 = FactoryGirl.create(:post)
        @post2 = FactoryGirl.create(:post)
        @post3 = FactoryGirl.create(:post)
        @post1.post_to_feeds @feed1, @feed2
        @post2.post_to_feeds @feed2
        @post3.post_to_feeds @feed3, @feed1
        @user = FactoryGirl.create(:user)
        @user.follow(@feed1)
        @user.follow(@feed3)
      end

      it "that is called with aggregate_follows" do
        expect(@user.aggregate_follows).to include @post1.event, @post3.event
      end

      it "that excludes feeds outside of the aggregate" do
        expect(@user.aggregate_follows).to_not include @post2.event
      end

      it "that avoids duplicating events" do
        post3_count = @user.aggregate_follows.where(eventable: @post3).length
        expect(post3_count).to eq 1
      end
    end

    context "can set a follower" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "successfully" do
        @user.follow(@feed)
        expect(@feed.followers).to include @user
      end

      it "but will not set a follower twice" do
        @user.follow(@feed)
        expect(@user.follow(@feed).invalid?).to be true
      end
    end

    context "can remove a follower" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "successfully" do
        @user.follow(@feed)
        @user.unfollow(@feed)
        expect(@feed.moderators).to_not include @user
      end

      it "but not if it isn't following the feed" do
        expect(@user.unfollow(@feed)).to be false
      end
    end

    context "can tell if it" do
      before :each do
        @user = FactoryGirl.create(:user)
        @feed = FactoryGirl.create(:feed)
      end

      it "is a follower of a feed" do
        @user.follow(@feed)
        expect(@user.is_following?(@feed)).to be true
      end

      it "is not a follower of a feed" do
        expect(@user.is_following?(@feed)).to be false
      end
    end

  end
end
