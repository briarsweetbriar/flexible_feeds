require 'spec_helper'

module FlexibleFeeds
  describe ActsAsEventable do

    context "has many" do
      before :each do
        @post = FactoryGirl.build(:post)
      end

      it "events" do
        expect(@post).to have_one(:event).class_name("FlexibleFeeds::Event").
          dependent(:destroy)
      end

      it "feeds" do
        expect(@post).to have_many(:feeds).class_name("FlexibleFeeds::Feed")
      end
    end

    context "after_create" do
      before :each do
        @feed = FactoryGirl.create(:flexible_feeds_feed)
        @feed2 = FactoryGirl.create(:flexible_feeds_feed)
        @post = FactoryGirl.create(:feed_post)
      end

      it "posts to the feeds in default_feeds" do
        expect(@post.feeds).to include(@feed, @feed2)
      end
    end

    context "posts to feeds" do
      before :each do
        @post = FactoryGirl.create(:post)
      end

      it "one at a time" do
        feed = FactoryGirl.create(:flexible_feeds_feed)
        @post.post_to_feeds(feed)
        expect(@post.feeds).to include(feed)
      end

      it "in multiple" do
        feed = FactoryGirl.create(:flexible_feeds_feed)
        feed2 = FactoryGirl.create(:flexible_feeds_feed)
        @post.post_to_feeds(feed, feed2)
        expect(@post.feeds).to include(feed, feed2)
      end
    end

    context "assigns a creator" do
      it "when the creator argument is set and a creator is provided" do
        user = FactoryGirl.create(:user)
        post = Post.create(author: user)
        expect(post.event.creator).to eq user
      end

      it "unless a creator is not provided" do
        post = FactoryGirl.create(:post)
        expect(post.event.creator).to eq nil
      end

      it "unless it doesn't have a creator argument" do
        user = FactoryGirl.create(:user)
        post = FeedPost.create(author: user)
        expect(post.event.creator).to eq nil
      end
    end

    it "can touch its event so that they bubble up in a date-sorted list" do
      feed = FactoryGirl.create(:flexible_feeds_feed)
      post = FactoryGirl.create(:feed_post)
      post2 = FactoryGirl.create(:feed_post)
      expect(feed.events.newest.first.eventable).to eq(post2)
      post.touch_event
      expect(feed.events.newest.first.eventable).to eq(post)
    end

  end
end
